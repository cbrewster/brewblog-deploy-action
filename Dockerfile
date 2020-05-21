FROM rust:1.43-slim

RUN cargo install brewblog

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]