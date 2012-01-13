@implementation NSObject (performSelectorWithArgsArray)
- (id)performSelector:(SEL)sel withArgsArray:(NSArray *)args {
  NSInvocation *inv = [NSInvocation invocationWithMethodSignature:
                       [self methodSignatureForSelector:sel]];
  [inv setSelector:sel];
  [inv setTarget:self];
  for (int i = 0; i < args.count; i++) {
    id a = [args objectAtIndex:i];
    [inv setArgument:&a atIndex:2 + i]; // 0 is target, 1 i cmd-selector
  }
  [inv invoke];
  
  NSNumber *r;
  [inv getReturnValue:&r];
  return r;
}
@end