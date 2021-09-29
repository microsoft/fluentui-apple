//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

open class FluentTheme: NSObject, ObservableObject {
    @Published open private(set) var cardNudge: CardNudgeThemeable?
}
