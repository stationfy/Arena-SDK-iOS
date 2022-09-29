//  Copyright

import Foundation

struct BatchUpdates {
    let deleted: [IndexPath]
    let inserted: [IndexPath]
    let reloaded: [IndexPath]

    var debugDescription: String {
        return "inserted: \(inserted), deleted \(deleted), reloaded \(reloaded)"
    }
}

extension BatchUpdates {
    static func compare(oldValues: [Card],
                        newValues: [Card],
                        reloadModuleIds: Set<String>? = nil) -> BatchUpdates {
        var deleted = Set<IndexPath>()
        var reloaded = Set<IndexPath>()
        var foundValue = false

        var newValuesTuple = newValues
            .filter { $0.chatMessage.key != nil }
            .enumerated()
            .map { (id: $0.element.chatMessage.key,
                    offset: $0.offset,
                    alreadyFound: false) }

        let oldValuesTuple = oldValues
            .filter { $0.chatMessage.key != nil }
            .enumerated()
            .map { (id: $0.element.chatMessage.key ?? "",
                    offset: $0.offset) }

        for oldValue in oldValuesTuple {
            foundValue = false
            for newValue in newValuesTuple where newValue.alreadyFound == false {
                if oldValue.id == newValue.id, !newValue.alreadyFound {
                    if reloadModuleIds?.contains(oldValue.id.lowercased()) == true {
                        reloaded.insert(IndexPath(row: newValue.offset))
                    }

                    newValuesTuple[newValue.offset].alreadyFound = true
                    foundValue = true
                    break
                }
            }
            if !foundValue {
                deleted.insert(IndexPath(row: oldValue.offset))
            }
        }
        var inserted: Set<IndexPath> = Set(newValuesTuple.filter { !$0.alreadyFound }.map { IndexPath(row: $0.offset) })

        let intersection = inserted.intersection(deleted)
        inserted.subtract(intersection)
        deleted.subtract(intersection)
        reloaded.formUnion(intersection)

        return BatchUpdates(deleted: Array(deleted),
                            inserted: Array(inserted),
                            reloaded: Array(reloaded))
    }
}

// MARK: - IndexPath
private extension IndexPath {
    init(row: Int) {
        self.init(row: row, section: 0)
    }
}
