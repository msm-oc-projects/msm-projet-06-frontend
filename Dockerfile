FROM node:20.19-alpine AS build

WORKDIR /workspace

COPY package*.json ./
RUN npm ci --cache .npm --prefer-offline

COPY . .
RUN npm run build

FROM nginx:1.27-alpine

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /workspace/dist/olympic-games-starter/browser /app

EXPOSE 80

