# mx5b: how much of F_eps lies in the tangent space of the determinantal cubics at G_A (third route diagnostic). NUMERICAL.
# usage (repository root): python3 leads/tenfold_twodet/matrices/mx5b_tangent_diagnostic.py RESULT.json DPS
import sys, runpy, os
os.environ['MX5_IT'] = '0'
sys.argv = ['x', sys.argv[1], sys.argv[2]]
g = runpy.run_path('leads/tenfold_twodet/matrices/mx5_second_matrix.py')
mp = g['mp']; A = g['A']; F = g['F']; cof = g['cof']; cidx = g['cidx']; nrm = g['nrm']; sci = g['sci']; lstsq = g['lstsq']; GA = g['GA']
cols = []
for a in range(3):
    for b in range(3):
        cf = cof(A, a, b)
        for k in range(8):
            col = [mp.mpc(0)] * 120
            for qm, co in cf.items(): col[cidx[tuple(sorted(qm + (k,)))]] += co
            cols.append(col)
for rd in (60, 100, 140):
    x = lstsq(cols, F, mp.mpf(10) ** (-rd))
    fit = [sum(cols[j][k] * x[j] for j in range(72)) for k in range(120)]
    print(f"ridge 1e-{rd}: |F - proj| / |F| = {sci(nrm([F[k] - fit[k] for k in range(120)]) / nrm(F))} ; |x| = {sci(mp.sqrt(sum(abs(x[j])**2 for j in range(72))))}", flush=True)
# singular values of the 120 x 72 tangent map (relative)
M = mp.matrix(120, 72)
for j in range(72):
    for k in range(120): M[k, j] = cols[j][k]
sv = mp.svd_c(M, compute_uv=False)
print("singular values of the tangent map, relative to the largest: " + " ".join(sci(sv[i] / sv[0]) for i in range(0, 72, 4)), flush=True)
