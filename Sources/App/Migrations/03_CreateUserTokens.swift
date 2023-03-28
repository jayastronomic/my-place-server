//
//  CreateUserTokens.swift
//  
//
//  Created by Julian Smith on 3/20/23.
//

import Fluent

struct CreateUserTokens: AsyncMigration {
  func prepare(on database: Database) async throws {
      try await database.schema("user_tokens")
          .id()
          .field("value", .string, .required)
          .field("user_id", .uuid, .required, .references("users", "id"))
          .unique(on: "value")
          .create()
  }

  func revert(on database: Database) async throws {
      try await database.schema("user_tokens").delete()
  }
}

