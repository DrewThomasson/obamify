# Stage 1: Build the WASM app with Trunk
FROM rust:1.85 AS builder

RUN rustup target add wasm32-unknown-unknown
RUN cargo install --locked trunk

WORKDIR /app

# Copy dependency manifests and toolchain file first for layer caching
COPY Cargo.toml Cargo.lock rust-toolchain ./

# Copy source code and all assets required by Trunk
COPY src/ src/
COPY index.html ./
COPY Trunk.toml ./
COPY worker.js ./
COPY presets/ presets/
COPY assets/ assets/

RUN trunk build --release

# Stage 2: Serve the static site with nginx
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
