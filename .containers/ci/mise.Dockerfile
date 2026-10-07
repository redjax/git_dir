# syntax=docker/dockerfile:1

FROM debian:13.7-slim AS mise-base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    MISE_DATA_DIR=/opt/mise \
    MISE_CACHE_DIR=/var/cache/mise \
    MISE_INSTALL_PATH=/usr/local/bin/mise

ENV PATH="/opt/mise/shims:${PATH}"

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        unzip \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --silent --show-error --location \
        https://mise.run \
        --output /tmp/install-mise.sh \
    && sh /tmp/install-mise.sh \
    && rm /tmp/install-mise.sh \
    && mise --version

WORKDIR /workspace

CMD ["/bin/bash"]


FROM mise-base AS mise-check

COPY .mise.toml /workspace/.mise.toml

RUN mise trust /workspace/.mise.toml \
    && mise install \
    && mise reshim

CMD ["/bin/true"]
