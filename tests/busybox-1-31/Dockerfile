FROM chrisgavin/sosume AS sosume
FROM busybox:1.31
COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/
ENTRYPOINT ["/var/opt/sosume/sosume"]
