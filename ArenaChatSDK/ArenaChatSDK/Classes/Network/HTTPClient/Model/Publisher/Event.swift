struct Event: Decodable {
    let eventInfo: EventInfo
    let publisher: Publisher
    let chatInfo: ChatInfo?
}
