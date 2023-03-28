//
//  AddAgeToUsers.swift
//  
//
//  Created by Julian Smith on 3/10/23.
//

import Fluent

struct AddAGeToUsers: AsyncMigration {
  func prepare(on database: FluentKit.Database) async throws {
  try await database.schema("users")
      .field("age", .int)
      .create()
     
  }
  
  func revert(on database: FluentKit.Database) async throws {
    try await database.schema("users").delete()
  }
}
