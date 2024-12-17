# Stage 1 - Copiar arquivos necessários para instalar dependências
FROM node:20-bookworm-slim AS packages

WORKDIR /app
COPY package.json yarn.lock ./
COPY .yarn ./.yarn
COPY .yarnrc.yml ./
COPY packages packages
# COPY plugins plugins # Descomente se tiver plugins internos

# Antes removíamos arquivos aqui, agora não faremos isso.

# Stage 2 - Instalar dependências e buildar os pacotes
FROM node:20-bookworm-slim AS build

# Setar Python para node-gyp
ENV PYTHON=/usr/bin/python3

# Instalar dependências nativas necessárias (isolated-vm, sqlite3, etc.)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

USER node
WORKDIR /app

# Copiar arquivos do estágio anterior
COPY --from=packages --chown=node:node /app ./
COPY --from=packages --chown=node:node /app/.yarn ./.yarn
COPY --from=packages --chown=node:node /app/.yarnrc.yml  ./

# Instalar dependências com cache
RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    yarn install --immutable

# Copiar todo o resto do código
COPY --chown=node:node . .

# Compilar TypeScript
RUN yarn tsc

# Compilar o backend
RUN yarn --cwd packages/backend build

# Extrair os bundles
RUN mkdir packages/backend/dist/skeleton packages/backend/dist/bundle \
    && tar xzf packages/backend/dist/skeleton.tar.gz -C packages/backend/dist/skeleton \
    && tar xzf packages/backend/dist/bundle.tar.gz -C packages/backend/dist/bundle

# Stage 3 - Construir a imagem final
FROM node:20-bookworm-slim

ENV PYTHON=/usr/bin/python3

# Instala dep nativas necessárias (isolated-vm, sqlite3, etc.)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends python3 g++ build-essential libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

USER node
WORKDIR /app

COPY --from=build --chown=node:node /app/.yarn ./.yarn
COPY --from=build --chown=node:node /app/.yarnrc.yml  ./
COPY --from=build --chown=node:node /app/yarn.lock /app/package.json /app/packages/backend/dist/skeleton/ ./

# Instalar somente as dependências de produção
RUN --mount=type=cache,target=/home/node/.cache/yarn,sharing=locked,uid=1000,gid=1000 \
    yarn workspaces focus --all --production && rm -rf "$(yarn cache clean)"

# Copiar o bundle do backend
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle/ ./

# Copiar configs e outros arquivos necessários
COPY --chown=node:node app-config*.yaml ./

# Opcional: copiar exemplos ou outros diretórios se precisar
# COPY --chown=node:node examples ./examples

ENV NODE_ENV=production
ENV NODE_OPTIONS="--no-node-snapshot"

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
