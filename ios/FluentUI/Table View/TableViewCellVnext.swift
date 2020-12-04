//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

public class TableViewCellState: ObservableObject {
    @Published var title: String
    @Published var subtitle: String
    @Published var leadingView: String
    init(title: String, subtitle: String?, leadingView: String?) {
        self.title = title
        self.subtitle = subtitle ?? ""
        self.leadingView = leadingView ?? ""
    }
}

public struct TableViewCellVnextView: View {
    @ObservedObject var state: TableViewCellState

    public var body: some View {
        HStack {
            Image(state.leadingView)
            //adjust image size using token
//                .padding(.trailing, 10)
            Spacer()
            VStack(alignment: .leading) {
                // Font tokens include:
                //   - text color
                //   - font
                //   - # of lines
                Text(state.title)
                Text(state.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
//            Spacer()
        }
        .background(Color.blue)
//        .frame(idealWidth: .infinity)
        //adjust height so it is dynamic to content
    }
}

@objc(MSFTableViewCellVnext)
//open class MSFButton: NSObject .KeyValueObservingPublishermake hosting controller a private var
open class TableViewCellVnext: UIHostingController<TableViewCellVnextView> {
    @objc open var cellTitle: String = "" {
        didSet {
            self.rootView.state.title = cellTitle
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

    @objc public init(title: String, subtitle: String = "", leadingView: String = "") {
        super.init(rootView: TableViewCellVnextView(state: TableViewCellState(title: title, subtitle: subtitle, leadingView: leadingView)))
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.fitIntoSuperview()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

public struct TableViewCellVnext_Previews: PreviewProvider {
    public static var previews: some View {
        let state = TableViewCellState(title: "This is Title", subtitle: "", leadingView: "chevron-right-20x20")
        TableViewCellVnextView(state: state)
    }
}


