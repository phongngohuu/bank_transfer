#Build stage 
# run [docker build -t bank_transfer:latest .] for build docker image from dockerfile
# run [docker images][ps] to check docker images/running
# run [docker rmi image_id] to remove docker image
FROM golang:1.19-alpine3.17 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#Run stage
FROM alpine:3.17
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8888
CMD [ "/app/main" ]