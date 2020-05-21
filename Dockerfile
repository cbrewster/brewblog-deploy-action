FROM rust:1-alpine3.11

RUN cargo install brewblog

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]