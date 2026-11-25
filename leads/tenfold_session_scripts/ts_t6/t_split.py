import sys, time
from split import *
p = int(sys.argv[1]); z = int(sys.argv[2]); seed = int(sys.argv[3]); Dmax = int(sys.argv[4])
t0 = time.time()
T, tabs, Y, data = psi_tables(p, z, seed, Dmax)
print("done %.0fs" % (time.time() - t0))
