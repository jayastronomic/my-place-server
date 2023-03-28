//
//  SessionsController.swift
//  
//
//  Created by Julian Smith on 3/20/23.
//

import Fluent
import Vapor

struct AuthenticationsController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let passwordProtected = routes.grouped(User.authenticator())
    let tokenProtected = routes.grouped(UserToken.authenticator())
    passwordProtected.post("login", use: login)
    tokenProtected.get("me", use: me)
    tokenProtected.delete("logout", use: logout)
  }
  
  func login(request: Request) async throws -> UserToken {
    let user = try request.auth.require(User.self)
    let token = try user.generateToken()
    try await token.save(on: request.db)
    return token
  }
  
  func logout(request: Request) async throws -> User.LogoutResponse {
    guard let token = request.auth.get(UserToken.self) else {
      throw(Abort(.unauthorized))
    }
    try await token.delete(on: request.db)
    return User.LogoutResponse(message: "Successfuly Logged Out", status: "SUCCESS")
  }
  
  func me(request: Request) async throws -> User {
    try request.auth.require(User.self)
  }
}


