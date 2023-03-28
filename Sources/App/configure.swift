import Fluent
import FluentPostgresDriver
import Vapor


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "juliansmith",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "myplace"
    ), as: .psql)
  
  app.migrations.add(CreateUsers())
  app.migrations.add(CreatePosts())
  app.migrations.add(CreateUserTokens())
  
  app.logger.logLevel = .debug
  
  try app.autoMigrate().wait()
  
    // register routes
    try routes(app)
}
