// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

struct SendMessageInput: GraphQLMapConvertible {
  var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - groupChannelId
  ///   - message
  ///   - openChannelId
  ///   - replyTo
  ///   - sender
  ///   - slowMode
  ///   - tempId
  init(groupChannelId: Swift.Optional<GraphQLID?> = nil, message: Swift.Optional<MessageContentInput?> = nil, openChannelId: Swift.Optional<GraphQLID?> = nil, replyTo: Swift.Optional<GraphQLID?> = nil, sender: Swift.Optional<AnonymousSenderInput?> = nil, slowMode: Swift.Optional<Bool?> = nil, tempId: Swift.Optional<String?> = nil) {
    graphQLMap = ["groupChannelId": groupChannelId, "message": message, "openChannelId": openChannelId, "replyTo": replyTo, "sender": sender, "slowMode": slowMode, "tempId": tempId]
  }

  var groupChannelId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["groupChannelId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "groupChannelId")
    }
  }

  var message: Swift.Optional<MessageContentInput?> {
    get {
      return graphQLMap["message"] as? Swift.Optional<MessageContentInput?> ?? Swift.Optional<MessageContentInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  var openChannelId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["openChannelId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "openChannelId")
    }
  }

  var replyTo: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["replyTo"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "replyTo")
    }
  }

  var sender: Swift.Optional<AnonymousSenderInput?> {
    get {
      return graphQLMap["sender"] as? Swift.Optional<AnonymousSenderInput?> ?? Swift.Optional<AnonymousSenderInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  var slowMode: Swift.Optional<Bool?> {
    get {
      return graphQLMap["slowMode"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "slowMode")
    }
  }

  var tempId: Swift.Optional<String?> {
    get {
      return graphQLMap["tempId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tempId")
    }
  }
}

struct MessageContentInput: GraphQLMapConvertible {
  var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - media
  ///   - text
  init(media: Swift.Optional<MessageMediaInput?> = nil, text: Swift.Optional<String?> = nil) {
    graphQLMap = ["media": media, "text": text]
  }

  var media: Swift.Optional<MessageMediaInput?> {
    get {
      return graphQLMap["media"] as? Swift.Optional<MessageMediaInput?> ?? Swift.Optional<MessageMediaInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "media")
    }
  }

  var text: Swift.Optional<String?> {
    get {
      return graphQLMap["text"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "text")
    }
  }
}

struct MessageMediaInput: GraphQLMapConvertible {
  var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - isGif
  ///   - url
  init(isGif: Swift.Optional<Bool?> = nil, url: Swift.Optional<String?> = nil) {
    graphQLMap = ["isGif": isGif, "url": url]
  }

  var isGif: Swift.Optional<Bool?> {
    get {
      return graphQLMap["isGif"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isGif")
    }
  }

  var url: Swift.Optional<String?> {
    get {
      return graphQLMap["url"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }
}

struct AnonymousSenderInput: GraphQLMapConvertible {
  var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - _id
  ///   - name
  ///   - image
  init(_id: GraphQLID, name: String, image: Swift.Optional<String?> = nil) {
    graphQLMap = ["_id": _id, "name": name, "image": image]
  }

  var _id: GraphQLID {
    get {
      return graphQLMap["_id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_id")
    }
  }

  var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  var image: Swift.Optional<String?> {
    get {
      return graphQLMap["image"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "image")
    }
  }
}

struct PollVoteInput: GraphQLMapConvertible {
  var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - optionId
  ///   - pollId
  ///   - userId
  init(optionId: Int, pollId: GraphQLID, userId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["optionId": optionId, "pollId": pollId, "userId": userId]
  }

  var optionId: Int {
    get {
      return graphQLMap["optionId"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "optionId")
    }
  }

  var pollId: GraphQLID {
    get {
      return graphQLMap["pollId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pollId")
    }
  }

  var userId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["userId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userId")
    }
  }
}

final class ReplyMessageMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  let operationDefinition: String =
    """
    mutation ReplyMessageMutation($input: SendMessageInput!) {
      sendMessage(input: $input)
    }
    """

  let operationName: String = "ReplyMessageMutation"

  var input: SendMessageInput

  init(input: SendMessageInput) {
    self.input = input
  }

  var variables: GraphQLMap? {
    return ["input": input]
  }

  struct Data: GraphQLSelectionSet {
    static let possibleTypes: [String] = ["Mutation"]

    static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    private(set) var resultMap: ResultMap

    init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    init(sendMessage: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    var sendMessage: GraphQLID {
      get {
        return resultMap["sendMessage"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

final class SendMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  let operationDefinition: String =
    """
    mutation SendMessage($input: SendMessageInput!) {
      sendMessage(input: $input)
    }
    """

  let operationName: String = "SendMessage"

  var input: SendMessageInput

  init(input: SendMessageInput) {
    self.input = input
  }

  var variables: GraphQLMap? {
    return ["input": input]
  }

  struct Data: GraphQLSelectionSet {
    static let possibleTypes: [String] = ["Mutation"]

    static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    private(set) var resultMap: ResultMap

    init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    init(sendMessage: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    var sendMessage: GraphQLID {
      get {
        return resultMap["sendMessage"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

final class PollVoteMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  let operationDefinition: String =
    """
    mutation PollVote($input: PollVoteInput!) {
      pollVote(input: $input)
    }
    """

  let operationName: String = "PollVote"

  var input: PollVoteInput

  init(input: PollVoteInput) {
    self.input = input
  }

  var variables: GraphQLMap? {
    return ["input": input]
  }

  struct Data: GraphQLSelectionSet {
    static let possibleTypes: [String] = ["Mutation"]

    static var selections: [GraphQLSelection] {
      return [
        GraphQLField("pollVote", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    private(set) var resultMap: ResultMap

    init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    init(pollVote: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "pollVote": pollVote])
    }

    var pollVote: Bool {
      get {
        return resultMap["pollVote"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "pollVote")
      }
    }
  }
}

final class DeleteReactionsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  let operationDefinition: String =
    """
    mutation DeleteReactions($itemId: ID!, $reaction: String!, $userId: ID!) {
      deleteReaction(input: {itemId: $itemId, reaction: $reaction, userId: $userId})
    }
    """

  let operationName: String = "DeleteReactions"

  var itemId: GraphQLID
  var reaction: String
  var userId: GraphQLID

  init(itemId: GraphQLID, reaction: String, userId: GraphQLID) {
    self.itemId = itemId
    self.reaction = reaction
    self.userId = userId
  }

  var variables: GraphQLMap? {
    return ["itemId": itemId, "reaction": reaction, "userId": userId]
  }

  struct Data: GraphQLSelectionSet {
    static let possibleTypes: [String] = ["Mutation"]

    static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteReaction", arguments: ["input": ["itemId": GraphQLVariable("itemId"), "reaction": GraphQLVariable("reaction"), "userId": GraphQLVariable("userId")]], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    private(set) var resultMap: ResultMap

    init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    init(deleteReaction: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteReaction": deleteReaction])
    }

    var deleteReaction: Bool {
      get {
        return resultMap["deleteReaction"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteReaction")
      }
    }
  }
}
