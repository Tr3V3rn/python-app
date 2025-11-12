FROM node:20-bookworm-slim
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN npm install -g corepack
RUN corepack enable
RUN yarn set version 4.4.1
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]