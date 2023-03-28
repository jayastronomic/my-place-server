//
//  File.swift
//  
//
//  Created by Julian Smith on 3/8/23.
//

import Fluent

struct CreateUsers: AsyncMigration {
  func prepare(on database: FluentKit.Database) async throws {
  try await database.schema("users")
      .id()
      .field("username", .string, .required)
      .field("email", .string, .required)
      .field("password_hash", .string, .required)
      .field("name", .string)
      .field("city", .string)
      .field("state", .string)
      .field("bio", .string)
      .field("website", .string)
      .unique(on: "username")
      .unique(on: "email")
      .create()
  }
  
  func revert(on database: FluentKit.Database) async throws {
    try await database.schema("users").delete()
  }
}
