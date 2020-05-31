FROM rust:latest as build

WORKDIR /app

RUN rustup target add x86_64-unknown-linux-musl

## Create structure
RUN USER=root cargo new main

WORKDIR /app/main

## Copy dependencies 
COPY Cargo.toml Cargo.lock ./

## Cache
RUN cargo build --release

## Main app sources
COPY ./src ./src

## Build app
RUN cargo install --target x86_64-unknown-linux-musl --path .


## Multi stage final image
FROM scratch
COPY --from=build /usr/local/cargo/bin/main .
USER 1000
CMD ["./main"]
