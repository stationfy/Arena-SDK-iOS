struct Event: Decodable {
    let homeLineup: LineUp?
    let awayLineup: LineUp?
    let eventInfo: EventInfo?
    let publisher: Publisher?
    let chatInfo: ChatInfo?
    let settings: Settings?
    //let posts: List<Posts>?
}

