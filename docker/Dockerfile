FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY app/pubspec.* ./
RUN dart pub get

COPY app/lib/server.dart .
RUN mkdir bin && dart compile exe server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/bin/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Start server
EXPOSE 8080
CMD ["/app/bin/server"]