#!/usr/bin/env python3
"""Independent check: which linear P^4 of the Fermat cubic eightfold persist to
first order along F0 + eps*T, i.e. T in (I_L + J)_3, J = (x_0^2..x_9^2).

Method A (all 229635 L): substitution. Mod I_L the ring is k[y_1..y_5] (one var
per pair, x_a = c x_b, x_b = y). J maps to (y_1^2..y_5^2) since (c y)^2 = c^2 y^2,
c a unit. So T in I_L+J  <=>  T|_L has zero coefficient on all 10 squarefree
monomials y_i y_j y_k. That coefficient equals the symmetric trilinear form of T
evaluated on v_i = c_i e_a + e_b etc. (only squarefree monomials of T with one
variable from each of three distinct pairs contribute).

Method B (subset): direct linear algebra over GF(p) in the 220-dim space of
cubics: rank of generators {l_i * quad monomials, x_i^2 x_j} vs rank with T added.
"""
import sys, itertools, random, re
import numpy as np

N = 10
MONS3 = [m for m in itertools.combinations_with_replacement(range(N), 3)]
IDX3 = {m: i for i, m in enumerate(MONS3)}
MONS2 = list(itertools.combinations_with_replacement(range(N), 2))

def parse(line, p):
    T = {}
    line = line.strip().replace(' ', '').replace('-', '+-')
    for term in line.split('+'):
        if not term:
            continue
        sign = 1
        if term.startswith('-'):
            sign, term = -1, term[1:]
        coef = 1; vars_ = []
        for f in term.split('*'):
            m = re.fullmatch(r'x_(\d+)(?:\^(\d+))?', f)
            if m:
                vars_ += [int(m.group(1))] * int(m.group(2) or 1)
            else:
                coef *= int(f)
        assert len(vars_) == 3, term
        key = tuple(sorted(vars_))
        T[key] = (T.get(key, 0) + sign * coef) % p
    return {k: v for k, v in T.items() if v}

def cube_roots_minus1(p):
    return sorted(c for c in range(1, p) if pow(c, 3, p) == p - 1)

def matchings(s):
    if not s:
        yield []
        return
    a = s[0]
    for i in range(1, len(s)):
        b = s[i]
        rest = s[1:i] + s[i+1:]
        for m in matchings(rest):
            yield [(a, b)] + m

def all_L(p):
    roots = cube_roots_minus1(p)
    for M in matchings(list(range(N))):
        for cs in itertools.product(roots, repeat=5):
            yield tuple((a, b, c) for (a, b), c in zip(M, cs))

# ---------- Method A ----------
def sym_tensor(T, p):
    """dense 10x10x10 array t with t[u,v,w] = coeff of x_u x_v x_w for DISTINCT u,v,w"""
    t = np.zeros((N, N, N), dtype=np.int64)
    for (u, v, w), c in T.items():
        if u != v and v != w and u != w:
            for perm in set(itertools.permutations((u, v, w))):
                t[perm] = c
    return t

def persists_A(t, L, p):
    for (i, j, k) in itertools.combinations(range(5), 3):
        s = 0
        for ci in ((L[i][0], L[i][2]), (L[i][1], 1)):
            for cj in ((L[j][0], L[j][2]), (L[j][1], 1)):
                for ck in ((L[k][0], L[k][2]), (L[k][1], 1)):
                    s += int(t[ci[0], cj[0], ck[0]]) * ci[1] * cj[1] * ck[1]
        if s % p:
            return False
    return True

def count_A(T, p, Ls):
    t = sym_tensor(T, p)
    hits = [L for L in Ls if persists_A(t, L, p)]
    return hits

# ---------- Method B ----------
def rank_mod_p(M, p):
    M = M.copy() % p
    r = 0; rows, cols = M.shape
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if M[i, c]:
                piv = i; break
        if piv is None:
            continue
        M[[r, piv]] = M[[piv, r]]
        M[r] = (M[r] * pow(int(M[r, c]), p - 2, p)) % p
        nz = np.nonzero(M[:, c])[0]
        for i in nz:
            if i != r:
                M[i] = (M[i] - M[i, c] * M[r]) % p
        r += 1
        if r == rows:
            break
    return r

def polymul_lin_mon(lin, mon):
    """lin: dict var->coef, mon: tuple deg2 -> dict deg3 monomial -> coef"""
    out = {}
    for v, c in lin.items():
        key = tuple(sorted(mon + (v,)))
        out[key] = out.get(key, 0) + c
    return out

def vec(poly, p):
    x = np.zeros(len(MONS3), dtype=np.int64)
    for k, c in poly.items():
        x[IDX3[k]] = (x[IDX3[k]] + c) % p
    return x

