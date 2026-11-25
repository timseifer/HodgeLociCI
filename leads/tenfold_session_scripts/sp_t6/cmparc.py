import numpy as np, sys
a = np.load(sys.argv[1]); b = np.load(sys.argv[2]); print("arc arrays", a.shape, b.shape, "IDENTICAL" if a.shape == b.shape and np.array_equal(a, b) else "DIFFERENT")
