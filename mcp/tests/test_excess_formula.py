"""excess_formula against the package's own values (examples/quickstart.expected, tests/expected)."""
import pytest
from conftest import DISCLAIMER, needs_m2

from hodgelocici_mcp import core


@needs_m2
def test_cubic_sixfold_two_planes():
    # two 3-planes meeting in a point on a cubic sixfold: tangent codimensions 8 (V_Z) and 7 (at lambda_0 = 1)
    r = core.excess_formula(3, [1, 1, 1], [1, 1, 1], [1])
    assert (r["tau"], r["lambda0"], r["e_tau"], r["codim_VZ"], r["codim_NL_at_lambda0"]) == (0, 1, 1, 8, 7)
    assert r["excess_at_lambda0"] == 1 and r["excess_generic_lambda"] == 1 and r["in_range"] is True
    assert r["status_label"].startswith("EXACT") and "PROVED" in r["package_label"]
    assert r["disclaimer"] == DISCLAIMER


@needs_m2
def test_eightfold_point_tau_negative():
    r = core.excess_formula(3, [1, 1, 1, 1], [1, 1, 1, 1], [1])
    assert (r["tau"], r["codim_VZ"], r["excess_at_lambda0"], r["excess_generic_lambda"]) == (-1, 20, 0, 0)
    assert r["dichotomy"].startswith("tau < 0")


@needs_m2
def test_outside_range_not_determined():
    # quartic fourfold, two planes meeting in a line: tau = 2, e_tau = 3, outside the range
    r = core.excess_formula(4, [1], [1], [1, 1])
    assert (r["tau"], r["e_tau"], r["in_range"]) == (2, 3, False)
    assert r["excess_generic_lambda"] == "NotDetermined"


def test_validation():
    with pytest.raises(core.InputError):
        core.excess_formula(3, [1, 3], [1, 1], [1])          # degree >= d
    with pytest.raises(core.InputError):
        core.excess_formula(3, [1, 1], [1], [1])             # different c
    with pytest.raises(core.InputError):
        core.excess_formula("3", [1], [1], [1])              # not an integer
