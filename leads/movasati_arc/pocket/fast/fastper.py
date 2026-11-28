# C-backed replacement for own.Ctx.periods (same values; uses blind check 20's phi.c). Main session, 28 Nov 2026.
import numpy as np, itertools, subprocess, os, tempfile
M = 10
def monlist(D):
    B = D + 1; out = []
    for k in range(B**M):
        t = k; s = []
        for j in range(M): s.append(t % B); t //= B
        if sum(s) == D: out.append(tuple(s))
    return out
_i2 = {m: i for i, m in enumerate(monlist(2))}
DIR = tempfile.mkdtemp(prefix="fastper_")
_tabs = {}
def install(S, binary):
    W = np.zeros(128, dtype=np.int64); W[:len(S.W)] = S.W; W.tofile(os.path.join(DIR, "W.bin"))
    qidx = np.array([_i2[tuple(q)] for q in S.Q])
    def periods(f, tab, forms=None):
        if forms is not None: return S.periods_py(f, tab, forms)
        n = len(f)
        if n == 0: return np.zeros(len(S.Q), dtype=np.int64)
        key = id(tab)
        if key not in _tabs:
            fn = os.path.join(DIR, "tab%d.bin" % len(_tabs)); t = np.zeros(1024, dtype=np.int64); t[:len(tab)] = tab; t.tofile(fn); _tabs[key] = fn
        rec = np.zeros(n, dtype=[('e', 'u1', (10,)), ('c', '<u4')])
        rec['e'] = np.fromiter(itertools.chain.from_iterable(f.monoms()), dtype=np.uint8, count=n*M).reshape(n, M)
        rec['c'] = np.fromiter((int(c) for c in f.coeffs()), dtype=np.uint32, count=n)
        fi = os.path.join(DIR, "f.bin"); fo = os.path.join(DIR, "o.bin"); rec.tofile(fi); del rec
        subprocess.run([binary, "2", os.path.join(DIR, "W.bin"), _tabs[key], fi, fo], check=True)
        r = np.fromfile(fo, dtype=np.int64); return r[qidx] % S.p
    S.periods_py = S.periods
    S.periods = periods
def monlist5():
    import itertools as it
    ms = [tuple(int(v) for v in np.bincount(c, minlength=M)) for c in it.combinations_with_replacement(range(M), 5)]
    ms.sort(key=lambda s: sum(s[j]*6**j for j in range(M))); return ms
def install_A(S, binary, tab):
    """A(Ek): 45 x 220 matrix, A[q, m] = Psi(q x^m Ek), via phi with D = 5."""
    import itertools as it
    ms = monlist5(); i5 = {m: i for i, m in enumerate(ms)}
    cub = [tuple(int(v) for v in np.bincount(c, minlength=M)) for c in it.combinations_with_replacement(range(M), 3)]
    fn = os.path.join(DIR, "tabA.bin"); t = np.zeros(1024, dtype=np.int64); t[:len(tab)] = tab; t.tofile(fn)
    idx = np.array([[i5[tuple(a+b for a, b in zip(q, m))] for m in cub] for q in S.Q])
    def A(f):
        n = len(f)
        rec = np.zeros(n, dtype=[('e', 'u1', (10,)), ('c', '<u4')])
        rec['e'] = np.fromiter(it.chain.from_iterable(f.monoms()), dtype=np.uint8, count=n*M).reshape(n, M)
        rec['c'] = np.fromiter((int(c) for c in f.coeffs()), dtype=np.uint32, count=n)
        fi = os.path.join(DIR, "fA.bin"); fo = os.path.join(DIR, "oA.bin"); rec.tofile(fi); del rec
        subprocess.run([binary, "5", os.path.join(DIR, "W.bin"), fn, fi, fo], check=True)
        r = np.fromfile(fo, dtype=np.int64); return r[idx] % S.p
    def tvec(T): return np.array([int(T[m]) for m in cub], dtype=np.int64)
    return A, tvec
