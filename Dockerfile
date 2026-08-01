# Image used by MCP directories (Glama and friends) to start the server and
# answer an introspection request. The server lists its tools without any
# credentials; calling a tool needs `befall login` on a real machine.
FROM node:22-alpine

RUN addgroup -S befall && adduser -S befall -G befall
USER befall
WORKDIR /home/befall

ENV NODE_ENV=production
RUN npm install --no-fund --no-audit befall@latest

ENTRYPOINT ["npx", "--no-install", "befall", "mcp"]
