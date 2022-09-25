//  Copyright

import UIKit

extension UITableView {
    func performUpdate(with batchUpdate: BatchUpdates) {
        let updates = batchUpdate.reloaded
        let deletions = batchUpdate.deleted
        let insertions = batchUpdate.inserted
        let animation = RowAnimation.fade
        guard !updates.isEmpty || !deletions.isEmpty || !insertions.isEmpty else {
            return
        }

        performBatchUpdates({
            if !deletions.isEmpty { self.deleteRows(at: deletions, with: animation) }
            if !insertions.isEmpty { self.insertRows(at: insertions, with: animation) }
            if !updates.isEmpty { self.reloadRows(at: updates, with: animation) }
        }) { _ in
            self.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }

    private func updateTableContentInset(numRows: Int) {
        var contentInsetTop = self.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
    }
}
