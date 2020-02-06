# Sosume
Sosume is an entrypoint for Docker containers that automatically creates and switches to a sensible user.

## Description
When running Docker containers on developer machines, it's very common to mount in volumes for storing data created by processes running in the container. By default, data in these volumes will often end up owned by root, because all processes are running as root inside the container. Many container images solve this by providing environment variables that dictate what UID and GID the processes running in a container should have. This is useful, but it's annoying that this must be individually implemented in every container image.

Sosume aims to offer a fully featured, well tested user switching entrypoint that can be easily integrated into any container image.

## Features
* Real User Creation - Many applications require the user running them to be present in `/etc/passwd`. Sosume creates a real user account so that these applications work correctly.
* Automatic User Detection - The shim will look at what mounts are present in the container and automatically determine the correct UID and GID to use.
* Distribution as a Docker Image - Sosume is distributed as a Docker image. This means it can be included as a step in a [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) rather than having to worry about installing `curl` in your image, downloading a file and marking it as executable.
* Uses [gosu](https://github.com/tianon/gosu) - This tool calls out to gosu to do the actual user switching. This should mean that TTYs and signals are handled correctly.

## How to Use
Integrating Sosume into a container image is easy, and should only require a three-line change to your Dockerfile.
1. Add `FROM chrisgavin/sosume AS sosume` to the top of your image. You can also use a specific image tag to ensure you always get the same version of Sosume.
2. Add `COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/` anywhere in the build steps for your image.
3. Set your entrypoint with `ENTRYPOINT ["/var/opt/sosume/sosume", "/usr/bin/your-entrypoint"]`.

Here is a full example of a Dockerfile for `protoc` with the Sosume tool embedded. Normally when running `protoc` in Docker, output files would end up owned by root, but because Sosume is used, the files end up owned by the user who ran the container.
```dockerfile
FROM chrisgavin/sosume AS sosume
FROM alpine:3.11
COPY --from=sosume /var/opt/sosume/ /var/opt/sosume/
RUN apk --no-cache add protoc
ENTRYPOINT ["/var/opt/sosume/sosume", "/usr/bin/protoc"]
```

## Environment Variables
The behavior of Sosume can be customized with environment variables. These can either be set in your own Dockerfile with `ENV` or by the user invoking your image.

* `SOSUME_UID` - Override the id of the user that will be created in the container.
* `SOSUME_GID` - Override the id of the primary group of the user that will be created in the container.
* `SOSUME_NAME` - Set both the user and group name of the user. If not specified "user" will be used.
* `SOSUME_USER_NAME` - Set just the user name of the user.
* `SOSUME_GROUP_NAME` - Set just the group name of the user.
* `SOSUME_HOME` - Set home directory of the new user. By default, `/home/$SOSUME_USER_NAME` is used.
