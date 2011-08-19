// this code is public domain

#import "NSArray+random.h"

@implementation NSArray(random)

- (id)randomObject {
  if ([self count] == 0) {
    return nil;
  }
  
  return [self objectAtIndex:arc4random() % [self count]];
}

@end
