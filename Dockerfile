# HodgeLociCI: Macaulay2 1.22 + the package + the MCP server, in one image.
# AI-generated, not reviewed by a human mathematician.
#
#   docker build -t hodgelocici .
#   docker run --rm hodgelocici                         # quickstart, compared with examples/quickstart.expected
#   docker run --rm hodgelocici tests/run_all.sh        # validation suite (about 4.5 min on 2 cores)
#   docker run --rm -i hodgelocici python -m hodgelocici_mcp   # MCP server on stdio
#
# Macaulay2 comes from the Ubuntu 24.04 (noble) universe archive, pinned to the exact build the package was tested
# with (1.22+ds-6build2). See docker/README.md.
FROM ubuntu:24.04

ARG M2_VERSION=1.22+ds-6build2
# set to 1 to also run installPackage at build time (runs every documentation example, about 2 min; makes
# `needsPackage "HodgeLociCI"` work without FileName in interactive sessions of the user hlci)
ARG INSTALL_PACKAGE=0

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# python3, python3-venv and ca-certificates follow the security updates of noble (not pinned on purpose);
# Macaulay2, the only component the results depend on, is pinned exactly.
# hadolint ignore=DL3008
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      macaulay2="${M2_VERSION}" macaulay2-common="${M2_VERSION}" \
      python3 python3-venv ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 10001 hlci \
 && useradd --create-home --uid 10001 --gid 10001 --shell /bin/bash hlci

WORKDIR /opt/HodgeLociCI
COPY --chown=10001:10001 . /opt/HodgeLociCI

# the MCP server (official MCP Python SDK) in its own virtual environment; pytest for the server's tests
RUN python3 -m venv /opt/venv \
 && /opt/venv/bin/pip install "/opt/HodgeLociCI/mcp[test]" \
 && chmod +x /opt/HodgeLociCI/docker/quickstart-check.sh /opt/HodgeLociCI/tests/run_all.sh

ENV PATH=/opt/venv/bin:$PATH \
    HODGELOCICI_ROOT=/opt/HodgeLociCI \
    HODGELOCICI_M2=M2 \
    HODGELOCICI_OUTPUT_DIR=/tmp/hodgelocici-mcp

# user hlci
USER 10001:10001

RUN if [ "$INSTALL_PACKAGE" = "1" ]; then \
      M2 --silent --stop -e 'installPackage("HodgeLociCI", FileName => "M2/HodgeLociCI.m2"); exit 0' < /dev/null; \
    fi

LABEL org.opencontainers.image.title="HodgeLociCI" \
      org.opencontainers.image.description="Macaulay2 package for Hodge loci of combinations of complete-intersection cycles, with an MCP server. AI-generated, not reviewed by a human mathematician." \
      org.opencontainers.image.source="https://github.com/timseifer/HodgeLociCI" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.authors="Timothy Seifert"

CMD ["/opt/HodgeLociCI/docker/quickstart-check.sh"]
