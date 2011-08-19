#import "NSString+colorValueTest.h"
#import "NSString+colorValue.h"
#import "UIColor+hexString.h"

@implementation NSString_colorValueTest

- (void)testColorValue {
  STAssertEqualObjects([[@"#11223344" colorValue] hexString], @"#11223344", @"");
  STAssertEqualObjects([[@"#112233" colorValue] hexString], @"#112233", @"");
  STAssertEqualObjects([[@"#00000000" colorValue] hexString], @"#00000000", @"");
  STAssertEqualObjects([[@"#ffffffff" colorValue] hexString], @"#ffffff", @"");
  STAssertEqualObjects([[@"invalid" colorValueWithFallback:[UIColor blackColor]]
                        hexString], @"#000000", @"");
  STAssertEqualObjects([[@"#ffffff" colorValueWithFallback:[UIColor blackColor]]
                        hexString], @"#ffffff", @"");
}

@end
