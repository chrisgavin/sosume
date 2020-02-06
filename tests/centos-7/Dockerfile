FROM chrisgavin/sosume AS sosume
FROM centos:7
COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/
ENTRYPOINT ["/var/opt/sosume/sosume"]
