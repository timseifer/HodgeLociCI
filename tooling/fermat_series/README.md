# tooling/fermat_series: compiled kernel for the Fermat-cubic-tenfold period expansion (MOD p)

**Status: [TOOLING], AI-generated (SP-T6, 24 Nov 2026), not reviewed by a human.** It does not change any formula.
It is a faster implementation of one step of the numpy engines used in the discovery work. Every output must be
identical to the reference implementations kept next to it, and the test checks this.

## What it computes

For the cubic tenfold X_0 = Fermat (d = 3, n = 10), the period expansion along an arc t -> F + sum_j t^j T_j (with
T_j combinations of the 220 squarefree cubic monomials) needs, at each order m, the polynomial

    E'_m = (1/m) * sum_{j=1..m} j * T_j * E'_(m-j)        (E'_0 = 1)

and its period accumulator H(E'_m)(s) = Psi_P(x^s E'_m) for the base-3 codes s in {0,1,2}^12 with |s| <= 6.
Psi_P is the Fermat period functional of the linear-cycle class P1 + lambda P2, with the conventions of `Fermat.m2`
and `fe_ref.py`. All MH matrices and coefficient vectors c_n are read off from H (see `w3eng.py`). All arithmetic
is modulo a prime p < 2^26.

* `fe_ref.py`: reference engine (numpy; `mul`/`add` plus H with exact 11-bit limbs). It is a copy of the discovery
  engine `fe_big.py`.
* `w3eng.py`: reference engine with bucketed products and streamed H (numpy). It is a copy of agent W3's engine,
  and `W3Engine.Eprime(n, Tp, Es, store)` is the interface.
* `fsc.cpp`, `fsc.py`: the compiled kernel. `FastEngine` is `W3Engine` with `Eprime` replaced and the same
  inputs and outputs.
  - Products are split into target buckets by the exponents of x8..x11 (the top 20 bits of the packed key). Within
    a bucket the terms are combined in an open-addressing hash table, with reduction mod p deferred. Buckets are
    independent and run in parallel (OpenMP `nthreads`), and the results are concatenated in increasing key order.
    Output is therefore sorted and unique, and it does not depend on the thread count.
  - H: the valid (pattern, code) pairs depend only on e mod 3, so they are tabulated once for the 3^12 residue
    classes. Per term, only the needed half-products of the Pochhammer weights are formed.
  - Optional exact visibility filter for streamed levels (`visfilter=True`): a term x^e is skipped in H when no
    pattern r with nonzero table value t_r makes s = (r - e) mod 3 one of the codes q + a used by MH. This is exact:
    such a term contributes 0 to every MH entry. The filter must not be applied to stored levels, because those
    feed later products.
* `test_fermat_series.py`: compares the kernel with both references on random sparse arcs (3 primes, lambda = -1
  and 2, orders <= 6, 1 and 2 threads, with and without the filter). It checks the polynomials and the H
  accumulators bit for bit. Runtime is about 40 s on one core. Exit code 0 means PASS.

## Use

    python3 test_fermat_series.py                 # builds libfsc.so (g++ -O3 -fopenmp) next to the sources, or in $FSC_SO_DIR
    from fsc import FastEngine
    W = FastEngine(p, lam, z=z, nthreads=8)       # drop-in for w3eng.W3Engine
    E, acc, nterms = W.Eprime(m, Tp, Es, store=True)

Requirements: numpy, a C++ compiler with OpenMP (`CXX` overrides `g++`), and p < 2^26.

## Validation record (discovery ledger, entries [SP-T6])

The reruns of W3's runs are identical: every log line apart from timings, and the final arcs. They used
MOD 67108837, the EX-T6 lambda = -1 arcs a x l at orders 8, 11 and 12 and l x a at order 11, and generic
dense directions at orders 7 and 8. Single thread on a shared 2-core machine: order 11 took 83 s (numpy 502 s),
order 12 took 250 s (numpy 1513 s), and the generic order 8 took 335 s (numpy 669 s).
