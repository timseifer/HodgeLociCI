"""run a python script as a subprocess and report wall time and peak RSS"""
import sys, subprocess, resource, time
t0 = time.time()
rc = subprocess.call([sys.executable] + sys.argv[1:])
ru = resource.getrusage(resource.RUSAGE_CHILDREN)
print(f"[wall {time.time()-t0:.0f} s, peak RSS {ru.ru_maxrss/1e6:.2f} GB, exit {rc}]")
