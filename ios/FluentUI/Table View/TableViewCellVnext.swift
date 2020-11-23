//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

//import UIKit
import SwiftUI

@available(iOS 13.0.0, *)
public class TableViewCellState: ObservableObject {
    @Published var title: String
    @Published var subtitle: String
    @Published var leadingView: String
    init(title: String, subtitle: String = "", leadingView: String = "") {
        self.title = title
        self.subtitle = subtitle
        self.leadingView = leadingView
    }
}

@available(iOS 13.0.0, *)
public struct TableViewCellVnextView: View {
    @ObservedObject var state: TableViewCellState

    public var body: some View {
        HStack {
            Image(state.leadingView)
            //adjust image size using token
            VStack {
                // Font tokens include:
                //   - text color
                //   - font
                //   - # of lines
                Text(state.title)
                Text(state.subtitle)
            }
        }
        //adjust height so it is dynamic to content
    }
}

//@objc(MSFTableViewCellVnext)
@available(iOS 13.0.0, *)
open class TableViewCellVnext: UIHostingController<TableViewCellVnextView> {
    @objc open var cellTitle: String = "" {
        didSet {
            self.rootView.state.title = title ?? ""
        }
    }

    @objc open var cellSubtitle: String = "" {
        didSet {
            self.rootView.state.subtitle = cellSubtitle
        }
    }

    @objc open var cellLeadingView: String = "" {
        didSet {
            self.rootView.state.leadingView = cellLeadingView
        }
    }
}

@available(iOS 13.0.0, *)
public struct TableViewCellVnext_Previews: PreviewProvider {
    public static var previews: some View {
        let state = TableViewCellState(title: "This is Title", subtitle: "This is subs")
        TableViewCellVnextView(state: state)
    }
}
