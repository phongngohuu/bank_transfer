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
# run [docker run --name bank_transfer --network bank-network -p 8888:8888 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:123456@postgres12:5432/transfer_bank?sslmode=disable" bank_transfer:latest] to run golang image

FROM golang:1.19-alpine3.17 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#Run stage
FROM alpine:3.17
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env .

EXPOSE 8888
CMD [ "/app/main" ]