def gens_B(L, p):
    rows = []
    for (a, b, c) in L:
        lin = {a: 1, b: (-c) % p}
        for m in MONS2:
            rows.append(vec(polymul_lin_mon(lin, m), p))
    for i in range(N):
        for j in range(N):
            rows.append(vec({tuple(sorted((i, i, j))): 1}, p))
    return np.array(rows)

def persists_B(T, L, p):
    G = gens_B(L, p)
    r0 = rank_mod_p(G, p)
    r1 = rank_mod_p(np.vstack([G, vec(T, p)]), p)
    return r0 == r1, r0

def main():
    files = {31981: ('/home/claude/hodgelocici/leads/movasati_arc/arcs/jet8_31981_s_lam2.txt', 12637),
             32029: ('/home/claude/hodgelocici/leads/movasati_arc/arcs/jet8_32029_s_lam2.txt', (-473) % 32029)}
    random.seed(18)
    for p, (fn, w) in files.items():
        print(f'===== p = {p} =====')
        print('p mod 3 =', p % 3, '; w =', w, 'w^6 =', pow(w, 6, p), 'w^3 =', pow(w, 3, p), '(-1 =', p - 1, ')',
              'w^2 =', pow(w, 2, p))
        roots = cube_roots_minus1(p)
        print('cube roots of -1:', roots, '; w in roots:', w in roots)
        T = parse(open(fn).readline(), p)
        print('T: number of monomials =', len(T), '; total degree check ok')
        Ls = list(all_L(p))
        print('number of L =', len(Ls), 'distinct =', len(set(frozenset((min(a,b),max(a,b),c if a<b else pow(c,p-2,p)) for a,b,c in L) for L in Ls)))
        hits = count_A(T, p, Ls)
        print('Method A: #L with T in I_L+J =', len(hits))
        w3 = pow(w, 3, p)
        P1 = tuple((2*i, 2*i+1, w) for i in range(5))
        P2 = tuple((2*i, 2*i+1, w3 if i < 3 else w) for i in range(5))
        t = sym_tensor(T, p)
        for name, P in (('P1', P1), ('P2', P2)):
            okB, r0 = persists_B(T, P, p)
            print(f'{name}: method A persists={persists_A(t, P, p)}, method B persists={okB} (rank of (I_L+J)_3 = {r0}, codim {220-r0})')
        # Method B on random sample, cross-check with A
        sample = random.sample(Ls, 150)
        agreeB = sum(persists_B(T, L, p)[0] for L in sample)
        print('Method B on 150 random L: #persisting =', agreeB)
        # Control (ii): product
        l1 = {0: 1, 1: (-w) % p}    # vanishes on P1 (x0 = w x1)
        l2 = {0: 1, 1: (-w3) % p}   # vanishes on P2 (x0 = w^3 x1)
        l3 = {5: 1, 8: 3}           # arbitrary linear form
        prod = {}
        for u, a in l1.items():
            for v, b in l2.items():
                for z, c in l3.items():
                    k = tuple(sorted((u, v, z)))
                    prod[k] = (prod.get(k, 0) + a*b*c) % p
        prod = {k: v for k, v in prod.items() if v}
        tc = sym_tensor(prod, p)
        for name, P in (('P1', P1), ('P2', P2)):
            print(f'control product l1*l2*l3 on {name}: A={persists_A(tc, P, p)}, B={persists_B(prod, P, p)[0]}')
        hc = count_A(prod, p, Ls)
        print('control product: #L persisting (A) =', len(hc))
        sub = random.sample(hc, 20) + random.sample(Ls, 20)
        mism = sum(persists_B(prod, L, p)[0] != persists_A(tc, L, p) for L in sub)
        print('control product: A vs B mismatches on 40 L (20 hits + 20 random):', mism)
        # Sanity: random T in I_{L0}
        L0 = random.choice(Ls)
        R = {}
        for (a, b, c) in L0:
            for m in MONS2:
                r = random.randrange(p)
                for k, v in polymul_lin_mon({a: 1, b: (-c) % p}, m).items():
                    R[k] = (R.get(k, 0) + r * v) % p
        R = {k: v for k, v in R.items() if v}
        tr = sym_tensor(R, p)
        hr = count_A(R, p, Ls)
        print('sanity: L0 =', L0)
        print('sanity: random T in I_L0, #L persisting (A) =', len(hr), '; L0 among them:', L0 in hr)
        sub = random.sample(hr, min(20, len(hr))) + random.sample(Ls, 20)
        mism = sum(persists_B(R, L, p)[0] != persists_A(tr, L, p) for L in sub)
        print('sanity: A vs B mismatches on', len(sub), 'L:', mism)
        # A vs B on random generic cubics T (should almost never persist) plus one T in (I_L+J)
        print()

if __name__ == '__main__':
    main()
