#import "GradientLabelTestView.h"
#import "GradientLabelTest.h"

@implementation GradientLabelTestView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return nil;
  }
  
  GradientLabelTest *label = [[[GradientLabelTest alloc] init] autorelease];
  label.text = @"Testing";
  label.fontSize = 30;
  label.frame = CGRectMake(0, 0, 200, 36);
  [self addSubview:label];

  return self;
}

@end
