import Foundation
import FirebaseCore
import FirebaseFirestore

public final class ArenaChat {

    internal static var shared = ArenaChat()
    static let widgetType = "Chat"

    var writeKey: String?
    var channel: String?

    internal var configuration: Configuration = Configuration(environment: .production)

    var firestore: Firestore?

    init() {}

    /// Setup method that prepares all internal dependencies
    ///
    /// - Parameter writeKey: The write key is the one used to initialize the SDK and will be provided by Arena team
    /// - Parameter channel: The channel is the one used to initialize the SDK and will be provided by Arena team
    /// - Parameter environment: Environment configuration (`.production` or `.development`). Default value: `.production`
    public static func setup(writeKey: String,
                             channel: String,
                             environment: Environment = .production) {
        let configuration = Configuration(environment: environment)
        shared.writeKey = writeKey
        shared.channel = channel
        shared.configuration = configuration

        let options: FirebaseOptions = FirebaseOptions(
            googleAppID: configuration.googleAppID,
            gcmSenderID: configuration.gcmSenderID
        )
        options.bundleID = configuration.bundleID
        options.clientID = configuration.clientID
        options.apiKey = configuration.apiKey
        options.projectID = configuration.projectID
        options.storageBucket = configuration.storageBucket
        options.databaseURL = configuration.databaseURL
        FirebaseApp.configure(name: configuration.storeName, options: options)

        guard let app = FirebaseApp.app(name: configuration.storeName) else {
            // TODO: Failure
            return
        }

        shared.firestore = Firestore.firestore(app: app)
    }
}
