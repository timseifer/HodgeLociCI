// TS-T6 (AI-generated, unreviewed): copy of SP-T6's fsc.cpp (product machinery unchanged) with the period accumulator
// replaced by the Thom-Sebastiani functional Psi(x^g) = Psi_A(g_0..g_5) * PB[g_6..g_11] (Psi_A = Fermat closed form on
// pairs 0-2 with pattern values aval[3-bit choice]; PB = table of Psi_B^Q1 + lambda Psi_B^Q2 on 6-variable monomials,
// index OFF[D] + rank (key order)).
// Original header: SP-T6 [TOOLING]: compiled kernel for one level of the Fermat period expansion (W3 engine, w3eng.py).
//   E'_n = sum_t coef_t * T_t * E_t    (T_t small sparse cubic polys, E_t big sorted polys; keys = packed exponents,
//   5 bits per variable, 12 variables), all arithmetic mod p (p < 2^31).
// Output: (optional) E'_n as sorted unique keys with nonzero values in [0, p), and the accumulator
//   acc[cmap[s]] += Psi_P(x^s * E'_n) for the codes s in {0,1,2}^12 with |s| <= 6, exactly as w3eng.W3Engine.H_acc.
// Work is split into target buckets (exponents of the top NF variables = top 5*NF bits of a key); buckets are independent and
// are processed in parallel (OpenMP), with results concatenated in increasing bucket order, so the output does not
// depend on the number of threads.  Exact integer arithmetic throughout.
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <algorithm>
#include <cstdio>
#include <chrono>
static double now_s() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
#ifdef _OPENMP
#include <omp.h>
#endif

#ifndef NF
#define NF 4
#endif
static const int NV = 12, SH = 5, BSHIFT = 60 - 5 * NF, NB = 1 << (5 * NF);
typedef int64_t i64; typedef uint64_t u64;

struct Ctx {
    i64 p;
    const i64 *pb;      // pochhammer table pb[r*40 + m], r in {0,1}
    const i64 *tab;     // t value per 6-bit choice (bit k = 1 <=> r_a = 1 in pair k)
    const i64 *cmap;    // code (base 3) -> compact index, -1 if |s| > 6
    const uint8_t *vis; // optional: visibility per residue code (base 3), or null
    int nk;
    const i64 *aval;    // 8 values: x-part pattern value per 3-bit choice (bit k = 1 <=> r_a = 1 in pair k)
    const i64 *PB;      // B-part table
    const i64 *OFF;     // OFF[D] = index of the first monomial of degree D; OFF[Dmax+1] = size
    int Dmax;
};
static int g_err = 0;
static i64 CBT[80][8];
static void init_cb() { for (int n = 0; n < 80; n++) for (int k = 0; k < 8; k++) { if (k == 0) CBT[n][k] = 1; else if (n == 0) CBT[n][k] = 0; else CBT[n][k] = CBT[n-1][k-1] + CBT[n-1][k]; } }
// s_y list: 729 entries sorted by degree: code (base 3, offset 3^6), degree, exps
static int SY_code[729], SY_deg[729], SY_e[729][6];
static void init_sy() {
    int n = 0;
    for (int d = 0; d <= 12; d++) for (int c = 0; c < 729; c++) {
        int x = c, e[6], s = 0; for (int j = 0; j < 6; j++) { e[j] = x % 3; x /= 3; s += e[j]; }
        if (s != d) continue;
        SY_code[n] = c * 729; SY_deg[n] = d; for (int j = 0; j < 6; j++) SY_e[n][j] = e[j]; n++;
    }
}

struct FM { i64 p; double pinv; };
// a*b mod p for 0 <= a, b < p < 2^26 (a*b < 2^52 is exact in a double)
static inline i64 mm(const FM &f, i64 a, i64 b) {
    i64 x = a * b; i64 q = (i64)((double)x * f.pinv); i64 r = x - q * f.p;
    if (r < 0) r += f.p; else if (r >= f.p) r -= f.p;
    if (r >= f.p) r -= f.p; if (r < 0) r += f.p;
    return r;
}

