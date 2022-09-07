import Foundation

struct PublisherConfig: Decodable {

    let dateFormat: String?
    let language: String?
    let periodTimeFormat: String?
    let profanityFilterType: String?
    let monetizationPositionBottomUnit: String?
    let monetizationPositionInContentUnit: String?
    let monetizationPositionTopUnit: String?
    let monetizationFrequency: Int?
    let adsIsEnabled: Bool?
    let editorSwitch: Bool?
    let monetizationPositionBottom: Bool?
    let monetizationPositionInContent: Bool?
    let monetizationPositionTop: Bool?
    let migratedGraphQL: Bool?
    let enforceDomainSecurity: Bool?
    let migratedChatRoom: Bool?
    let monetizationEnabled: Bool?
}
