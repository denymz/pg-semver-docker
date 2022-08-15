FROM postgres:12-alpine as build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && \
    apk add git make gcc postgresql12-dev libc-dev && \
    cd /usr/src/ && git clone https://github.com/theory/pg-semver.git && \
    cd pg-semver && \
    make && \
    make install


FROM postgres:12-alpine as runtime
COPY --from=build /usr/local/share/postgresql/extension/semver* /usr/local/share/postgresql/extension/
COPY --from=build /usr/local/lib/postgresql/semver.so /usr/local/lib/postgresql/
COPY --from=build /usr/local/lib/postgresql/bitcode/src/ /usr/local/lib/postgresql/bitcode/src
COPY --from=build /usr/local/share/doc/postgresql/extension/ /usr/local/share/doc/postgresql/extension

