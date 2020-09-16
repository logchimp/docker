#!/bin/bash

# yarn global add http-server & vue-cli-service
yarn global add http-server @vue/cli-service @vue/cli-plugin-babel @vue/cli-plugin-eslint vue-template-compiler

# build vue app
cd frontend && vue-cli-service build

# server 'dist' folder on server
echo $VUE_APP_SEVER_URL
http-server ./dist -p 8080 -d false