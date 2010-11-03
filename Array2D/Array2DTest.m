#import "Array2DTest.h"
#import "Array2D.h"

@implementation Array2DTest

+ (void)test {
  Array2D *grid = [[[Array2D alloc] initWithSize:CGSizeMake(3, 3)] autorelease];
  
  [grid setObject:@"test1" atX:0 y:0];
  [grid setObject:@"test2" at:CGPointMake(2, 2)];
  
  for (NSValue *pos in [grid positionEnumerator]) {
    NSLog(@"%f,%f %@",
	  pos.CGPointValue.x, pos.CGPointValue.y,
	  [grid objectAt:pos.CGPointValue]);
  }
}

@end
