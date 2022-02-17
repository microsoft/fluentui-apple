//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

/// Global Tokens represent a unified set of constants to be used by Fluent UI.
public extension GlobalTokens {
    struct SharedColors {
        public enum SharedColorsTokens: CaseIterable {
            case primary
            case shade10
            case shade20
            case shade30
            case shade40
            case shade50
            case tint10
            case tint20
            case tint30
            case tint40
            case tint50
            case tint60
        }

        lazy public var anchor: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x394146)
            case .shade10:
                return ColorValue(0x333a3f)
            case .shade20:
                return ColorValue(0x2b3135)
            case .shade30:
                return ColorValue(0x202427)
            case .shade40:
                return ColorValue(0x111315)
            case .shade50:
                return ColorValue(0x090a0b)
            case .tint10:
                return ColorValue(0x4d565c)
            case .tint20:
                return ColorValue(0x626c72)
            case .tint30:
                return ColorValue(0x808a90)
            case .tint40:
                return ColorValue(0xbcc3c7)
            case .tint50:
                return ColorValue(0xdbdfe1)
            case .tint60:
                return ColorValue(0xf6f7f8)
            }
        }

        lazy public var beige: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x7a7574)
            case .shade10:
                return ColorValue(0x6e6968)
            case .shade20:
                return ColorValue(0x5d5958)
            case .shade30:
                return ColorValue(0x444241)
            case .shade40:
                return ColorValue(0x252323)
            case .shade50:
                return ColorValue(0x141313)
            case .tint10:
                return ColorValue(0x8a8584)
            case .tint20:
                return ColorValue(0x9a9594)
            case .tint30:
                return ColorValue(0xafabaa)
            case .tint40:
                return ColorValue(0xd7d4d4)
            case .tint50:
                return ColorValue(0xeae8e8)
            case .tint60:
                return ColorValue(0xfaf9f9)
            }
        }

        lazy public var berry: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xc239b3)
            case .shade10:
                return ColorValue(0xaf33a1)
            case .shade20:
                return ColorValue(0x932b88)
            case .shade30:
                return ColorValue(0x6d2064)
            case .shade40:
                return ColorValue(0x3a1136)
            case .shade50:
                return ColorValue(0x1f091d)
            case .tint10:
                return ColorValue(0xc94cbc)
            case .tint20:
                return ColorValue(0xd161c4)
            case .tint30:
                return ColorValue(0xda7ed0)
            case .tint40:
                return ColorValue(0xedbbe7)
            case .tint50:
                return ColorValue(0xf5daf2)
            case .tint60:
                return ColorValue(0xfdf5fc)
            }
        }

        lazy public var blue: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x0078d4)
            case .shade10:
                return ColorValue(0x006cbf)
            case .shade20:
                return ColorValue(0x005ba1)
            case .shade30:
                return ColorValue(0x004377)
            case .shade40:
                return ColorValue(0x002440)
            case .shade50:
                return ColorValue(0x001322)
            case .tint10:
                return ColorValue(0x1a86d9)
            case .tint20:
                return ColorValue(0x3595de)
            case .tint30:
                return ColorValue(0x5caae5)
            case .tint40:
                return ColorValue(0xa9d3f2)
            case .tint50:
                return ColorValue(0xd0e7f8)
            case .tint60:
                return ColorValue(0xf3f9fd)
            }
        }

        lazy public var brass: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x986f0b)
            case .shade10:
                return ColorValue(0x89640a)
            case .shade20:
                return ColorValue(0x745408)
            case .shade30:
                return ColorValue(0x553e06)
            case .shade40:
                return ColorValue(0x2e2103)
            case .shade50:
                return ColorValue(0x181202)
            case .tint10:
                return ColorValue(0xa47d1e)
            case .tint20:
                return ColorValue(0xb18c34)
            case .tint30:
                return ColorValue(0xc1a256)
            case .tint40:
                return ColorValue(0xe0cea2)
            case .tint50:
                return ColorValue(0xefe4cb)
            case .tint60:
                return ColorValue(0xfbf8f2)
            }
        }

        lazy public var bronze: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xa74109)
            case .shade10:
                return ColorValue(0x963a08)
            case .shade20:
                return ColorValue(0x7f3107)
            case .shade30:
                return ColorValue(0x5e2405)
            case .shade40:
                return ColorValue(0x321303)
            case .shade50:
                return ColorValue(0x1b0a01)
            case .tint10:
                return ColorValue(0xb2521e)
            case .tint20:
                return ColorValue(0xbc6535)
            case .tint30:
                return ColorValue(0xca8057)
            case .tint40:
                return ColorValue(0xe5bba4)
            case .tint50:
                return ColorValue(0xf1d9cc)
            case .tint60:
                return ColorValue(0xfbf5f2)
            }
        }

        lazy public var brown: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x8e562e)
            case .shade10:
                return ColorValue(0x804d29)
            case .shade20:
                return ColorValue(0x6c4123)
            case .shade30:
                return ColorValue(0x50301a)
            case .shade40:
                return ColorValue(0x2b1a0e)
            case .shade50:
                return ColorValue(0x170e07)
            case .tint10:
                return ColorValue(0x9c663f)
            case .tint20:
                return ColorValue(0xa97652)
            case .tint30:
                return ColorValue(0xbb8f6f)
            case .tint40:
                return ColorValue(0xddc3b0)
            case .tint50:
                return ColorValue(0xedded3)
            case .tint60:
                return ColorValue(0xfaf7f4)
            }
        }

        lazy public var burgundy: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xa4262c)
            case .shade10:
                return ColorValue(0x942228)
            case .shade20:
                return ColorValue(0x7d1d21)
            case .shade30:
                return ColorValue(0x5c1519)
            case .shade40:
                return ColorValue(0x310b0d)
            case .shade50:
                return ColorValue(0x1a0607)
            case .tint10:
                return ColorValue(0xaf393e)
            case .tint20:
                return ColorValue(0xba4d52)
            case .tint30:
                return ColorValue(0xc86c70)
            case .tint40:
                return ColorValue(0xe4afb2)
            case .tint50:
                return ColorValue(0xf0d3d4)
            case .tint60:
                return ColorValue(0xfbf4f4)
            }
        }

        lazy public var charcoal: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x393939)
            case .shade10:
                return ColorValue(0x333333)
            case .shade20:
                return ColorValue(0x2b2b2b)
            case .shade30:
                return ColorValue(0x202020)
            case .shade40:
                return ColorValue(0x111111)
            case .shade50:
                return ColorValue(0x090909)
            case .tint10:
                return ColorValue(0x515151)
            case .tint20:
                return ColorValue(0x686868)
            case .tint30:
                return ColorValue(0x888888)
            case .tint40:
                return ColorValue(0xc4c4c4)
            case .tint50:
                return ColorValue(0xdfdfdf)
            case .tint60:
                return ColorValue(0xf7f7f7)
            }
        }

        lazy public var cornflower: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x4f6bed)
            case .shade10:
                return ColorValue(0x4760d5)
            case .shade20:
                return ColorValue(0x3c51b4)
            case .shade30:
                return ColorValue(0x2c3c85)
            case .shade40:
                return ColorValue(0x182047)
            case .shade50:
                return ColorValue(0x0d1126)
            case .tint10:
                return ColorValue(0x637cef)
            case .tint20:
                return ColorValue(0x778df1)
            case .tint30:
                return ColorValue(0x93a4f4)
            case .tint40:
                return ColorValue(0xc8d1fa)
            case .tint50:
                return ColorValue(0xe1e6fc)
            case .tint60:
                return ColorValue(0xf7f9fe)
            }
        }

        lazy public var cranberry: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xc50f1f)
            case .shade10:
                return ColorValue(0xb10e1c)
            case .shade20:
                return ColorValue(0x960b18)
            case .shade30:
                return ColorValue(0x6e0811)
            case .shade40:
                return ColorValue(0x3b0509)
            case .shade50:
                return ColorValue(0x200205)
            case .tint10:
                return ColorValue(0xcc2635)
            case .tint20:
                return ColorValue(0xd33f4c)
            case .tint30:
                return ColorValue(0xdc626d)
            case .tint40:
                return ColorValue(0xeeacb2)
            case .tint50:
                return ColorValue(0xf6d1d5)
            case .tint60:
                return ColorValue(0xfdf3f4)
            }
        }

        lazy public var cyan: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x0099bc)
            case .shade10:
                return ColorValue(0x008aa9)
            case .shade20:
                return ColorValue(0x00748f)
            case .shade30:
                return ColorValue(0x005669)
            case .shade40:
                return ColorValue(0x002e38)
            case .shade50:
                return ColorValue(0x00181e)
            case .tint10:
                return ColorValue(0x18a4c4)
            case .tint20:
                return ColorValue(0x31afcc)
            case .tint30:
                return ColorValue(0x56bfd7)
            case .tint40:
                return ColorValue(0xa4deeb)
            case .tint50:
                return ColorValue(0xcdedf4)
            case .tint60:
                return ColorValue(0xf2fafc)
            }
        }

        lazy public var darkBlue: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x003966)
            case .shade10:
                return ColorValue(0x00335c)
            case .shade20:
                return ColorValue(0x002b4e)
            case .shade30:
                return ColorValue(0x002039)
            case .shade40:
                return ColorValue(0x00111f)
            case .shade50:
                return ColorValue(0x000910)
            case .tint10:
                return ColorValue(0x0e4a78)
            case .tint20:
                return ColorValue(0x215c8b)
            case .tint30:
                return ColorValue(0x4178a3)
            case .tint40:
                return ColorValue(0x92b5d1)
            case .tint50:
                return ColorValue(0xc2d6e7)
            case .tint60:
                return ColorValue(0xeff4f9)
            }
        }

        lazy public var darkBrown: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x4d291c)
            case .shade10:
                return ColorValue(0x452519)
            case .shade20:
                return ColorValue(0x3a1f15)
            case .shade30:
                return ColorValue(0x2b1710)
            case .shade40:
                return ColorValue(0x170c08)
            case .shade50:
                return ColorValue(0x0c0704)
            case .tint10:
                return ColorValue(0x623a2b)
            case .tint20:
                return ColorValue(0x784d3e)
            case .tint30:
                return ColorValue(0x946b5c)
            case .tint40:
                return ColorValue(0xcaada3)
            case .tint50:
                return ColorValue(0xe3d2cb)
            case .tint60:
                return ColorValue(0xf8f3f2)
            }
        }

        lazy public var darkGreen: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x0b6a0b)
            case .shade10:
                return ColorValue(0x0a5f0a)
            case .shade20:
                return ColorValue(0x085108)
            case .shade30:
                return ColorValue(0x063b06)
            case .shade40:
                return ColorValue(0x032003)
            case .shade50:
                return ColorValue(0x021102)
            case .tint10:
                return ColorValue(0x1a7c1a)
            case .tint20:
                return ColorValue(0x2d8e2d)
            case .tint30:
                return ColorValue(0x4da64d)
            case .tint40:
                return ColorValue(0x9ad29a)
            case .tint50:
                return ColorValue(0xc6e7c6)
            case .tint60:
                return ColorValue(0xf0f9f0)
            }
        }

        lazy public var darkOrange: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xda3b01)
            case .shade10:
                return ColorValue(0xc43501)
            case .shade20:
                return ColorValue(0xa62d01)
            case .shade30:
                return ColorValue(0x7a2101)
            case .shade40:
                return ColorValue(0x411200)
            case .shade50:
                return ColorValue(0x230900)
            case .tint10:
                return ColorValue(0xde501c)
            case .tint20:
                return ColorValue(0xe36537)
            case .tint30:
                return ColorValue(0xe9835e)
            case .tint40:
                return ColorValue(0xf4bfab)
            case .tint50:
                return ColorValue(0xf9dcd1)
            case .tint60:
                return ColorValue(0xfdf6f3)
            }
        }

        lazy public var darkPurple: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x401b6c)
            case .shade10:
                return ColorValue(0x3a1861)
            case .shade20:
                return ColorValue(0x311552)
            case .shade30:
                return ColorValue(0x240f3c)
            case .shade40:
                return ColorValue(0x130820)
            case .shade50:
                return ColorValue(0x0a0411)
            case .tint10:
                return ColorValue(0x512b7e)
            case .tint20:
                return ColorValue(0x633e8f)
            case .tint30:
                return ColorValue(0x7e5ca7)
            case .tint40:
                return ColorValue(0xb9a3d3)
            case .tint50:
                return ColorValue(0xd8cce7)
            case .tint60:
                return ColorValue(0xf5f2f9)
            }
        }

        lazy public var darkRed: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x750b1c)
            case .shade10:
                return ColorValue(0x690a19)
            case .shade20:
                return ColorValue(0x590815)
            case .shade30:
                return ColorValue(0x420610)
            case .shade40:
                return ColorValue(0x230308)
            case .shade50:
                return ColorValue(0x130204)
            case .tint10:
                return ColorValue(0x861b2c)
            case .tint20:
                return ColorValue(0x962f3f)
            case .tint30:
                return ColorValue(0xac4f5e)
            case .tint40:
                return ColorValue(0xd69ca5)
            case .tint50:
                return ColorValue(0xe9c7cd)
            case .tint60:
                return ColorValue(0xf9f0f2)
            }
        }

        lazy public var darkTeal: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x006666)
            case .shade10:
                return ColorValue(0x005c5c)
            case .shade20:
                return ColorValue(0x004e4e)
            case .shade30:
                return ColorValue(0x003939)
            case .shade40:
                return ColorValue(0x001f1f)
            case .shade50:
                return ColorValue(0x001010)
            case .tint10:
                return ColorValue(0x0e7878)
            case .tint20:
                return ColorValue(0x218b8b)
            case .tint30:
                return ColorValue(0x41a3a3)
            case .tint40:
                return ColorValue(0x92d1d1)
            case .tint50:
                return ColorValue(0xc2e7e7)
            case .tint60:
                return ColorValue(0xeff9f9)
            }
        }

        lazy public var forest: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x498205)
            case .shade10:
                return ColorValue(0x427505)
            case .shade20:
                return ColorValue(0x376304)
            case .shade30:
                return ColorValue(0x294903)
            case .shade40:
                return ColorValue(0x162702)
            case .shade50:
                return ColorValue(0x0c1501)
            case .tint10:
                return ColorValue(0x599116)
            case .tint20:
                return ColorValue(0x6ba02b)
            case .tint30:
                return ColorValue(0x85b44c)
            case .tint40:
                return ColorValue(0xbdd99b)
            case .tint50:
                return ColorValue(0xdbebc7)
            case .tint60:
                return ColorValue(0xf6faf0)
            }
        }

        lazy public var gold: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xc19c00)
            case .shade10:
                return ColorValue(0xae8c00)
            case .shade20:
                return ColorValue(0x937700)
            case .shade30:
                return ColorValue(0x6c5700)
            case .shade40:
                return ColorValue(0x3a2f00)
            case .shade50:
                return ColorValue(0x1f1900)
            case .tint10:
                return ColorValue(0xc8a718)
            case .tint20:
                return ColorValue(0xd0b232)
            case .tint30:
                return ColorValue(0xdac157)
            case .tint40:
                return ColorValue(0xecdfa5)
            case .tint50:
                return ColorValue(0xf5eece)
            case .tint60:
                return ColorValue(0xfdfbf2)
            }
        }

        lazy public var grape: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x881798)
            case .shade10:
                return ColorValue(0x7a1589)
            case .shade20:
                return ColorValue(0x671174)
            case .shade30:
                return ColorValue(0x4c0d55)
            case .shade40:
                return ColorValue(0x29072e)
            case .shade50:
                return ColorValue(0x160418)
            case .tint10:
                return ColorValue(0x952aa4)
            case .tint20:
                return ColorValue(0xa33fb1)
            case .tint30:
                return ColorValue(0xb55fc1)
            case .tint40:
                return ColorValue(0xd9a7e0)
            case .tint50:
                return ColorValue(0xeaceef)
            case .tint60:
                return ColorValue(0xfaf2fb)
            }
        }

        lazy public var green: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x107c10)
            case .shade10:
                return ColorValue(0x0e700e)
            case .shade20:
                return ColorValue(0x0c5e0c)
            case .shade30:
                return ColorValue(0x094509)
            case .shade40:
                return ColorValue(0x052505)
            case .shade50:
                return ColorValue(0x031403)
            case .tint10:
                return ColorValue(0x218c21)
            case .tint20:
                return ColorValue(0x359b35)
            case .tint30:
                return ColorValue(0x54b054)
            case .tint40:
                return ColorValue(0x9fd89f)
            case .tint50:
                return ColorValue(0xc9eac9)
            case .tint60:
                return ColorValue(0xf1faf1)
            }
        }

        lazy public var hotPink: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xe3008c)
            case .shade10:
                return ColorValue(0xcc007e)
            case .shade20:
                return ColorValue(0xad006a)
            case .shade30:
                return ColorValue(0x7f004e)
            case .shade40:
                return ColorValue(0x44002a)
            case .shade50:
                return ColorValue(0x240016)
            case .tint10:
                return ColorValue(0xe61c99)
            case .tint20:
                return ColorValue(0xea38a6)
            case .tint30:
                return ColorValue(0xee5fb7)
            case .tint40:
                return ColorValue(0xf7adda)
            case .tint50:
                return ColorValue(0xfbd2eb)
            case .tint60:
                return ColorValue(0xfef4fa)
            }
        }

        lazy public var lavender: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x7160e8)
            case .shade10:
                return ColorValue(0x6656d1)
            case .shade20:
                return ColorValue(0x5649b0)
            case .shade30:
                return ColorValue(0x3f3682)
            case .shade40:
                return ColorValue(0x221d46)
            case .shade50:
                return ColorValue(0x120f25)
            case .tint10:
                return ColorValue(0x8172eb)
            case .tint20:
                return ColorValue(0x9184ee)
            case .tint30:
                return ColorValue(0xa79cf1)
            case .tint40:
                return ColorValue(0xd2ccf8)
            case .tint50:
                return ColorValue(0xe7e4fb)
            case .tint60:
                return ColorValue(0xf9f8fe)
            }
        }

        lazy public var lightBlue: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x3a96dd)
            case .shade10:
                return ColorValue(0x3487c7)
            case .shade20:
                return ColorValue(0x2c72a8)
            case .shade30:
                return ColorValue(0x20547c)
            case .shade40:
                return ColorValue(0x112d42)
            case .shade50:
                return ColorValue(0x091823)
            case .tint10:
                return ColorValue(0x4fa1e1)
            case .tint20:
                return ColorValue(0x65ade5)
            case .tint30:
                return ColorValue(0x83bdeb)
            case .tint40:
                return ColorValue(0xbfddf5)
            case .tint50:
                return ColorValue(0xdcedfa)
            case .tint60:
                return ColorValue(0xf6fafe)
            }
        }

        lazy public var lightGreen: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x13a10e)
            case .shade10:
                return ColorValue(0x11910d)
            case .shade20:
                return ColorValue(0x0e7a0b)
            case .shade30:
                return ColorValue(0x0b5a08)
            case .shade40:
                return ColorValue(0x063004)
            case .shade50:
                return ColorValue(0x031a02)
            case .tint10:
                return ColorValue(0x27ac22)
            case .tint20:
                return ColorValue(0x3db838)
            case .tint30:
                return ColorValue(0x5ec75a)
            case .tint40:
                return ColorValue(0xa7e3a5)
            case .tint50:
                return ColorValue(0xcef0cd)
            case .tint60:
                return ColorValue(0xf2fbf2)
            }
        }

        lazy public var lightTeal: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x00b7c3)
            case .shade10:
                return ColorValue(0x00a5af)
            case .shade20:
                return ColorValue(0x008b94)
            case .shade30:
                return ColorValue(0x00666d)
            case .shade40:
                return ColorValue(0x00373a)
            case .shade50:
                return ColorValue(0x001d1f)
            case .tint10:
                return ColorValue(0x18bfca)
            case .tint20:
                return ColorValue(0x32c8d1)
            case .tint30:
                return ColorValue(0x58d3db)
            case .tint40:
                return ColorValue(0xa6e9ed)
            case .tint50:
                return ColorValue(0xcef3f5)
            case .tint60:
                return ColorValue(0xf2fcfd)
            }
        }

        lazy public var lilac: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xb146c2)
            case .shade10:
                return ColorValue(0x9f3faf)
            case .shade20:
                return ColorValue(0x863593)
            case .shade30:
                return ColorValue(0x63276d)
            case .shade40:
                return ColorValue(0x35153a)
            case .shade50:
                return ColorValue(0x1c0b1f)
            case .tint10:
                return ColorValue(0xba58c9)
            case .tint20:
                return ColorValue(0xc36bd1)
            case .tint30:
                return ColorValue(0xcf87da)
            case .tint40:
                return ColorValue(0xe6bfed)
            case .tint50:
                return ColorValue(0xf2dcf5)
            case .tint60:
                return ColorValue(0xfcf6fd)
            }
        }

        lazy public var lime: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x73aa24)
            case .shade10:
                return ColorValue(0x689920)
            case .shade20:
                return ColorValue(0x57811b)
            case .shade30:
                return ColorValue(0x405f14)
            case .shade40:
                return ColorValue(0x23330b)
            case .shade50:
                return ColorValue(0x121b06)
            case .tint10:
                return ColorValue(0x81b437)
            case .tint20:
                return ColorValue(0x90be4c)
            case .tint30:
                return ColorValue(0xa4cc6c)
            case .tint40:
                return ColorValue(0xcfe5af)
            case .tint50:
                return ColorValue(0xe5f1d3)
            case .tint60:
                return ColorValue(0xf8fcf4)
            }
        }

        lazy public var magenta: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xbf0077)
            case .shade10:
                return ColorValue(0xac006b)
            case .shade20:
                return ColorValue(0x91005a)
            case .shade30:
                return ColorValue(0x6b0043)
            case .shade40:
                return ColorValue(0x390024)
            case .shade50:
                return ColorValue(0x1f0013)
            case .tint10:
                return ColorValue(0xc71885)
            case .tint20:
                return ColorValue(0xce3293)
            case .tint30:
                return ColorValue(0xd957a8)
            case .tint40:
                return ColorValue(0xeca5d1)
            case .tint50:
                return ColorValue(0xf5cee6)
            case .tint60:
                return ColorValue(0xfcf2f9)
            }
        }

        lazy public var marigold: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xeaa300)
            case .shade10:
                return ColorValue(0xd39300)
            case .shade20:
                return ColorValue(0xb27c00)
            case .shade30:
                return ColorValue(0x835b00)
            case .shade40:
                return ColorValue(0x463100)
            case .shade50:
                return ColorValue(0x251a00)
            case .tint10:
                return ColorValue(0xedad1c)
            case .tint20:
                return ColorValue(0xefb839)
            case .tint30:
                return ColorValue(0xf2c661)
            case .tint40:
                return ColorValue(0xf9e2ae)
            case .tint50:
                return ColorValue(0xfcefd3)
            case .tint60:
                return ColorValue(0xfefbf4)
            }
        }

        lazy public var mink: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x5d5a58)
            case .shade10:
                return ColorValue(0x54514f)
            case .shade20:
                return ColorValue(0x474443)
            case .shade30:
                return ColorValue(0x343231)
            case .shade40:
                return ColorValue(0x1c1b1a)
            case .shade50:
                return ColorValue(0x0f0e0e)
            case .tint10:
                return ColorValue(0x706d6b)
            case .tint20:
                return ColorValue(0x84817e)
            case .tint30:
                return ColorValue(0x9e9b99)
            case .tint40:
                return ColorValue(0xcecccb)
            case .tint50:
                return ColorValue(0xe5e4e3)
            case .tint60:
                return ColorValue(0xf8f8f8)
            }
        }

        lazy public var navy: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x0027b4)
            case .shade10:
                return ColorValue(0x0023a2)
            case .shade20:
                return ColorValue(0x001e89)
            case .shade30:
                return ColorValue(0x001665)
            case .shade40:
                return ColorValue(0x000c36)
            case .shade50:
                return ColorValue(0x00061d)
            case .tint10:
                return ColorValue(0x173bbd)
            case .tint20:
                return ColorValue(0x3050c6)
            case .tint30:
                return ColorValue(0x546fd2)
            case .tint40:
                return ColorValue(0xa3b2e8)
            case .tint50:
                return ColorValue(0xccd5f3)
            case .tint60:
                return ColorValue(0xf2f4fc)
            }
        }

        lazy public var orange: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xf7630c)
            case .shade10:
                return ColorValue(0xde590b)
            case .shade20:
                return ColorValue(0xbc4b09)
            case .shade30:
                return ColorValue(0x8a3707)
            case .shade40:
                return ColorValue(0x4a1e04)
            case .shade50:
                return ColorValue(0x271002)
            case .tint10:
                return ColorValue(0xf87528)
            case .tint20:
                return ColorValue(0xf98845)
            case .tint30:
                return ColorValue(0xfaa06b)
            case .tint40:
                return ColorValue(0xfdcfb4)
            case .tint50:
                return ColorValue(0xfee5d7)
            case .tint60:
                return ColorValue(0xfff9f5)
            }
        }

        lazy public var orchid: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x8764b8)
            case .shade10:
                return ColorValue(0x795aa6)
            case .shade20:
                return ColorValue(0x674c8c)
            case .shade30:
                return ColorValue(0x4c3867)
            case .shade40:
                return ColorValue(0x281e37)
            case .shade50:
                return ColorValue(0x16101d)
            case .tint10:
                return ColorValue(0x9373c0)
            case .tint20:
                return ColorValue(0xa083c9)
            case .tint30:
                return ColorValue(0xb29ad4)
            case .tint40:
                return ColorValue(0xd7caea)
            case .tint50:
                return ColorValue(0xe9e2f4)
            case .tint60:
                return ColorValue(0xf9f8fc)
            }
        }

        lazy public var peach: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xff8c00)
            case .shade10:
                return ColorValue(0xe67e00)
            case .shade20:
                return ColorValue(0xc26a00)
            case .shade30:
                return ColorValue(0x8f4e00)
            case .shade40:
                return ColorValue(0x4d2a00)
            case .shade50:
                return ColorValue(0x291600)
            case .tint10:
                return ColorValue(0xff9a1f)
            case .tint20:
                return ColorValue(0xffa83d)
            case .tint30:
                return ColorValue(0xffba66)
            case .tint40:
                return ColorValue(0xffddb3)
            case .tint50:
                return ColorValue(0xffedd6)
            case .tint60:
                return ColorValue(0xfffaf5)
            }
        }

        lazy public var pink: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xe43ba6)
            case .shade10:
                return ColorValue(0xcd3595)
            case .shade20:
                return ColorValue(0xad2d7e)
            case .shade30:
                return ColorValue(0x80215d)
            case .shade40:
                return ColorValue(0x441232)
            case .shade50:
                return ColorValue(0x24091b)
            case .tint10:
                return ColorValue(0xe750b0)
            case .tint20:
                return ColorValue(0xea66ba)
            case .tint30:
                return ColorValue(0xef85c8)
            case .tint40:
                return ColorValue(0xf7c0e3)
            case .tint50:
                return ColorValue(0xfbddf0)
            case .tint60:
                return ColorValue(0xfef6fb)
            }
        }

        lazy public var platinum: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x69797e)
            case .shade10:
                return ColorValue(0x5f6d71)
            case .shade20:
                return ColorValue(0x505c60)
            case .shade30:
                return ColorValue(0x3b4447)
            case .shade40:
                return ColorValue(0x1f2426)
            case .shade50:
                return ColorValue(0x111314)
            case .tint10:
                return ColorValue(0x79898d)
            case .tint20:
                return ColorValue(0x89989d)
            case .tint30:
                return ColorValue(0xa0adb2)
            case .tint40:
                return ColorValue(0xcdd6d8)
            case .tint50:
                return ColorValue(0xe4e9ea)
            case .tint60:
                return ColorValue(0xf8f9fa)
            }
        }

        lazy public var plum: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x77004d)
            case .shade10:
                return ColorValue(0x6b0045)
            case .shade20:
                return ColorValue(0x5a003b)
            case .shade30:
                return ColorValue(0x43002b)
            case .shade40:
                return ColorValue(0x240017)
            case .shade50:
                return ColorValue(0x13000c)
            case .tint10:
                return ColorValue(0x87105d)
            case .tint20:
                return ColorValue(0x98246f)
            case .tint30:
                return ColorValue(0xad4589)
            case .tint40:
                return ColorValue(0xd696c0)
            case .tint50:
                return ColorValue(0xe9c4dc)
            case .tint60:
                return ColorValue(0xfaf0f6)
            }
        }

        lazy public var pumpkin: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xca5010)
            case .shade10:
                return ColorValue(0xb6480e)
            case .shade20:
                return ColorValue(0x9a3d0c)
            case .shade30:
                return ColorValue(0x712d09)
            case .shade40:
                return ColorValue(0x3d1805)
            case .shade50:
                return ColorValue(0x200d03)
            case .tint10:
                return ColorValue(0xd06228)
            case .tint20:
                return ColorValue(0xd77440)
            case .tint30:
                return ColorValue(0xdf8e64)
            case .tint40:
                return ColorValue(0xefc4ad)
            case .tint50:
                return ColorValue(0xf7dfd2)
            case .tint60:
                return ColorValue(0xfdf7f4)
            }
        }

        lazy public var purple: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x5c2e91)
            case .shade10:
                return ColorValue(0x532982)
            case .shade20:
                return ColorValue(0x46236e)
            case .shade30:
                return ColorValue(0x341a51)
            case .shade40:
                return ColorValue(0x1c0e2b)
            case .shade50:
                return ColorValue(0x0f0717)
            case .tint10:
                return ColorValue(0x6b3f9e)
            case .tint20:
                return ColorValue(0x7c52ab)
            case .tint30:
                return ColorValue(0x9470bd)
            case .tint40:
                return ColorValue(0xc6b1de)
            case .tint50:
                return ColorValue(0xe0d3ed)
            case .tint60:
                return ColorValue(0xf7f4fb)
            }
        }

        lazy public var red: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xd13438)
            case .shade10:
                return ColorValue(0xbc2f32)
            case .shade20:
                return ColorValue(0x9f282b)
            case .shade30:
                return ColorValue(0x751d1f)
            case .shade40:
                return ColorValue(0x3f1011)
            case .shade50:
                return ColorValue(0x210809)
            case .tint10:
                return ColorValue(0xd7494c)
            case .tint20:
                return ColorValue(0xdc5e62)
            case .tint30:
                return ColorValue(0xe37d80)
            case .tint40:
                return ColorValue(0xf1bbbc)
            case .tint50:
                return ColorValue(0xf8dadb)
            case .tint60:
                return ColorValue(0xfdf6f6)
            }
        }

        lazy public var royalBlue: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x004e8c)
            case .shade10:
                return ColorValue(0x00467e)
            case .shade20:
                return ColorValue(0x003b6a)
            case .shade30:
                return ColorValue(0x002c4e)
            case .shade40:
                return ColorValue(0x00172a)
            case .shade50:
                return ColorValue(0x000c16)
            case .tint10:
                return ColorValue(0x125e9a)
            case .tint20:
                return ColorValue(0x286fa8)
            case .tint30:
                return ColorValue(0x4a89ba)
            case .tint40:
                return ColorValue(0x9abfdc)
            case .tint50:
                return ColorValue(0xc7dced)
            case .tint60:
                return ColorValue(0xf0f6fa)
            }
        }

        lazy public var seafoam: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x00cc6a)
            case .shade10:
                return ColorValue(0x00b85f)
            case .shade20:
                return ColorValue(0x009b51)
            case .shade30:
                return ColorValue(0x00723b)
            case .shade40:
                return ColorValue(0x003d20)
            case .shade50:
                return ColorValue(0x002111)
            case .tint10:
                return ColorValue(0x19d279)
            case .tint20:
                return ColorValue(0x34d889)
            case .tint30:
                return ColorValue(0x5ae0a0)
            case .tint40:
                return ColorValue(0xa8f0cd)
            case .tint50:
                return ColorValue(0xcff7e4)
            case .tint60:
                return ColorValue(0xf3fdf8)
            }
        }

        lazy public var silver: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x859599)
            case .shade10:
                return ColorValue(0x78868a)
            case .shade20:
                return ColorValue(0x657174)
            case .shade30:
                return ColorValue(0x4a5356)
            case .shade40:
                return ColorValue(0x282d2e)
            case .shade50:
                return ColorValue(0x151818)
            case .tint10:
                return ColorValue(0x92a1a5)
            case .tint20:
                return ColorValue(0xa0aeb1)
            case .tint30:
                return ColorValue(0xb3bfc2)
            case .tint40:
                return ColorValue(0xd8dfe0)
            case .tint50:
                return ColorValue(0xeaeeef)
            case .tint60:
                return ColorValue(0xfafbfb)
            }
        }

        lazy public var steel: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x005b70)
            case .shade10:
                return ColorValue(0x005265)
            case .shade20:
                return ColorValue(0x004555)
            case .shade30:
                return ColorValue(0x00333f)
            case .shade40:
                return ColorValue(0x001b22)
            case .shade50:
                return ColorValue(0x000f12)
            case .tint10:
                return ColorValue(0x0f6c81)
            case .tint20:
                return ColorValue(0x237d92)
            case .tint30:
                return ColorValue(0x4496a9)
            case .tint40:
                return ColorValue(0x94c8d4)
            case .tint50:
                return ColorValue(0xc3e1e8)
            case .tint60:
                return ColorValue(0xeff7f9)
            }
        }

        lazy public var teal: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0x038387)
            case .shade10:
                return ColorValue(0x037679)
            case .shade20:
                return ColorValue(0x026467)
            case .shade30:
                return ColorValue(0x02494c)
            case .shade40:
                return ColorValue(0x012728)
            case .shade50:
                return ColorValue(0x001516)
            case .tint10:
                return ColorValue(0x159195)
            case .tint20:
                return ColorValue(0x2aa0a4)
            case .tint30:
                return ColorValue(0x4cb4b7)
            case .tint40:
                return ColorValue(0x9bd9db)
            case .tint50:
                return ColorValue(0xc7ebec)
            case .tint60:
                return ColorValue(0xf0fafa)
            }
        }

        lazy public var yellow: TokenSet<SharedColorsTokens, ColorValue> = .init { token in
            switch token {
            case .primary:
                return ColorValue(0xfde300)
            case .shade10:
                return ColorValue(0xe4cc00)
            case .shade20:
                return ColorValue(0xc0ad00)
            case .shade30:
                return ColorValue(0x8e7f00)
            case .shade40:
                return ColorValue(0x4c4400)
            case .shade50:
                return ColorValue(0x282400)
            case .tint10:
                return ColorValue(0xfde61e)
            case .tint20:
                return ColorValue(0xfdea3d)
            case .tint30:
                return ColorValue(0xfeee66)
            case .tint40:
                return ColorValue(0xfef7b2)
            case .tint50:
                return ColorValue(0xfffad6)
            case .tint60:
                return ColorValue(0xfffef5)
            }
        }
    }
}
