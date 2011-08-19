NSString+colorValue
===================

NSString category creating UIColor from "#rrggbb(aa)" string.
Alpha value is option and defaults to #ff. There is also a
`colorValueWithFallback:` method that fallback to a provided
default color if the string is invalid.

Example usage
-------------

        #import "NSString+colorValue.h"

        self.backgroundColor = ["#aabbccdd" colorValue];
