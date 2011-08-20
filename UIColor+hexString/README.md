UIColor+hexString
=================

UIColor category for returning hex color string. Alpha part is
only included if not #ff.

Example usage
-------------

    #import "UIColor+hexString.h"

    NSLog(@"color %@", [[UIColor redColor] hexString]]);

Will output:

    color #ff0000
