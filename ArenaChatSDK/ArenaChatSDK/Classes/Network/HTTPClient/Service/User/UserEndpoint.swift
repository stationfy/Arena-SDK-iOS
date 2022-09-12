import Foundation

enum UserEndpoint: EndpointSetuping {

    case add(providerUser: ProviderUser)
    case ban(user: BanUser)

    var endpoint: String {
        switch self {
        case .add:
            return "v2/profile/ssoexchange"
        case .ban:
            return "v2/data/moderation/ban-user"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var parameters: Parameters? {
        switch self {
        case let .add(providerUser):
            return providerUser.dictionary
        case let .ban(user):
            return user.dictionary
        }
    }

    var isAuthenticated: Bool {
        return true
    }
}