// Per residue class rho = e mod 3 (base-3 code, 3^12 classes) the valid (pattern, code) pairs do not depend on e:
// list them once.  Entry: bits 0..5 = ch (pattern), bits 6..31 = compact code index; per class a mask of the
// left/right halves used.  Built lazily, cached by (p, tab, cmap) content.
struct ClassTab { i64 p = -1; std::vector<i64> tab; std::vector<i64> cm; std::vector<uint32_t> off; std::vector<uint32_t> ent; std::vector<uint16_t> mask; };
static ClassTab g_ct;
static const int POW3[NV] = {1, 3, 9, 27, 81, 243, 729, 2187, 6561, 19683, 59049, 177147};
static const int MOD3[6] = {0, 1, 2, 0, 1, 2};
static const ClassTab &class_tab(const Ctx &C) {
    #pragma omp critical(fsc_ct)
    {
    bool same = g_ct.p == C.p && (int)g_ct.cm.size() == 531441 && std::equal(g_ct.tab.begin(), g_ct.tab.end(), C.tab)
                && std::equal(g_ct.cm.begin(), g_ct.cm.end(), C.cmap);
    if (!same) {
        ClassTab T; T.p = C.p; T.tab.assign(C.tab, C.tab + 64); T.cm.assign(C.cmap, C.cmap + 531441);
        T.off.assign(531442, 0); T.mask.assign(531441, 0);
        for (int rc = 0; rc < 531441; rc++) {
            int rho[NV]; int x = rc; for (int i = 0; i < NV; i++) { rho[i] = x % 3; x /= 3; }
            int oc[6][2], od[6][2];
            for (int k = 0; k < 6; k++) for (int o = 0; o < 2; o++) {
                int sa = MOD3[o - rho[2 * k] + 3], sb = MOD3[1 - o - rho[2 * k + 1] + 3];
                oc[k][o] = sa * POW3[2 * k] + sb * POW3[2 * k + 1]; od[k][o] = sa + sb; }
            T.off[rc] = (uint32_t)T.ent.size();
            for (int ch = 0; ch < 64; ch++) {
                if (C.tab[ch] == 0) continue;
                int d = 0, code = 0;
                for (int k = 0; k < 6; k++) { int o = (ch >> k) & 1; d += od[k][o]; code += oc[k][o]; }
                if (d > 6) continue;
                T.ent.push_back((uint32_t)ch | ((uint32_t)C.cmap[code] << 6));
                T.mask[rc] |= (uint16_t)((1u << (ch & 7)) | (1u << (8 + (ch >> 3))));
            }
        }
        T.off[531441] = (uint32_t)T.ent.size();
        g_ct = std::move(T);
    }
    }
    return g_ct;
}

static inline void H_term(const Ctx &C, const ClassTab &CT, const i64 *PP, i64 key, i64 c, u64 *acc) {
    (void)CT;
    int e[NV];
    for (int i = 0; i < NV; i++) e[i] = (int)((key >> (SH * i)) & 31);
    const FM f{C.p, 1.0 / (double)C.p};
    i64 cc = c % C.p;
    i64 owk[3][2]; int ocode[3][2], odeg[3][2];
    for (int k = 0; k < 3; k++) {
        int a = 2 * k, b = 2 * k + 1, ra = e[a] % 3, rb = e[b] % 3;
        for (int o = 0; o < 2; o++) {
            int sa = MOD3[o - ra + 3], sb = MOD3[1 - o - rb + 3];
            owk[k][o] = PP[(o * 40 + (sa + e[a]) / 3) * 40 + (sb + e[b]) / 3];
            ocode[k][o] = sa * POW3[a] + sb * POW3[b]; odeg[k][o] = sa + sb;
        }
    }
    i64 wA[8]; int cA[8], dA[8], dmin = 99;
    for (int h = 0; h < 8; h++) {
        int o0 = h & 1, o1 = (h >> 1) & 1, o2 = h >> 2;
        wA[h] = mm(f, mm(f, mm(f, mm(f, owk[0][o0], owk[1][o1]), owk[2][o2]), C.aval[h]), cc);
        cA[h] = ocode[0][o0] + ocode[1][o1] + ocode[2][o2];
        dA[h] = odeg[0][o0] + odeg[1][o1] + odeg[2][o2];
        if (wA[h] == 0) dA[h] = 99;
        if (dA[h] < dmin) dmin = dA[h];
    }
    if (dmin > 6) return;
    int Dy = 0; for (int j = 6; j < 12; j++) Dy += e[j];
    for (int q = 0; q < 729; q++) {
        int sd = SY_deg[q];
        if (sd > 6 - dmin) break;
        int D = Dy + sd;
        if (D % 3) continue;
        if (D > C.Dmax) { g_err = 1; continue; }
        // rank of y = e_y + s_y inside degree D (key order, var 5 most significant)
        i64 r = 0; int R = D;
        for (int j = 5; j >= 1; j--) { int ej = e[6 + j] + SY_e[q][j]; r += CBT[R + j][j] - CBT[R - ej + j][j]; R -= ej; }
        i64 v = C.PB[C.OFF[D] + r];
        if (v == 0) continue;
        int cy = SY_code[q];
        for (int h = 0; h < 8; h++) {
            if (dA[h] + sd > 6) continue;
            acc[C.cmap[cA[h] + cy]] += (u64)mm(f, wA[h], v);
        }
    }
}
static void make_PP(const Ctx &C, std::vector<i64> &PP) {
    // PP[(o*40 + ma)*40 + mb] = pb[ra][ma] * pb[rb][mb] mod p, (ra, rb) = (o, 1 - o)
    PP.assign(2 * 40 * 40, 0); const FM f{C.p, 1.0 / (double)C.p};
    for (int o = 0; o < 2; o++) for (int ma = 0; ma < 40; ma++) for (int mb = 0; mb < 40; mb++)
        PP[(o * 40 + ma) * 40 + mb] = mm(f, C.pb[o * 40 + ma] % C.p, C.pb[(1 - o) * 40 + mb] % C.p);
}
static void flush2(const Ctx &C, const u64 *acc, i64 *acc_out_add) {
    for (int j = 0; j < C.nk; j++) acc_out_add[j] = (acc_out_add[j] + (i64)(acc[j] % (u64)C.p)) % C.p;
}

