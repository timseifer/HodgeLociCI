"""fermat_expansion against the documented example of fermatExtendArc (FermatDoc.m2; test F7)."""
import os

import pytest
from conftest import DISCLAIMER, needs_m2

from hodgelocici_mcp import core

SPACES = [[[0, 1, 1], [2, 3, 1], [4, 5, 1], [6, 7, 1]], [[0, 1, 3], [2, 3, 3], [4, 5, 3], [6, 7, 1]]]
T1 = "x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7"


@needs_m2
def test_cubic_sixfold_lambda2_obstructed_at_order5():
    r = core.fermat_expansion(3, 6, SPACES, [1, 2], 6, t1=T1)
    assert r["order_reached"] == 4 and r["obstructed_at_order"] == 5
    assert r["obstruction"].replace(" ", "") == "matrix{{6*z-3}}"
    assert r["certificate_verified"] is True and r["certificate_vanishing_order"] == 4
    assert os.path.isfile(r["certificate_file"])
    assert "EXACT" in r["status_label"] and "COMPUTED ONLY" in r["status_label"]
    assert r["disclaimer"] == DISCLAIMER


@needs_m2
def test_control_lambda1_mod_p_auto():
    # lambda = 1 (= lambda_0), MOD p with p = 1 mod 6, T_1 chosen automatically: extends to order 4, file re-verified
    r = core.fermat_expansion(3, 6, SPACES, [1, 1], 4, prime=32749, t1="auto")
    assert r["order_reached"] == 4 and r["obstructed_at_order"] is None
    assert r["certificate_verified"] is True
    assert r["status_label"].startswith("MOD p = 32749")


@needs_m2
def test_failed_check_is_reported():
    # T_1 = w is tangent to the locus where both spaces persist, so the certificate's excess-direction check fails
    r = core.fermat_expansion(3, 6, SPACES, [1, 1], 3, prime=32749, t1="x_0*x_1*x_7 + x_2*x_3*x_7 + x_4*x_5*x_7")
    assert r["order_reached"] == 3 and r["certificate_verified"] is False
    assert any(c.startswith("T_1 is not in the kernel of L_P1") and c.endswith("false") for c in r["certificate_checks"])


def test_validation():
    with pytest.raises(core.InputError):
        core.fermat_expansion(3, 6, SPACES, [1, 2], 6, prime=32003)        # 32003 != 1 mod 6
    with pytest.raises(core.InputError):
        core.fermat_expansion(3, 6, [[[0, 1, 2], [2, 3, 1], [4, 5, 1], [6, 7, 1]]], [1], 3, t1="x_0^3")  # e even
    with pytest.raises(core.InputError):
        core.fermat_expansion(3, 6, SPACES, [1, 2], 6, t1="x_0*y")          # unknown symbol
