import os
import shutil
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
os.environ.setdefault("HODGELOCICI_ROOT", str(ROOT))

DISCLAIMER = "AI-generated, not reviewed by a human mathematician."

needs_m2 = pytest.mark.skipif(shutil.which(os.environ.get("HODGELOCICI_M2", "M2")) is None,
                              reason="Macaulay2 (M2) not on PATH")


@pytest.fixture(autouse=True)
def _output_dir(tmp_path, monkeypatch):
    monkeypatch.setenv("HODGELOCICI_OUTPUT_DIR", str(tmp_path / "out"))