// fieldwise add / subtract of bucket ids (3 fields of 5 bits); returns -1 if a field underflows or overflows
static inline int bsub(int B, int d) {
    int r = 0;
    for (int f = 0; f < NF; f++) { int x = ((B >> (5 * f)) & 31) - ((d >> (5 * f)) & 31); if (x < 0) return -1; r |= x << (5 * f); }
    return r;
}
static inline int badd(int B, int d) {
    int r = 0;
    for (int f = 0; f < NF; f++) { int x = ((B >> (5 * f)) & 31) + ((d >> (5 * f)) & 31); if (x > 31) return -1; r |= x << (5 * f); }
    return r;
}

struct Hash {
    std::vector<i64> k; std::vector<i64> v; std::vector<uint8_t> used; std::vector<uint32_t> slots; size_t mask = 0;
    void init(size_t cap) { size_t s = 1024; while (s < 2 * cap) s <<= 1; k.assign(s, 0); v.assign(s, 0); used.assign(s, 0); mask = s - 1; slots.clear(); }
    void clear() { for (uint32_t i : slots) used[i] = 0; slots.clear(); }
    static inline size_t hsh(i64 x) { u64 h = (u64)x * 0x9E3779B97F4A7C15ULL; return (size_t)(h ^ (h >> 29)); }
    void grow() {
        std::vector<i64> ok, ov; ok.reserve(slots.size()); ov.reserve(slots.size());
        for (uint32_t i : slots) { ok.push_back(k[i]); ov.push_back(v[i]); }
        init((mask + 1));
        for (size_t i = 0; i < ok.size(); i++) ins_new(ok[i], ov[i]);
    }
    inline void ins_new(i64 key, i64 val) {
        size_t h = hsh(key) & mask;
        while (used[h]) h = (h + 1) & mask;
        used[h] = 1; k[h] = key; v[h] = val; slots.push_back((uint32_t)h);
    }
    inline void add(i64 key, i64 val, i64 p) {
        size_t h = hsh(key) & mask;
        while (used[h] && k[h] != key) h = (h + 1) & mask;
        if (!used[h]) {
            if (2 * (slots.size() + 1) > mask + 1) { grow(); add(key, val, p); return; }
            used[h] = 1; k[h] = key; v[h] = val; slots.push_back((uint32_t)h);
        } else { i64 s = v[h] + val; if (s >= p) s -= p; v[h] = s; }
    }
    // unreduced accumulate: 0 <= val < 2^52; stored sums kept below 2^62 (reduced mod p when they reach it)
    inline void addu(i64 key, i64 val) {
        size_t h = hsh(key) & mask;
        while (used[h] && k[h] != key) h = (h + 1) & mask;
        if (!used[h]) {
            if (2 * (slots.size() + 1) > mask + 1) { grow(); addu(key, val); return; }
            used[h] = 1; k[h] = key; v[h] = val; slots.push_back((uint32_t)h);
        } else { u64 s = (u64)v[h] + (u64)val; if (s >> 62) s %= (u64)pmod; v[h] = (i64)s; }
    }
    i64 pmod = 1;
};

