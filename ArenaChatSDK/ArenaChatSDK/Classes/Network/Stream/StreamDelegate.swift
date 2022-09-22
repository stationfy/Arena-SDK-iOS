//  Copyright

import Foundation
import FirebaseFirestore

enum SnapsnotType {
    case reaction
    case event
}

protocol StreamDelegate: class {

    func stream(_ streamLayer: ChatStreaming,
                didReceivedSnapshot snapshot: QuerySnapshot,
                snapshotType type: SnapsnotType,
                isReloading: Bool)
    func stream(_ streamLayer: ChatStreaming,
                didReceivedError error: Error)
}
