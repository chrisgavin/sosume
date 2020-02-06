FROM chrisgavin/sosume AS sosume
FROM alpine:3.11
COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/
ENTRYPOINT ["/var/opt/sosume/sosume"]
