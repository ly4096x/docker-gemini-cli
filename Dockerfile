FROM node:lts-slim

VOLUME /tmp /var/cache/apk /var/tmp /root/.cache /root/.npm

# Install Gemini CLI
ARG GEMINI_CLI_VERSION="latest"
ARG TARGETPLATFORM
RUN npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION} && \
    rm -rf ~/.npm && \
    gemini --version

WORKDIR /workspace
ENTRYPOINT ["gemini"]
