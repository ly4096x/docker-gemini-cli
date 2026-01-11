FROM node:lts-slim

VOLUME /tmp /root/.cache /root/.npm

# Install Gemini CLI
ARG GEMINI_CLI_VERSION="latest"
ARG TARGETPLATFORM
RUN npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION} && \
    rm -rf ~/.npm && \
    gemini --version

# Setup unprivileged user defaults
COPY usr/ /usr/
RUN chmod +x /usr/local/sbin/docker-entrypoint.sh && \
    deluser node && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        docker.io \
        git \
        gosu \
        jq \
        less \
        nano \
        openssh-client \
        python3 \
        python3-pip \
        python3-venv \
        sudo \
        tree \
        unzip \
        vim \
        wget \
        zip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/gemini/workspace
ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh", "gemini"]
