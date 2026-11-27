import sys; sys.argv=["c1.py","32029","1/1","auth"]
src=open("/home/claude/blind_check16/c1.py").read().split("t0 = time.time()")[0]
exec(src)
tab=S.ptable(P); E=S.expseries([T1],7)
print("lambda=1, T_2=..=0: nonzero c_n among 45, n=1..7:",[int(np.count_nonzero(S.periods(E[n],tab))) for n in range(1,8)])
