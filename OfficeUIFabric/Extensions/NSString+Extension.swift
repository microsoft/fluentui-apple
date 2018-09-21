//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

public extension NSString {
    /**
     To ensure iOS and Android achieve the same result when
     generating string hash codes (e.g. to determine avatar colors) we've
     copied Java's String implementation of `hashCode`.

     - Note: must use Int32 as JVM specification is 32-bits for ints
     - Returns: hash code of string
     */
    internal func javaHashCode() -> Int32 {
        var hash: Int32 = 0
        for i in 0..<length {
            // Allow overflows, mimicking Java behavior
            hash = 31 &* hash &+ Int32(character(at: i))
        }
        return hash
    }
}
