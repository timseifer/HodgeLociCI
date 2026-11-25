# locate tooling/fermat_series (the CI-tested Fermat engine; only its python numpy parts are imported here)
import os
HERE = os.path.dirname(os.path.abspath(__file__))
_c = [os.environ.get('HODGE_ENGINE_DIR', ''), os.path.join(HERE, '..', '..', 'tooling', 'fermat_series'),
      '/home/claude/hodge/package/HodgeLociCI/tooling/fermat_series']
ENGINE_DIR = next(os.path.abspath(c) for c in _c if c and os.path.exists(os.path.join(c, 'w3eng.py')))
