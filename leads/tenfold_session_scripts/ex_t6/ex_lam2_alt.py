# EX-T6: robustness: rerun ex_lam2.py with another b: a = (1, 1, 1), l = (u1, u3, u5) (a x l type); outputs *_alt
import sys; sys.path.insert(0, '/home/claude/hodge/discovery/checks/ex_t6')
import dirs_exact
dirs_exact.A = [1, 1, 1]; dirs_exact.Lf = [{1: 1}, {3: 1}, {5: 1}]
src = open('/home/claude/hodge/discovery/checks/ex_t6/ex_lam2.py').read()
src = src.replace("SUF = '' if dirs_exact.KIND == 'al' else '_' + dirs_exact.KIND", "SUF = '_alt'")
src = src.replace("from dirs_exact import *", "from dirs_exact import *\nA = dirs_exact.A; Lf = dirs_exact.Lf")
exec(compile(src, 'ex_lam2_alt', 'exec'))
