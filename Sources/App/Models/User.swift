//
//  User.swift
//  
//
//  Created by Julian Smith on 3/8/23.
//

import Vapor
import Fluent

final class User: Model, Content {
  static let schema = "users"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "username")
  var username: String
  
  @Field(key: "email")
  var email: String
  
  @Field(key: "password_hash")
  var passwordHash: String
  
  @Field(key: "name")
  var name: String?
  
  @Field(key: "city")
  var city: String?
  
  @Field(key: "state")
  var state: String?
  
  @Field(key: "bio")
  var bio: String?
  
  @Field(key: "website")
  var website: String?
  
  @Children(for: \.$user)
  var posts: [Post]
  
  init(){}
  
  init(id: UUID? = nil, username: String, email: String, passwordHash: String, name: String? = nil, city: String? = nil, state: String? = nil, bio: String? = nil, website: String? = nil) {
    self.id = id
    self.username = username
    self.email = email
    self.passwordHash = passwordHash
    self.name = name
    self.city = city
    self.state = state
    self.bio = bio
    self.website = website
  }
}

extension User {
  struct Create: Content {
    var username: String
    var email: String
    var password: String
    var confirmPassword: String
  }
}

extension User: ModelAuthenticatable {
  static let usernameKey = \User.$username
  static let passwordHashKey = \User.$passwordHash
  
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.passwordHash)
  }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension User {
  struct LogoutResponse: AsyncResponseEncodable, Encodable {
    var message: String
    var status: String
    func encodeResponse(for request: Request) async throws -> Response {
      let encoder = JSONEncoder()
      let data = try encoder.encode(self)
      let response = Response(status: .ok, body: .init(data: data))
      response.headers.replaceOrAdd(name: .contentType, value: "application/json")
      return response
    }
  }
}
