//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

// MARK: MSTableViewCellShimmerDemoController

class MSTableViewCellShimmerDemoController: MSTableViewCellDemoController {
    let shimmerSynchronizer = MSAnimationSynchronizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // disable selection on the shimmer view
        navigationItem.rightBarButtonItem = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MSTableViewCellSampleData.numberOfItemsInSectionForShimmer
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let item = section.item

        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TableViewCell

        // fill with spaces representing the text that would go in each cell
        // double the character count because spaces take up much less horizontal space than
        // non-space characters in most fonts
        cell.setup(
            title: String(repeating: " ", count: item.text1.count * 2),
            subtitle: String(repeating: " ", count: item.text2.count * 2),
            footer: String(repeating: " ", count: item.text3.count * 2),
            customView: UIView()
        )

        cell.shimmer(synchronizer: shimmerSynchronizer)

        return cell
    }
}

extension TableViewCell {
    /// associated object key for shimmer view
    private static var shimmerViewKey: UInt8 = 0

    var shimmerView: ShimmerView? {
        get {
            return objc_getAssociatedObject(self, &TableViewCell.shimmerViewKey) as? ShimmerView
        }
        set {
            objc_setAssociatedObject(self, &TableViewCell.shimmerViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// Start or reset the shimmer
    func shimmer(synchronizer: MSAnimationSynchronizerProtocol) {
        // because the cells have different layouts in this example, remove and re-add the shimmers
        shimmerView?.removeFromSuperview()

        let shimmerView = ShimmerView(containerView: contentView, animationSynchronizer: synchronizer)
        contentView.addSubview(shimmerView)
        shimmerView.frame = contentView.bounds
        shimmerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shimmerView = shimmerView
    }
}
