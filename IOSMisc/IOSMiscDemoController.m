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
  
  return self;
}

- (void)viewDidLoad {
  self.title = NSStringFromClass(self.viewClass);
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:
   [[[self.viewClass alloc] initWithFrame:self.view.frame]
    autorelease]];
}

@end
