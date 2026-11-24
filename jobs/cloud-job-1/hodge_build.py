# Build the compiled kernel (libfsc.so) once into ./build (FSC_SO_DIR); used by validate.sh and run_tasks.py.
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.environ.get('HODGE_ENGINE_DIR', os.path.join(HERE, '..', '..', 'tooling', 'fermat_series')))
os.environ.setdefault('FSC_SO_DIR', os.path.join(HERE, 'build')); os.makedirs(os.environ['FSC_SO_DIR'], exist_ok=True)
import fsc
fsc.build()
