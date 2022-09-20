import Foundation
import FirebaseCore
import FirebaseFirestore

public final class ArenaChat {

    #if DEBUG
    private struct Constants {
        static let bundleID = "com.arenaapp.PublisherDev"
        static let clientID = "562157265951-lhs20vd14mhtafki8m02oucoetjhg03m.apps.googleusercontent.com"
        static let apiKey = "AIzaSyCLzGcieiNLovYL0rJNX0pfcxXqjwYTshk"
        static let projectID = "arena-im-dev"
        static let storageBucket = "arena-im-dev.appspot.com"
        static let databaseURL = "https://arena-im-dev.firebaseio.com"
        static let googleAppID = "1:562157265951:ios:342785e1eee14005"
        static let gcmSenderID = "562157265951"
        static let storeName = "562157265951"
    }
    #else
    private struct Constants {
        static let bundleID = "com.arenaapp.Publisher"
        static let clientID = "93245052156-p1q034qa5un08a7jub7prbidl85n29b6.apps.googleusercontent.com"
        static let apiKey = "AIzaSyBDSR7H6vU4w19BZc4IJ8hqfkhlQiHJktk"
        static let projectID = "arena-im-prd"
        static let storageBucket = "arena-im-prd.appspot.com"
        static let databaseURL = "https://arena-im-prd.firebaseio.com"
        static let googleAppID = "1:93245052156:ios:b1cae70b251159e9"
        static let gcmSenderID = "93245052156"
        static let storeName = "93245052156"
    }
    #endif

    public static var shared = ArenaChat()
    static let widgetType = "Chat"

    var writeKey: String?
    var channel: String?

    var firestore: Firestore?

    init() {}

    /// Setup method that prepares all internal dependencies
    ///
    /// - Parameter writeKey: The write key is the one used to initialize the SDK and will be provided by Arena team
    /// - Parameter channel: The channel is the one used to initialize the SDK and will be provided by Arena team
    public static func setup(writeKey: String, channel: String) {
        shared.writeKey = writeKey
        shared.channel = channel

        let options: FirebaseOptions = FirebaseOptions(googleAppID: Constants.googleAppID,
                                                       gcmSenderID: Constants.gcmSenderID)
        options.bundleID = Constants.bundleID
        options.clientID = Constants.clientID
        options.apiKey = Constants.apiKey
        options.projectID = Constants.projectID
        options.storageBucket = Constants.storageBucket
        options.databaseURL = Constants.databaseURL
        FirebaseApp.configure(name: Constants.storeName, options: options)

        guard let app = FirebaseApp.app(name: Constants.storeName) else {
            // TODO: Failure
            return
        }

        shared.firestore = Firestore.firestore(app: app)
    }
}
