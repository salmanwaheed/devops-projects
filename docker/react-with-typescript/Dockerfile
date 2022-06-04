FROM node:18.18.0-slim

WORKDIR /app
COPY package*.json .
RUN npm install

COPY . .

CMD ["npm", "start"]
