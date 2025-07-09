# syntax=docker.io/docker/dockerfile:1.17
# shellcheck shell=bash

# see https://gitea.com/gitea/tea/releases
# renovate: datasource=gitea-releases depName=gitea/tea
ARG TEA_VERSION='0.10.1'

# see https://github.com/Azure/azure-cli/releases
# renovate: datasource=github-releases depName=Azure/azure-cli extractVersion=azure-cli-(?<version>.+)
ARG AZURE_CLI_VERSION='2.75.0'

# see https://www.terraform.io/downloads.html
# see https://github.com/hashicorp/terraform/releases
# renovate: datasource=github-releases depName=hashicorp/terraform
ARG TERRAFORM_VERSION='1.12.2'

FROM debian:bookworm-slim

RUN <<'EOF'
#!/usr/bin/bash
set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install --no-install-recommends \
  bash-completion \
  curl \
  git \
  jq \
  openssh-client \
  pylint \
  python3-argcomplete \
  python3-cryptography \
  python3-openssl \
  python3-pip \
  python3-venv \
  python3-yaml \
  sshpass \
  sudo \
  unzip \
  wget \
  xz-utils
apt-get clean
rm -rf /var/lib/apt/lists/*
activate-global-python-argcomplete
python3 -m venv --system-site-packages /opt/venv
EOF
ENV PATH="/opt/venv/bin:$PATH"

RUN <<'EOF'
#!/usr/bin/bash
set -euxo pipefail
groupadd -g 1000 vagrant
useradd -u 1000 -g vagrant -m vagrant
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
EOF

ARG TEA_VERSION
ENV CHECKPOINT_DISABLE=1
RUN <<'EOF'
#!/usr/bin/bash
set -euxo pipefail
url="https://gitea.com/gitea/tea/releases/download/v${TEA_VERSION}/tea-${TEA_VERSION}-linux-amd64.xz"
t="$(mktemp -q -d --suffix=.tea)"
wget -qO- "$url" | xz -d >"$t/tea"
install "$t/tea" /usr/local/bin
rm -rf "$t"
EOF

ARG AZURE_CLI_VERSION
RUN <<'EOF'
#!/usr/bin/bash
set -euxo pipefail
# NB execute apt-cache madison azure-cli to known the available versions.
# see https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt&view=azure-cli-latest
wget -qO /etc/apt/keyrings/packages.microsoft.com.asc https://packages.microsoft.com/keys/microsoft.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.com.asc] https://packages.microsoft.com/repos/azure-cli/ $(. /etc/os-release && echo $VERSION_CODENAME) main" \
  >/etc/apt/sources.list.d/azure-cli.list
apt-get update
apt-get install -y "azure-cli=$AZURE_CLI_VERSION-*"
apt-get clean
rm -rf /var/lib/apt/lists/*
az --version
EOF

ARG TERRAFORM_VERSION
ENV CHECKPOINT_DISABLE=1
RUN <<'EOF'
#!/usr/bin/bash
set -euxo pipefail
url="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
t="$(mktemp -q -d --suffix=.terraform)"
wget -qO "$t/terraform.zip" "$url"
unzip "$t/terraform.zip" -d "$t"
install "$t/terraform" /usr/local/bin
rm -rf "$t"
terraform -install-autocomplete
EOF

COPY terraform /usr/local/bin/

CMD ["bash", "-c", "sleep inf"]
