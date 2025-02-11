FROM mcr.microsoft.com/dotnet/sdk:8.0 as BUILDER
WORKDIR /app
RUN apt-get update && \
    apt-get -y install cmake build-essential libssl-dev pkg-config libboost-all-dev libsodium-dev libzmq5 libzmq3-dev golang-go
COPY . .
WORKDIR /app/src/Miningcore
RUN dotnet publish -c Release --framework net8.0 -o ../../build

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
RUN apt-get update && \
    apt-get install -y libzmq5 libzmq3-dev libsodium-dev curl && \
    apt-get clean
EXPOSE  4000-4090
COPY --from=BUILDER /app/build ./
CMD ["./Miningcore", "-c", "config.json" ]