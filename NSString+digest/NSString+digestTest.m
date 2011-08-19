#import "NSString+digestTest.h"
#import "NSString+digest.h"

@implementation NSString_digestTest

- (void)testDigest {
  STAssertEqualObjects([@"test" md5], @"098f6bcd4621d373cade4e832627b4f6", @"");
}

@end
