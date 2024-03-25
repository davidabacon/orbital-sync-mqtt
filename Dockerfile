FROM node:18-alpine as builder
ENV NODE_ENV=development

WORKDIR /usr/src/app
COPY . .
RUN yarn install
RUN yarn tsc


FROM node:18-alpine as install
ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY . .
RUN yarn install --production


FROM node:18-alpine
ENV NODE_ENV=production

WORKDIR /usr/src/app
COPY package.json yarn.lock ./

COPY --from=builder /usr/src/app/dist ./dist
COPY --from=install /usr/src/app/node_modules ./node_modules

CMD [ "node", "dist/index.js" ]
