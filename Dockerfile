FROM golang:1.14-alpine
WORKDIR /src
RUN apk --no-cache add git
COPY *.go go.mod go.sum ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /bin/prometheus-ecs-discovery .

FROM alpine:3.12
RUN apk --no-cache add ca-certificates
COPY --from=0 /bin/prometheus-ecs-discovery /bin/
ENTRYPOINT ["prometheus-ecs-discovery","--config.dynamic-port-detection"]
