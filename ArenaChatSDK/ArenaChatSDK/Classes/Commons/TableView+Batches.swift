//  Copyright

import UIKit

extension UITableView {
    func performUpdate(with batchUpdate: BatchUpdates) {
        let updates = batchUpdate.reloaded
        let deletions = batchUpdate.deleted
        let insertions = batchUpdate.inserted
        let animation = RowAnimation.automatic
        guard !updates.isEmpty || !deletions.isEmpty || !insertions.isEmpty else {
            return
        }

        performBatchUpdates({
            if !deletions.isEmpty { self.deleteRows(at: deletions, with: animation) }
            if !insertions.isEmpty { self.insertRows(at: insertions, with: animation) }
            if !updates.isEmpty { self.reloadRows(at: updates, with: animation) }
        })
    }
}
