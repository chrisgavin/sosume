FROM alpine AS builder
RUN apk --no-cache add curl && \
	mkdir /var/opt/sosume/ && \
	curl --location --output /var/opt/sosume/gosu https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 && \
	chmod +x /var/opt/sosume/gosu
COPY ./sosume /var/opt/sosume/sosume

FROM scratch
COPY --from=builder /var/opt/sosume/ /var/opt/sosume/
