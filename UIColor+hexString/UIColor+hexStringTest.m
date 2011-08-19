#import "UIColor+hexStringTest.h"
#import "UIColor+hexString.h"
#import "NSString+colorValue.h"

@implementation UIColor_hexStringTest

- (void)testHexString {
  STAssertEqualObjects([[UIColor redColor] hexString], @"#ff0000", @"");
  STAssertEqualObjects([[@"#11223344" colorValue] hexString], @"#11223344", @"");
}

@end
