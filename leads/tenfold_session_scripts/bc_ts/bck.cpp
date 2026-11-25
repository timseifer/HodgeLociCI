// [BC-TS] (AI-generated, unreviewed) blind checker kernel: sparse polynomial products (hash accumulate) and the split
// period accumulator H(s) = sum_e c_e PsiA(eA + sA) PsiB(eB + sB) for s in {0,1,2}^12, |s| in {3, 6}.
// Key layout (own): exponent of x_i at bits 5*(11-i)  (x0 highest), so sorted keys are grouped by the A-part x0..x5.
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <vector>
typedef int64_t i64; typedef uint64_t u64;
static const u64 EMPTY = ~0ULL;
struct HT { u64 cap, mask, n; u64* k; i64* v; };
static inline u64 hsh(u64 x) { x ^= x >> 33; x *= 0xff51afd7ed558ccdULL; x ^= x >> 33; x *= 0xc4ceb9fe1a85ec53ULL; x ^= x >> 33; return x; }
extern "C" {
void* ht_new(u64 cap) {
    u64 c = 1; while (c < cap) c <<= 1;
    HT* t = new HT; t->cap = c; t->mask = c - 1; t->n = 0;
    t->k = (u64*)malloc(c * 8); t->v = (i64*)malloc(c * 8);
    memset(t->k, 0xff, c * 8); return t;
}
void ht_free(void* h) { HT* t = (HT*)h; free(t->k); free(t->v); delete t; }
i64 ht_count(void* h) { return ((HT*)h)->n; }
int ht_mul_acc(void* h, const i64* tk, const i64* tv, i64 nT, const i64* ek, const i64* ev, i64 nE, i64 coef, i64 p) {
    HT* t = (HT*)h;
    for (i64 a = 0; a < nT; a++) {
        i64 ca = (i64)((__int128)coef * tv[a] % p);
        if (ca == 0) continue;
        for (i64 b = 0; b < nE; b++) {
            u64 key = (u64)tk[a] + (u64)ek[b];
            i64 val = ca * ev[b] % p;
            u64 s = hsh(key) & t->mask;
            while (true) {
                if (t->k[s] == key) { t->v[s] = (t->v[s] + val) % p; break; }
                if (t->k[s] == EMPTY) { t->k[s] = key; t->v[s] = val; t->n++; if (2 * t->n > t->cap) return -1; break; }
                s = (s + 1) & t->mask;
            }
        }
    }
    return 0;
}
i64 ht_extract(void* h, i64* keys, i64* vals) {
    HT* t = (HT*)h; i64 m = 0;
    for (u64 s = 0; s < t->cap; s++) if (t->k[s] != EMPTY && t->v[s] != 0) { keys[m] = (i64)t->k[s]; vals[m] = t->v[s]; m++; }
    return m;
}

static i64 BIN[64][8];
static void initbin() { for (int a = 0; a < 64; a++) for (int b = 0; b < 8; b++) { if (b == 0) BIN[a][b] = 1; else if (a == 0) BIN[a][b] = 0; else BIN[a][b] = BIN[a - 1][b - 1] + BIN[a - 1][b]; } }
static inline i64 rank6(const int* e) { i64 s = 0, r = 0; for (int k = 0; k < 5; k++) { s += e[k]; r += BIN[s + k][k + 1]; } return r; }

// H over codes s = sum s_i 3^i (i = 0..11), output Hout[531441] (mod p), only |s| in {3, 6} filled.
// PB: flat B table (PB1 + lam PB2), OFF[d] = start of degree d (own order rank6); PT[2*40] poch; cA0 = 3z, cA1 = 3z^2.
int Hsplit(const i64* keys, const i64* vals, i64 n, const i64* PB, const i64* OFF, int Dmax, const i64* PT, i64 cA0, i64 cA1, i64 p, i64* Hout) {
    initbin();
    // sB lists by weight
    std::vector<int> sl[7]; std::vector<std::vector<int>> sexp(729, std::vector<int>(6));
    for (int c = 0; c < 729; c++) { int x = c, w = 0; for (int i = 0; i < 6; i++) { sexp[c][i] = x % 3; w += x % 3; x /= 3; } if (w <= 6) sl[w].push_back(c); }
    std::vector<i64> W(729);
    i64 i0 = 0;
    while (i0 < n) {
        u64 hi = ((u64)keys[i0]) >> 30; i64 i1 = i0;
        while (i1 < n && (((u64)keys[i1]) >> 30) == hi) i1++;
        int eA[6]; int dA = 0; for (int i = 0; i < 6; i++) { eA[i] = (int)((((u64)keys[i0]) >> (5 * (11 - i))) & 31); dA += eA[i]; }
        std::fill(W.begin(), W.end(), 0);
        for (i64 t = i0; t < i1; t++) {
            int eB[6], dB = 0, g[6];
            for (int i = 0; i < 6; i++) { eB[i] = (int)((((u64)keys[t]) >> (5 * (5 - i))) & 31); dB += eB[i]; }
            i64 c = vals[t];
            for (int w = ((3 - dB % 3) % 3); w <= 6; w += 3) {
                int D = dB + w; if (D > Dmax) return -2;
                for (int code : sl[w]) {
                    const int* s = sexp[code].data();
                    for (int i = 0; i < 6; i++) g[i] = eB[i] + s[i];
                    i64 val = PB[OFF[D] + rank6(g)];
                    if (val) W[code] = (W[code] + c * val) % p;
                }
            }
        }
        // 8 A-choices
        for (int ch = 0; ch < 8; ch++) {
            int sA[6]; i64 A = 1; int wA = 0;
            for (int k = 0; k < 3; k++) {
                int a = 2 * k, b = 2 * k + 1; int ra, rb; i64 cc;
                if ((ch >> k) & 1) { ra = 1; rb = 0; cc = cA1; } else { ra = 0; rb = 1; cc = cA0; }
                sA[a] = ((ra - eA[a]) % 3 + 3) % 3; sA[b] = ((rb - eA[b]) % 3 + 3) % 3;
                int ga = eA[a] + sA[a], gb = eA[b] + sA[b];
                A = A * cc % p * PT[ra * 40 + ga / 3] % p * PT[rb * 40 + gb / 3] % p;
                wA += sA[a] + sA[b];
            }
            if (A == 0) continue;
            int codeA = 0, pw = 1; for (int i = 0; i < 6; i++) { codeA += sA[i] * pw; pw *= 3; }
            for (int tot = 3; tot <= 6; tot += 3) {
                int wB = tot - wA; if (wB < 0) continue;
                for (int code : sl[wB]) if (W[code]) {
                    i64 idx = codeA + 729 * (i64)code;
                    Hout[idx] = (Hout[idx] + A * W[code]) % p;
                }
            }
        }
        i0 = i1;
    }
    return 0;
}
}
