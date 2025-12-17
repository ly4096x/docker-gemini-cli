FROM debian:latest

VOLUME /tmp /root/.cache /root/.npm

# Setup unprivileged user defaults
COPY usr/ /usr/
RUN chmod +x /usr/local/sbin/docker-entrypoint.sh

# Install nodejs, npm, Gemini CLI
ARG GEMINI_CLI_VERSION="latest"
ARG TARGETPLATFORM
RUN bash -c "apt-get update && \
    apt-get install -y --no-install-recommends curl unzip procps && \
    curl -o- https://fnm.vercel.app/install | bash && \
    source /root/.bashrc && \
    fnm install --lts && \
    npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION} && \
    rm -rf ~/.npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gemini --version"

WORKDIR /home/gemini/workspace
ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh", "gemini"]
