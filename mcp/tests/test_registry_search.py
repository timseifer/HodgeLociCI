"""registry_search (pure Python, no Macaulay2)."""
import pytest
from conftest import DISCLAIMER

from hodgelocici_mcp import core


def test_search_first_order_rule():
    r = core.registry_search("first-order rule")
    ids = [e["id"] for e in r["entries"]]
    assert "D-FIRST-ORDER-RULE" in ids
    e = next(e for e in r["entries"] if e["id"] == "D-FIRST-ORDER-RULE")
    assert e["status"] == "PROVED_AI_UNREVIEWED" and e["status_label"] == "PROVED (AI-written, unreviewed)"
    assert r["disclaimer"] == DISCLAIMER and r["total_entries"] > 100


def test_filters():
    r = core.registry_search("", kind="dead_end", limit=200)
    assert r["matches"] > 0 and all(e["kind"] == "dead_end" for e in r["entries"])
    r = core.registry_search("Fermat", status="MOD p", limit=200)
    assert all(e["status"] == "MOD_P" for e in r["entries"])
    with pytest.raises(core.InputError):
        core.registry_search("x", kind="theorem")
