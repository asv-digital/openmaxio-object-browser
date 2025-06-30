# Usa imagem com Go 1.23+
FROM golang:1.23

# Instala Node.js 18 e Corepack (para Yarn 4)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && apt-get install -y \
    nodejs \
    git \
    make \
    python3 \
    build-essential \
    && corepack enable && \
    corepack prepare yarn@4.4.0 --activate

# Define diretório de trabalho
WORKDIR /app

# Copia o código fonte (Coolify fará isso automaticamente)
COPY . .

# Compila o frontend
WORKDIR /app/web-app
RUN yarn install && yarn build

# Compila o console backend (em Go)
WORKDIR /app
RUN make console

# Cria diretórios para persistência
RUN mkdir -p /app/data /app/config

# Expõe porta
EXPOSE 3000

# Define variáveis de ambiente
ENV CONSOLE_MINIO_SERVER=files.zappchat.io:443
ENV NODE_ENV=production

# Inicia o servidor
CMD ["./console", "server"]
