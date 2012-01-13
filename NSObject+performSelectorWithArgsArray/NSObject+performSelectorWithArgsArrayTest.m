#import "NSObject+performSelectorWithArgsArrayTest.h"
#import "NSObject+performSelectorWithArgsArray.h"

@interface SomeClass : NSObject
@end
@implementation SomeClass
- (NSNumber *)withA:(NSNumber *)a withB:(NSNumber *)b {
  return [NSNumber numberWithInt:a.intValue + b.intValue];
}
@end

@implementation NSObject_performSelectorWithArgsArray

- (void)testDigest {
  SomeClass *a = [[SomeClass alloc] init];
  SEL sel = @selector(withA:withB:);
  NSArray *args = [NSArray arrayWithObjects:
                   [NSNumber numberWithInt:2],
                   [NSNumber numberWithInt:3],
                   nil];
  NSNumber *r = [a performSelector:sel withArgsArray:args];
  NSLog(@"%d", r.intValue);
  
  STAssertTrue(r.intValue == 5, @"");
}

@end

