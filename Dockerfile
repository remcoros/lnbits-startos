FROM lnbitsdocker/lnbits-legend:0.10.10 as builder

# arm64 or amd64
ARG PLATFORM

RUN apt-get update && apt-get install -y bash curl sqlite3 tini --no-install-recommends
RUN curl -sS https://webi.sh/yq | sh

FROM lnbitsdocker/lnbits-legend:0.10.10 as final

COPY --from=builder /usr/bin/tini /usr/bin/tini
COPY --from=builder /usr/bin/sqlite3 /usr/bin/sqlite3
COPY --from=builder /root/.local/bin/yq /usr/local/bin/yq

ENV LNBITS_PORT 5000
ENV LNBITS_HOST lnbits.embassy

WORKDIR /app/
RUN mkdir -p ./data
ADD .env.example ./.env
RUN chmod a+x ./.env
ADD docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD check-web.sh /usr/local/bin/check-web.sh
RUN chmod a+x /usr/local/bin/*.sh
