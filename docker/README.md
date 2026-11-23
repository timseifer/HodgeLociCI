# Docker image

One image with Macaulay2 1.22, the HodgeLociCI package and its MCP server. AI-generated, not reviewed by a human
mathematician.

## What is in it

- Base: `ubuntu:24.04`.
- Macaulay2 from the Ubuntu 24.04 (noble) universe archive, pinned to `1.22+ds-6build2`: the exact build the
  package was developed and tested with (build argument `M2_VERSION`).
- The repository at `/opt/HodgeLociCI` (owned by the unprivileged user `hlci`, uid 10001, who runs everything).
  The package is loaded from there with `needsPackage("HodgeLociCI", FileName => "/opt/HodgeLociCI/M2/HodgeLociCI.m2")`;
  `M2 --script` ignores packages installed in the home directory anyway. With `--build-arg INSTALL_PACKAGE=1`,
  `installPackage` also runs at build time (about 2 more minutes; it runs every documentation example), after which
  `needsPackage "HodgeLociCI"` works in interactive sessions.
- The MCP server (`mcp/`, official MCP Python SDK) in a virtual environment at `/opt/venv`, with pytest for its tests.
- Environment: `HODGELOCICI_ROOT=/opt/HodgeLociCI`, `HODGELOCICI_M2=M2`, `HODGELOCICI_OUTPUT_DIR=/tmp/hodgelocici-mcp`.
- Default command: `docker/quickstart-check.sh`, which runs `examples/quickstart.m2` and compares its `RESULT` lines
  with `examples/quickstart.expected` (exit status 0 if and only if they are identical).

## Build and run

From the repository root:

    docker build -t hodgelocici .
    docker run --rm hodgelocici                                   # quickstart check (a few seconds)
    docker run --rm -it hodgelocici M2                            # interactive Macaulay2; then
                                                                  #   needsPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2")
    docker run --rm -i hodgelocici python -m hodgelocici_mcp      # MCP server on stdin/stdout (see mcp/README.md)

## Tests inside the container

    docker run --rm hodgelocici tests/run_all.sh                  # validation suite, 15 tests, about 4.5 min on 2 cores
    docker run --rm hodgelocici tests/run_all.sh --slow           # plus the two slow tests, about 3 min more
    docker run --rm hodgelocici python -m pytest mcp/tests -q -p no:cacheprovider     # MCP server tests (about 20 s)
    docker run --rm hodgelocici python3 discoveries/check_registry.py                 # registry check
    docker run --rm hodgelocici \
      M2 --silent --stop -e 'installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2"); check "HodgeLociCI"; exit 0'
                                                                  # package tests (40), about 2.5 min

To keep certificate files written by the MCP tool `fermat_expansion`, mount a directory and point the output there:
`docker run --rm -i -v "$PWD/out:/out" -e HODGELOCICI_OUTPUT_DIR=/out hodgelocici python -m hodgelocici_mcp`
(the directory must be writable by uid 10001).

## Image size

About 405 MB (uncompressed, as reported by `docker image ls` in the first CI run on GitHub Actions,
23 November 2026, run 45123951486). That run also passed the quickstart (19 of 19 lines), the MCP tests (22 passed),
the validation suite (15 of 15) and the registry check inside the image.
