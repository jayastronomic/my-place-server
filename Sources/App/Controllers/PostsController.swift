//
//  PostsController.swift
//  
//
//  Created by Julian Smith on 3/10/23.
//


import Fluent
import Vapor

struct PostsController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let posts = routes.grouped("posts")
    posts.get(use: index)
    posts.post(use: create)
  }
  
  // GET /posts
  func index(req: Request) async throws -> [Post] {
    try await Post.query(on: req.db).all()
  }
  
  // POST /posts
  func create(req: Request) async throws -> Post {
    // Decode the request JSON into a new Post object
    let newPost = try req.content.decode(Post.self)
    print(newPost)

    
    // Save the new post to the database
    try await newPost.save(on: req.db)
    
    // Return the new post as a response to
    return newPost
  }
}
