//  Copyright

import Foundation
import FirebaseFirestore

enum SnapsnotType {
    case reaction
    case event
}

protocol StreamDelegate: class {

    func stream(_ streamLayer: Streaming,
                didReceivedSnapshot snapshot: QuerySnapshot,
                snapshotType type: SnapsnotType,
                isReloading: Bool)
    func stream(_ streamLayer: Streaming,
                didReceivedError error: Error)
}