static std::vector<std::vector<i64>> g_rk; static std::vector<std::vector<int32_t>> g_rv;
extern "C" {
// copy the results of the last fsc_level(store = 1) call into keys/vals (sizes = its return value), freeing as it goes
void tsk_fetch(i64 *keys, int32_t *vals) {
    i64 o = 0;
    for (size_t bi = 0; bi < g_rk.size(); bi++) {
        memcpy(keys + o, g_rk[bi].data(), sizeof(i64) * g_rk[bi].size());
        memcpy(vals + o, g_rv[bi].data(), sizeof(int32_t) * g_rv[bi].size());
        o += (i64)g_rk[bi].size(); std::vector<i64>().swap(g_rk[bi]); std::vector<int32_t>().swap(g_rv[bi]);
    }
    g_rk.clear(); g_rv.clear();
}

// terms: nt terms; term t has small poly (tk + toff[t], tv + toff[t], toff[t+1]-toff[t] entries) and big poly
// (ek[t], ev[t] as pointers, elen[t] entries, vals int64 if ev_is64[t] else int32).  coef[t] in [0,p).
// If store: *out_keys/*out_vals (malloc'd, caller frees with fsc_free) and *out_n are set.
// acc_out: nk int64, overwritten with the H accumulator of this level (mod p).  Returns number of output terms.
i64 tsk_level(const i64 *aval, const i64 *PB, const i64 *OFF, int Dmax, int nt, const i64 *coef, const i64 *tk, const i64 *tv, const i64 *toff,
              const i64 **ek, const void **ev, const int *ev_is64, const i64 *elen,
              i64 p, const i64 *pb, const i64 *tab, const i64 *cmap, int nk, const uint8_t *vis,
              int store, int nthreads, i64 **out_keys, int32_t **out_vals, i64 *acc_out) {
    if (p >= (1LL << 26)) return -1;
    Ctx C{p, pb, tab, cmap, vis, nk, aval, PB, OFF, Dmax}; init_cb(); init_sy(); g_err = 0;
    // bucket index of each big poly: dense map bucket id -> range number (int32, -1 if absent)
    std::vector<std::vector<int32_t>> bmap(nt); std::vector<std::vector<i64>> rs(nt), re(nt);
    std::vector<uint8_t> target(NB, 0);
    for (int t = 0; t < nt; t++) {
        bmap[t].assign(NB, -1);
        i64 n = elen[t]; i64 i = 0;
        while (i < n) {
            int b = (int)(ek[t][i] >> BSHIFT); i64 j = i;
            while (j < n && (int)(ek[t][j] >> BSHIFT) == b) j++;
            bmap[t][b] = (int32_t)rs[t].size(); rs[t].push_back(i); re[t].push_back(j); i = j;
        }
        for (size_t r = 0; r < rs[t].size(); r++) {
            int b = (int)(ek[t][rs[t][r]] >> BSHIFT);
            for (i64 q = toff[t]; q < toff[t + 1]; q++) { int B = badd(b, (int)(tk[q] >> BSHIFT)); if (B >= 0) target[B] = 1; }
        }
    }
    std::vector<int> tl; for (int b = 0; b < NB; b++) if (target[b]) tl.push_back(b);
    int nB = (int)tl.size();
    std::vector<std::vector<i64>> rk(store ? nB : 0); std::vector<std::vector<int32_t>> rv(store ? nB : 0);
    std::vector<i64> cnt(nB, 0);
    int nth = nthreads > 0 ? nthreads : 1;
    double T_hash = 0, T_H = 0, T_rest = 0; i64 NRAW = 0;
    std::vector<std::vector<u64>> accs(nth, std::vector<u64>((size_t)nk, 0));
    std::vector<i64> PP; make_PP(C, PP);
    static ClassTab CTd; const ClassTab &CT = CTd;
#ifdef _OPENMP
    #pragma omp parallel for schedule(dynamic, 1) num_threads(nth)
#endif
    for (int bi = 0; bi < nB; bi++) {
        int th = 0;
#ifdef _OPENMP
        th = omp_get_thread_num();
#endif
        double t0 = now_s();
        static thread_local Hash Hh; static thread_local int inited = 0;
        if (!inited) { Hh.init(1 << 16); inited = 1; } else Hh.clear();
        Hh.pmod = p;
        i64 nraw_b = 0;
        int B = tl[bi]; const FM fm{p, 1.0 / (double)p};
        for (int t = 0; t < nt; t++) {
            i64 cf = coef[t];
            for (i64 q = toff[t]; q < toff[t + 1]; q++) {
                int src = bsub(B, (int)(tk[q] >> BSHIFT)); if (src < 0) continue;
                int32_t r = bmap[t][src]; if (r < 0) continue;
                i64 s = rs[t][r], e = re[t][r];
                i64 tvc = mm(fm, tv[q] % p, cf % p), tkey = tk[q]; nraw_b += e - s;
                if (ev_is64[t]) { const i64 *V = (const i64 *)ev[t];
                    for (i64 i = s; i < e; i++) Hh.addu(ek[t][i] + tkey, V[i] * tvc);
                } else { const int32_t *V = (const int32_t *)ev[t];
                    for (i64 i = s; i < e; i++) Hh.addu(ek[t][i] + tkey, (i64)V[i] * tvc);
                }
            }
        }
        double tA = now_s();
        // collect nonzero entries
        std::vector<std::pair<i64, i64>> ent; ent.reserve(Hh.slots.size());
        for (uint32_t i : Hh.slots) if (Hh.v[i] % p) ent.push_back({Hh.k[i], Hh.v[i] % p});
        u64 *acc = accs[th].data();
        for (auto &kv : ent) {
            H_term(C, CT, PP.data(), kv.first, kv.second, acc);
        }
        double tB = now_s();
        cnt[bi] = (i64)ent.size();
        double tC0 = now_s();
        if (store) {
            std::sort(ent.begin(), ent.end());
            rk[bi].resize(ent.size()); rv[bi].resize(ent.size());
            for (size_t i = 0; i < ent.size(); i++) { rk[bi][i] = ent[i].first; rv[bi][i] = (int32_t)ent[i].second; }
        }
        #pragma omp critical
        { T_hash += tA - t0; T_H += tB - tA; T_rest += now_s() - tC0; NRAW += nraw_b; }
    }
    if (getenv("FSC_TIME")) fprintf(stderr, "fsc: buckets %d hash %.2fs H %.2fs rest %.2fs raw %lld\n", nB, T_hash, T_H, T_rest, (long long)NRAW);
    for (int j = 0; j < nk; j++) acc_out[j] = 0;
    for (int th = 0; th < nth; th++) flush2(C, accs[th].data(), acc_out);
    i64 tot = 0; for (int bi = 0; bi < nB; bi++) tot += cnt[bi];
    if (store) {
        // keep the per-bucket results; the caller allocates arrays of size tot and calls fsc_fetch (no extra copy)
        g_rk.swap(rk); g_rv.swap(rv);
        (void)out_keys; (void)out_vals;
    }
    return tot;
}

void tsk_free(void *ptr) { free(ptr); }

// H accumulator of a given poly (for checks)
void tsk_H(const i64 *aval, const i64 *PB, const i64 *OFF, int Dmax, i64 n, const i64 *keys, const i64 *vals, i64 p, const i64 *pb, const i64 *tab, const i64 *cmap, int nk,
           const uint8_t *vis, i64 *acc_out) {
    Ctx C{p, pb, tab, cmap, vis, nk, aval, PB, OFF, Dmax}; init_cb(); init_sy(); g_err = 0;
    std::vector<i64> PP; make_PP(C, PP);
    std::vector<u64> acc2((size_t)nk, 0); static ClassTab CTd; const ClassTab &CT = CTd;
    for (i64 i = 0; i < n; i++) H_term(C, CT, PP.data(), keys[i], vals[i] % p, acc2.data());
    for (int j = 0; j < nk; j++) acc_out[j] = 0;
    flush2(C, acc2.data(), acc_out);
}
}

extern "C" int tsk_err() { return g_err; }
