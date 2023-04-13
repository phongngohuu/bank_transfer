#Build stage 
# run [docker build -t bank_transfer:latest .] for build docker image from dockerfile
# run [docker images][ps] to check docker images/running
# run [docker rmi image_id] to remove docker image
# run [docker container inspect postgres12] view info port,...
# run [docker network ls] to see all network
# run [docker network create bank-network] create go net work
# run [docker network connect bank-network postgres12] to connect go to db
# run [docker network inspect bank-network] to connect go to db
# run [docker container ls] list all container running
# run [docker rm --force bank_transfer] force delete container
# run [docker run --name bank_transfer --network bank-network -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:123456@postgres12:5432/transfer_bank?sslmode=disable" bank_transfer:latest] to run golang image

FROM golang:1.19-alpine3.17 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go
RUN apk add curl
RUN  curl -L https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz | tar xvz

#Run stage
FROM alpine:3.17
WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/migrate ./migrate
COPY app.env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./migration

EXPOSE 8080
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh"]