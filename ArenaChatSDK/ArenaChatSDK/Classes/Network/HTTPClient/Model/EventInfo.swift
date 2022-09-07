import Foundation

struct EventInfo: Decodable {

    let officialTournamentId: String?
    let presenceId: String?
    let summaryWordEvent: String?
    let chatId: String?
    let chatType: String?
    let status: String?
    let description: String?
    let language: String?
    let reactionType: String?
    let chatPosition: String?
    let timeTitleColor: String?
    let location: String?
    let key: String
    let slug: String?
    let liveblogLayout: String?
    let name: String?

    let startDate: Int64?
    let createdAt: Int64?
    let pagination: Int?

    let tags: [EventTag]?

    let isFirestore: Bool?
    let adsIsEnabled: Bool?
    let chatRoom: Bool?
    let statusBar: Bool?
    let infoTab: Bool?
    let share: Bool?
    let scoreBar: Bool?
    let voting: Bool?
    let commentIsEnabled: Bool?
    let soundAlert: Bool?
    let autoPlayByPlay: Bool?
}
