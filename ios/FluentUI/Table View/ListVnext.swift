  //
  //  Copyright (c) Microsoft Corporation. All rights reserved.
  //  Licensed under the MIT License.
  //

  import UIKit
  import SwiftUI

  ///Properties that make up cell content
  @objc(MSFListVnextItem)
  public class MSFListItem: NSObject, ObservableObject, Identifiable {
      public var id = UUID()
      @objc @Published public var leadingView: String?
      @objc @Published public var title: String = ""
      @objc @Published public var subtitle: String?
  }

  @objc(MSFListAccessoryVnextStyle)
  /// Pre-defined styles of icons
  public enum MSFListAccessoryVnextStyle: Int, CaseIterable {
      case iconOnly
      case withLabel
      case disclosure
  }

  @objc(MSFListAccessoryVnextSize)
  /// Pre-defined sizes of icons
  public enum MSFListAccessoryVnextSize: Int, CaseIterable {
      case icon
      case persona
      case disclosure
      case button
  }

  public class MSFListTokens: ObservableObject {
      @Published public var backgroundColor: UIColor!
      @Published public var borderColor: UIColor!
      @Published public var leadingIconColor: UIColor!
      @Published public var trailingIconColor: UIColor!
      @Published public var leadingTextColor: UIColor!
      @Published public var trailingTextColor: UIColor!

      @Published public var borderSize: CGFloat!
      @Published public var padding: CGFloat!
      @Published public var textFont: UIFont!
      @Published public var subtitleFont: UIFont!
      @Published public var leadingIconSize: CGFloat!
      @Published public var trailingIconSize: CGFloat!
      @Published public var interspace: CGFloat!

      var accessoryStyle: MSFListAccessoryVnextStyle!
      var accessorySize: MSFListAccessoryVnextSize!

      public init(accessoryStyle: MSFListAccessoryVnextStyle,
                  accessorySize: MSFListAccessoryVnextSize) {
          self.accessoryStyle = accessoryStyle
          self.accessorySize = accessorySize
          self.themeAware = true

          didChangeAppearanceProxy()
      }

      @objc open func didChangeAppearanceProxy() {
          backgroundColor = appearanceProxy.backgroundColor
          borderColor = appearanceProxy.borderColor
          borderSize = appearanceProxy.borderSize
          padding = appearanceProxy.padding
          textFont = appearanceProxy.textFont
          subtitleFont = appearanceProxy.subtitleFont
          leadingTextColor = appearanceProxy.textColor.leading
          trailingTextColor = appearanceProxy.textColor.trailing

          switch accessoryStyle {
          case .iconOnly, .none:
              leadingIconColor = appearanceProxy.iconColor.iconOnly
              trailingIconColor = appearanceProxy.iconColor.iconOnly
          case .withLabel:
              leadingIconColor = appearanceProxy.iconColor.withLabel
              trailingIconColor = appearanceProxy.iconColor.withLabel
          case .disclosure:
              trailingIconColor = appearanceProxy.iconColor.disclosure
          }

          switch accessorySize {
          case .icon, .none:
              leadingIconSize = appearanceProxy.iconSize.icon
              trailingIconSize = appearanceProxy.iconSize.icon
              interspace = appearanceProxy.interspace.icon
          case .persona:
              leadingIconSize = appearanceProxy.iconSize.persona
          case .disclosure:
              trailingIconSize = appearanceProxy.iconSize.disclosure
              interspace = appearanceProxy.interspace.disclosure
          case .button:
              interspace = appearanceProxy.interspace.button
          }
      }
  }

  public struct MSFListView: View {
      @ObservedObject var state: MSFListItem
      @ObservedObject var tokens: MSFListTokens
      var numCells: [MSFListItem]

      public init(cells: [MSFListItem], style: MSFListAccessoryVnextStyle, size: MSFListAccessoryVnextSize) {
          self.state = MSFListItem()
          self.tokens = MSFListTokens(accessoryStyle: style, accessorySize: size)
          self.numCells = cells
      }

      public var body: some View {
          List(numCells) { cell in
              HStack {
                  Image(cell.leadingView ?? "")
                      .resizable()
                      .frame(width: tokens.leadingIconSize, height: tokens.leadingIconSize)
                  VStack(alignment: .leading) {
                      Text(cell.title)
                          .font(Font(tokens.textFont))
                          .foregroundColor(Color(tokens.leadingTextColor))
                      Text(cell.subtitle ?? "")
                          .font(Font(tokens.subtitleFont))
                          .foregroundColor(Color(tokens.trailingTextColor))
                  }
                  Spacer()
              }
          }
          //Frame modifier is a temporary fix for constraint issue. This should be removed in the future.
          .frame(width: 400, height: 250, alignment: .center)
      }
  }

  @objc(MSFListVnext)
  open class MSFListVnext: NSObject {

      private var hostingController: UIHostingController<MSFListView>

      @objc open var view: UIView {
          return hostingController.view
      }

      @objc open var state: MSFListItem {
          return self.hostingController.rootView.state
      }

      @objc public init(cells: [MSFListItem],
                        style: MSFListAccessoryVnextStyle = .iconOnly,
                        size: MSFListAccessoryVnextSize = .icon) {
          self.hostingController = UIHostingController(rootView: MSFListView(cells: cells,
                                                                                  style: style,
                                                                                  size: size))
          super.init()
      }
  }

  public struct MSFListVnext_Previews: PreviewProvider {
      public static var previews: some View {
          let item1 = MSFListItem()
          item1.title = "Sample Title1"
          item1.subtitle = "Sample Subtitle1"
          let item2 = MSFListItem()
          item2.title = "Sample Title2"
          item2.subtitle = "Sample Subtitle2"
          let list = [item1, item2]
          let style: MSFListAccessoryVnextStyle = .iconOnly
          let size: MSFListAccessoryVnextSize = .icon
          return MSFListView(cells: list, style: style, size: size)
      }
  }
