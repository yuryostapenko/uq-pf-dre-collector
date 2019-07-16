FROM node:10

RUN mkdir /usr/app
WORKDIR /usr/app

COPY package*.json ./
RUN npm install

COPY . ./

RUN npm install pm2 -g

CMD ["pm2-runtime", "index.js"]