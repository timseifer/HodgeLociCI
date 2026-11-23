"""The four tools through the MCP protocol (in-process client of the official SDK)."""
import anyio
from conftest import DISCLAIMER, needs_m2

from mcp.client import Client

from hodgelocici_mcp.server import server


def _run(coro_fn):
    return anyio.run(coro_fn)


def test_list_tools():
    async def go():
        async with Client(server) as c:
            return sorted(t.name for t in (await c.list_tools()).tools)
    assert _run(go) == ["excess_formula", "fermat_expansion", "registry_search", "second_order_check"]


def test_registry_search_via_mcp():
    async def go():
        async with Client(server) as c:
            return await c.call_tool("registry_search", {"query": "level dichotomy", "limit": 3})
    res = _run(go)
    assert not res.is_error
    assert res.structured_content["disclaimer"] == DISCLAIMER
    assert any(e["id"] == "D-LEVEL-DICHOTOMY" for e in res.structured_content["entries"])


def test_validation_error_via_mcp():
    async def go():
        async with Client(server) as c:
            return await c.call_tool("excess_formula", {"degree": 3, "own_degrees_y1": [1, 5], "own_degrees_y2": [1, 1],
                                                        "shared_degrees": [1]})
    res = _run(go)
    assert res.is_error and "InputError" in res.content[0].text and DISCLAIMER in res.content[0].text


@needs_m2
def test_excess_via_mcp():
    async def go():
        async with Client(server) as c:
            return await c.call_tool("excess_formula", {"degree": 3, "own_degrees_y1": [1, 1, 1],
                                                        "own_degrees_y2": [1, 1, 1], "shared_degrees": [1]})
    res = _run(go)
    assert not res.is_error and res.structured_content["codim_VZ"] == 8


def test_stdio_server_end_to_end():
    # the real transport: `python -m hodgelocici_mcp` as a subprocess speaking MCP over stdin/stdout
    import os
    import sys

    from mcp import StdioServerParameters

    params = StdioServerParameters(command=sys.executable, args=["-m", "hodgelocici_mcp"],
                                   env={**os.environ, "HODGELOCICI_ROOT": os.environ["HODGELOCICI_ROOT"]})

    async def go():
        async with Client(params) as c:
            names = sorted(t.name for t in (await c.list_tools()).tools)
            res = await c.call_tool("registry_search", {"query": "D-FIRST-ORDER-RULE", "limit": 1})
            return names, res
    names, res = _run(go)
    assert len(names) == 4 and not res.is_error
    assert res.structured_content["entries"][0]["id"] == "D-FIRST-ORDER-RULE"
