#import "IOSMiscDemoController.h"

@interface IOSMiscDemoController ()
@property(nonatomic, assign) Class viewClass;
@end

@implementation IOSMiscDemoController

@synthesize viewClass;

- (id)initWithViewClass:(Class)aViewClass {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.viewClass = aViewClass;
  self.title = NSStringFromClass(self.viewClass);
  
  return self;
}

- (void)loadView {
  self.view = [[[self.viewClass alloc]
                initWithFrame:[UIScreen mainScreen].bounds]
               autorelease];
  self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight);
  self.view.backgroundColor = [UIColor whiteColor];
}

@end
