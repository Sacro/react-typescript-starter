FROM node:10 as prebuild
USER node
RUN mkdir -p /home/node/app/node_modules
WORKDIR /home/node/app
COPY --chown=node package.json yarn.lock ./
RUN yarn install
COPY --chown=node . ./
CMD ["yarn", "run", "start"]

FROM prebuild as build
USER node
WORKDIR /home/node/app
RUN yarn build

FROM nginx:stable as deploy
COPY --from=build /home/node/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
