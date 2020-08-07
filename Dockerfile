FROM golang:1.14 as build

ENV CGO_ENABLED 0

# install database clients
RUN apt-get update \
	&& apt-get install -y --no-install-recommends default-mysql-client postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# copy source files
COPY . /src
WORKDIR /src

# build
RUN make build

# runtime image
FROM gcr.io/distroless/base
COPY --from=build /src/dist/dbmate-linux-amd64 /dbmate
ENTRYPOINT ["/dbmate"]
