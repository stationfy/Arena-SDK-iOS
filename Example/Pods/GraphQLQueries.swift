// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct SendMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - groupChannelId
  ///   - message
  ///   - openChannelId
  ///   - replyTo
  ///   - sender
  ///   - slowMode
  ///   - tempId
  public init(groupChannelId: Swift.Optional<GraphQLID?> = nil, message: Swift.Optional<MessageContentInput?> = nil, openChannelId: Swift.Optional<GraphQLID?> = nil, replyTo: Swift.Optional<GraphQLID?> = nil, sender: Swift.Optional<AnonymousSenderInput?> = nil, slowMode: Swift.Optional<Bool?> = nil, tempId: Swift.Optional<String?> = nil) {
    graphQLMap = ["groupChannelId": groupChannelId, "message": message, "openChannelId": openChannelId, "replyTo": replyTo, "sender": sender, "slowMode": slowMode, "tempId": tempId]
  }

  public var groupChannelId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["groupChannelId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "groupChannelId")
    }
  }

  public var message: Swift.Optional<MessageContentInput?> {
    get {
      return graphQLMap["message"] as? Swift.Optional<MessageContentInput?> ?? Swift.Optional<MessageContentInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "message")
    }
  }

  public var openChannelId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["openChannelId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "openChannelId")
    }
  }

  public var replyTo: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["replyTo"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "replyTo")
    }
  }

  public var sender: Swift.Optional<AnonymousSenderInput?> {
    get {
      return graphQLMap["sender"] as? Swift.Optional<AnonymousSenderInput?> ?? Swift.Optional<AnonymousSenderInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var slowMode: Swift.Optional<Bool?> {
    get {
      return graphQLMap["slowMode"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "slowMode")
    }
  }

  public var tempId: Swift.Optional<String?> {
    get {
      return graphQLMap["tempId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tempId")
    }
  }
}

public struct MessageContentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - media
  ///   - text
  public init(media: Swift.Optional<MessageMediaInput?> = nil, text: Swift.Optional<String?> = nil) {
    graphQLMap = ["media": media, "text": text]
  }

  public var media: Swift.Optional<MessageMediaInput?> {
    get {
      return graphQLMap["media"] as? Swift.Optional<MessageMediaInput?> ?? Swift.Optional<MessageMediaInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "media")
    }
  }

  public var text: Swift.Optional<String?> {
    get {
      return graphQLMap["text"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "text")
    }
  }
}

public struct MessageMediaInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - isGif
  ///   - url
  public init(isGif: Swift.Optional<Bool?> = nil, url: Swift.Optional<String?> = nil) {
    graphQLMap = ["isGif": isGif, "url": url]
  }

  public var isGif: Swift.Optional<Bool?> {
    get {
      return graphQLMap["isGif"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isGif")
    }
  }

  public var url: Swift.Optional<String?> {
    get {
      return graphQLMap["url"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }
}

public struct AnonymousSenderInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - _id
  ///   - name
  ///   - image
  public init(_id: GraphQLID, name: String, image: Swift.Optional<String?> = nil) {
    graphQLMap = ["_id": _id, "name": name, "image": image]
  }

  public var _id: GraphQLID {
    get {
      return graphQLMap["_id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_id")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var image: Swift.Optional<String?> {
    get {
      return graphQLMap["image"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "image")
    }
  }
}

public struct PollVoteInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - optionId
  ///   - pollId
  ///   - userId
  public init(optionId: Int, pollId: GraphQLID, userId: Swift.Optional<GraphQLID?> = nil) {
    graphQLMap = ["optionId": optionId, "pollId": pollId, "userId": userId]
  }

  public var optionId: Int {
    get {
      return graphQLMap["optionId"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "optionId")
    }
  }

  public var pollId: GraphQLID {
    get {
      return graphQLMap["pollId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pollId")
    }
  }

  public var userId: Swift.Optional<GraphQLID?> {
    get {
      return graphQLMap["userId"] as? Swift.Optional<GraphQLID?> ?? Swift.Optional<GraphQLID?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userId")
    }
  }
}

public final class ReplyMessageMutationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ReplyMessageMutation($input: SendMessageInput!) {
      sendMessage(input: $input)
    }
    """

  public let operationName: String = "ReplyMessageMutation"

  public var input: SendMessageInput

  public init(input: SendMessageInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendMessage: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    public var sendMessage: GraphQLID {
      get {
        return resultMap["sendMessage"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

public final class SendMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SendMessage($input: SendMessageInput!) {
      sendMessage(input: $input)
    }
    """

  public let operationName: String = "SendMessage"

  public var input: SendMessageInput

  public init(input: SendMessageInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("sendMessage", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(GraphQLID.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(sendMessage: GraphQLID) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "sendMessage": sendMessage])
    }

    public var sendMessage: GraphQLID {
      get {
        return resultMap["sendMessage"]! as! GraphQLID
      }
      set {
        resultMap.updateValue(newValue, forKey: "sendMessage")
      }
    }
  }
}

public final class PollVoteMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PollVote($input: PollVoteInput!) {
      pollVote(input: $input)
    }
    """

  public let operationName: String = "PollVote"

  public var input: PollVoteInput

  public init(input: PollVoteInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("pollVote", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(pollVote: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "pollVote": pollVote])
    }

    public var pollVote: Bool {
      get {
        return resultMap["pollVote"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "pollVote")
      }
    }
  }
}

public final class DeleteReactionsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteReactions($itemId: ID!, $reaction: String!, $userId: ID!) {
      deleteReaction(input: {itemId: $itemId, reaction: $reaction, userId: $userId})
    }
    """

  public let operationName: String = "DeleteReactions"

  public var itemId: GraphQLID
  public var reaction: String
  public var userId: GraphQLID

  public init(itemId: GraphQLID, reaction: String, userId: GraphQLID) {
    self.itemId = itemId
    self.reaction = reaction
    self.userId = userId
  }

  public var variables: GraphQLMap? {
    return ["itemId": itemId, "reaction": reaction, "userId": userId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteReaction", arguments: ["input": ["itemId": GraphQLVariable("itemId"), "reaction": GraphQLVariable("reaction"), "userId": GraphQLVariable("userId")]], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteReaction: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteReaction": deleteReaction])
    }

    public var deleteReaction: Bool {
      get {
        return resultMap["deleteReaction"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteReaction")
      }
    }
  }
}
