NSString+digest
===============

Adds common message digest methods to NSString. Currently md2, md4, md5, sha1,
sha224, sha256, sha384 and sha512.

Two methods per digest type is added, e.g. `md5` returns a NSString hex string
representation and `md5Data` a `NSData` in binary.

Example usage
-------------

        #import "NSString+digest.h"

        - (void)test {
          NSLog(@"md5 for dogs is %@", [@"dogs" md5]);
        }

Will output:

        md5 for dogs is d28d2d3560fa76f0dbb1a452f8c38169
