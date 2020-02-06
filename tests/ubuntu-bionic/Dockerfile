FROM chrisgavin/sosume AS sosume
FROM ubuntu:bionic
COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/
ENTRYPOINT ["/var/opt/sosume/sosume"]
