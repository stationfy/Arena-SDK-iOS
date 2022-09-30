import Foundation

public protocol LocalizeRepresentable: RawRepresentable {
    var localized: String { get }
    func localized(with parameters: String...) -> String
}

extension LocalizeRepresentable where RawValue == String {
    public var localized: String {
        let bundle = Bundle(identifier: "org.cocoapods.ArenaChatSDK") ?? .main
        return NSLocalizedString(rawValue, bundle: bundle, comment: rawValue)
    }

    public func localized(with parameters: String...) -> String {
        return String(format: self.localized, arguments: parameters)
    }
}

enum AccountText: String, LocalizeRepresentable {
    case logged = "ChatPopup.Account.logged"
    case singleSignOn = "ChatPopup.Account.singleSignOn"
    case anonymousSignIn = "ChatPopup.Account.anonymousSignIn"
}

enum ChooseNameText: String, LocalizeRepresentable {
    case nickname = "ChatPopup.ChooseName.nickname"
}

enum OnlineUsersText: String, LocalizeRepresentable {
    case one = "ChatPopup.UsersOnline.one"
    case many = "ChatPopup.UsersOnline.many"
}

enum ProfileText: String, LocalizeRepresentable {
    case logged = "ChatPopup.Profile.logged"
    case logout = "ChatPopup.Profile.logout"
}

enum SenderCellText: String, LocalizeRepresentable {
    case yourAnswered = "Cell.Sender.yourAnswered"
}

enum ReplyCellText: String, LocalizeRepresentable {
    case replied = "Cell.Reply.answered"
    case unsuported = "Cell.Reply.unsupported"
}

enum ReplyBottomText: String, LocalizeRepresentable {
    case replyingTo = "Bottom.Reply.replyingTo"
}

enum BottomViewText: String, LocalizeRepresentable {
    case message = "TextField.Placeholder.message"
}
