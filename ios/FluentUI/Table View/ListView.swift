////
////  Copyright (c) Microsoft Corporation. All rights reserved.
////  Licensed under the MIT License.
////
//
//import UIKit
//import SwiftUI
//
//public class TVCellVnext: ObservableObject, Identifiable {
//    public var id = UUID()
//    @Published var leadingView: String
//    @Published var title: String
//    @Published var subtitle: String
//    init(title: String, subtitle: String?, leadingView: String?) {
//        self.title = title
//        self.subtitle = subtitle ?? ""
//        self.leadingView = leadingView ?? ""
//    }
//}
//
//public class ListState: ObservableObject {
//    @Published var cells: [TableViewCellVnext]
//    init(cells: [TableViewCellVnext]) {
//        self.cells = cells
//    }
//}
//
//struct ListVnextView: View {
//    @ObservedObject var cellState: TVCellVnext
//
//    var body: some View {
//        Text("Hello")
////        NavigationView {
////            List {
////                HStack {
////                    Image(cellState)
////                    //adjust image size using token
////                        .padding(.trailing, 10)
////                    VStack(alignment: .leading) {
////                        // Font tokens include:
////                        //   - text color
////                        //   - font
////                        //   - # of lines
////                        Text(state.title)
////                        Text(state.subtitle)
////                            .font(.subheadline)
////                            .foregroundColor(.gray)
////                    }
////                    Spacer()
////                }
////                .background(Color.blue)
////                .frame(idealWidth: .infinity)
////            }
//        }
////        List(state.cells) { cell in
////            cell.
////        }
//    }
//}
//
////@objc(MSFListVnext)
////open class ListVnext: UIHostingController<ListVnextView> {
////    @objc open var cellContent: TableViewCellVnextView {
////        didSet {
////            self.rootView.state.cells = cellContent
////        }
////    }
////
////    @objc public init(cells: TableViewCellVnextView) {
////        super.init(rootView: ListVnextView(state: ListState(cells: cells)))
////    }
////
////    public required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
////    }
////}
//
//public struct ListVnext_Previews: PreviewProvider {
//    public static var previews: some View {
//        let sampleCell1 = TableViewCellVnext(title: "Sample Title1", subtitle: "Sample Subtitle1", leadingView: "Settings_24")
//        let sampleCell2 = TableViewCellVnext(title: "Sample Title2", subtitle: "Sample Subtitle2", leadingView: "New_24")
//        let sampleCell3 = TableViewCellVnext(title: "Sample Title3", subtitle: "Sample Subtitle3", leadingView: "Home_24")
////        let sampleCellView1 = sampleCell1.rootView
////        let sampleCellView2 = sampleCell2.rootView
////        let sampleCellView3 = sampleCell3.view ?? UIView()
//        let state = ListState(cells: [sampleCell1, sampleCell2, sampleCell3])
//        ListVnextView(cellState: state)
//    }
//}
