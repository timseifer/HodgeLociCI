"""The hard limits of the Macaulay2 subprocess: timeout and memory cap (with a stand-in for M2)."""
import os
import stat
import sys

import pytest

from hodgelocici_mcp import core


def _fake_m2(tmp_path, body):
    exe = tmp_path / "fakeM2"
    exe.write_text(f"#!{sys.executable}\n{body}\n")
    exe.chmod(exe.stat().st_mode | stat.S_IEXEC)
    return str(exe)


def test_timeout_kills_process(tmp_path, monkeypatch):
    monkeypatch.setenv("HODGELOCICI_M2", _fake_m2(tmp_path, "import time\ntime.sleep(60)"))
    with pytest.raises(core.ComputationError, match="timeout"):
        core.excess_formula(3, [1, 1, 1], [1, 1, 1], [1], timeout_seconds=2)


def test_memory_cap(tmp_path, monkeypatch):
    monkeypatch.setenv("HODGELOCICI_M2", _fake_m2(tmp_path, "x = bytearray(2 * 1024**3)\nprint('HLCI|done|1')"))
    monkeypatch.setenv("HODGELOCICI_MEM_MB", "512")
    with pytest.raises(core.ComputationError):
        core.excess_formula(3, [1, 1, 1], [1, 1, 1], [1])


def test_bad_timeout_value():
    with pytest.raises(core.InputError):
        core.excess_formula(3, [1, 1, 1], [1, 1, 1], [1], timeout_seconds=10**6)
