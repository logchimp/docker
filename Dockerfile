FROM node:12.18.3-buster

ARG logchimp_app_version

WORKDIR /root
COPY ./scripts/download-latest-release.sh .
RUN sh ./download-latest-release.sh ${logchimp_app_version}

WORKDIR /root/logchimp
COPY run.sh .

COPY ./scripts/backend.sh ./server
COPY ./scripts/frontend.sh ./frontend

# Install packages
RUN yarn install

# Environment variables
ENV SERVER_PORT=3000
ENV VUE_APP_SEVER_URL="http://localhost:${SERVER_PORT}"

CMD ["sh", "./run.sh"]