"""second_order_check against the package's own tests (quickstart; SecondOrderTests.m2, test PA-S10)."""
import pytest
from conftest import DISCLAIMER, needs_m2

from hodgelocici_mcp import core

# Instance R1 of test PA-S10 (M2/HodgeLociCI/SecondOrderTests.m2): Fermat surface of degree 7 modulo 31991, written
# out as explicit polynomials (printed by Macaulay2 1.22 from the construction in that test).
PAS10 = dict(
    nvars=4, field=31991,
    f=["x_0-7598*x_1"],
    h=["x_0^3-284*x_0^2*x_1-7883*x_0*x_1^2-7598*x_1^3"],
    p=["x_2-7598*x_3"],
    M=[["x_0^3+7882*x_0^2*x_1-7150*x_0*x_1^2+2168*x_1^3"]],
    s=["x_2^6+7598*x_2^5*x_3-14151*x_2^4*x_3^2+2453*x_2^3*x_3^3-12859*x_2^2*x_3^4-2168*x_2*x_3^5+2901*x_3^6"],
)


@needs_m2
def test_pas10_not_determined_and_survive():
    r2 = core.second_order_check(2, mode="explicit", **PAS10)
    assert r2["verdict"] == "NOT DETERMINED"
    assert r2["in_range"] is False and r2["condition_S"] is False
    assert r2["degree"] == 7
    assert r2["status_label"].startswith("MOD p") and r2["disclaimer"] == DISCLAIMER
    r1 = core.second_order_check(1, mode="explicit", **PAS10)
    assert r1["verdict"] == "ALL SURVIVE"


@needs_m2
def test_random_cubic_sixfold_quickstart():
    kw = dict(mode="random", degree=3, own_degrees_y1=[1, 1, 1], own_degrees_y2=[1, 1, 1], shared_degrees=[1],
              seed=7, field=32003)
    assert core.second_order_check(2, **kw)["verdict"] == "ALL DIE"
    assert core.second_order_check(1, **kw)["verdict"] == "ALL SURVIVE"


def test_validation():
    with pytest.raises(core.InputError):
        core.second_order_check(2, field=32771, mode="random", degree=3, own_degrees_y1=[1], own_degrees_y2=[1],
                                shared_degrees=[1])                       # prime above the F4 limit
    with pytest.raises(core.InputError):
        core.second_order_check(2, field=32000, mode="random", degree=3, own_degrees_y1=[1], own_degrees_y2=[1],
                                shared_degrees=[1])                       # not a prime
    with pytest.raises(core.InputError):
        core.second_order_check(0, mode="random", degree=3, own_degrees_y1=[1], own_degrees_y2=[1],
                                shared_degrees=[1])                       # lambda = 0
    bad = dict(PAS10, f=['run "ls"'])
    with pytest.raises(core.InputError):
        core.second_order_check(2, mode="explicit", **bad)                # not a polynomial
    bad = dict(PAS10, f=["x_0-7598*x_9"])
    with pytest.raises(core.InputError):
        core.second_order_check(2, mode="explicit", **bad)                # variable out of range
    bad = dict(PAS10, f=["2x_0"])
    with pytest.raises(core.InputError):
        core.second_order_check(2, mode="explicit", **bad)                # implicit product


@needs_m2
def test_m2_error_is_reported():
    # a singular hypersurface: the package refuses it, and the message comes back as a ComputationError
    with pytest.raises(core.ComputationError, match="singular|regular sequence"):
        core.second_order_check(2, mode="explicit", nvars=4, field=32003, f=["x_0"], h=["x_1"], p=["x_2"],
                                M=[["x_0"]], s=["x_2^2"])
