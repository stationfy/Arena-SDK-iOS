import Foundation

internal struct Configuration {
    private let environment: Environment

    init(environment: Environment = .production) {
        self.environment = environment
    }

    var bundleID: String {
        switch environment {
        case .production:
            return "com.arenaapp.Publisher"
        case .development:
            return "com.arenaapp.PublisherDev"
        }
    }

    var clientID: String {
        switch environment {
        case .production:
            return "93245052156-p1q034qa5un08a7jub7prbidl85n29b6.apps.googleusercontent.com"
        case .development:
            return "562157265951-lhs20vd14mhtafki8m02oucoetjhg03m.apps.googleusercontent.com"
        }
    }

    var apiKey: String {
        switch environment {
        case .production:
            return "AIzaSyBDSR7H6vU4w19BZc4IJ8hqfkhlQiHJktk"
        case .development:
            return "AIzaSyCLzGcieiNLovYL0rJNX0pfcxXqjwYTshk"
        }
    }

    var projectID: String {
        switch environment {
        case .production:
            return "arena-im-prd"
        case .development:
            return "arena-im-dev"
        }
    }

    var storageBucket: String {
        switch environment {
        case .production:
            return "arena-im-prd.appspot.com"
        case .development:
            return "arena-im-dev.appspot.com"
        }
    }

    var databaseURL: String {
        switch environment {
        case .production:
            return "https://arena-im-prd.firebaseio.com"
        case .development:
            return "https://arena-im-dev.firebaseio.com"
        }
    }

    var googleAppID: String {
        switch environment {
        case .production:
            return "1:93245052156:ios:b1cae70b251159e9"
        case .development:
            return "1:562157265951:ios:342785e1eee14005"
        }
    }

    var gcmSenderID: String {
        switch environment {
        case .production:
            return "93245052156"
        case .development:
            return "562157265951"
        }
    }

    var storeName: String {
        return gcmSenderID
    }

    var cachedBaseURL: String {
        switch environment {
        case .production:
            return "https://cached-api.arena.im/"
        case .development:
            return "https://cached-api-dev.arena.im/"
        }
    }

    var socketBaseURL: String {
        switch environment {
        case .production:
            return "https://realtime.arena.im"
        case .development:
            return "https://realtime-dev.arena.im"
        }
    }

    var chatBaseURL: String {
        switch environment {
        case .production:
            return "https://api.arena.im/"
        case .development:
            return "https://api-dev.arena.im/"
        }
    }

    var graphQLBaseURL: String {
        switch environment {
        case .production:
            return "https://svwasfrojfhtvajv3re6mulzse.appsync-api.us-west-2.amazonaws.com/graphql"
        case .development:
            return "https://vvfkuo3y7zecvapitevg4h7h6i.appsync-api.us-west-2.amazonaws.com/graphql"
        }
    }

    var anonymousToken: String {
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NGQ5OGJiNmY3MDIyOGU4MWI4Njc5YmUiLCJyb2xlcyI6WyJVU0VSIl0sImV4cCI6MzM2OTQxODM2OSwiaWF0IjoxNDc3MjU4MzY5fQ.dNpdrs3ehrGAhnPFIlWMrQFR4mCFKZl_Lvpxk1Ddp4o"
    }
}

public enum Environment: String {
    case development = "Development"
    case production = "Production"
}
