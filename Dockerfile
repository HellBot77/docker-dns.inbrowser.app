FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/dns.inbrowser.app.git && \
    cd dns.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /dns.inbrowser.app
COPY --from=base /git/dns.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /dns.inbrowser.app/dist /srv/http
EXPOSE 8043