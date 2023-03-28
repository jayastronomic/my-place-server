import Fluent
import Vapor

final class Post: Model, Content {
  static let schema = "posts"
  
  @ID(key: .id)
  var id: UUID?

  @Field(key: "content")
  var content: String
  
  @Parent(key: "user_id")
  var user: User
  
  init() { }

  init(id: UUID? = nil, content: String, userID: User.IDValue) {
    self.id = id
    self.content = content
    self.$user.id = userID
  }
}
