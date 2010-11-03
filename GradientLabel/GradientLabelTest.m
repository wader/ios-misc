#import "GradientLabelTest.h"

@implementation GradientLabelTest

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.font = [UIFont fontWithName:@"Arial Rounded MT Bold"
                              size:[UIFont labelFontSize]];
  self.backgroundColor = [UIColor clearColor];
  self.gradientColors = [NSArray arrayWithObjects:
			 [UIColor colorWithRed:0.7f green:0.7f blue:0.4f alpha:1.0f],
			 [UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f],
			 [UIColor colorWithRed:0.4f green:0.9f blue:0.9f alpha:1.0f],
			 nil];
  self.gradientLocations = [NSArray arrayWithObjects:
			    [NSNumber numberWithFloat:0.0f],
			    [NSNumber numberWithFloat:0.5f],
			    [NSNumber numberWithFloat:1.0f],
			    nil];  
  self.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  self.shadowOffset = CGSizeMake(0.75f, 0.75f);
  self.backgroundColor = [UIColor clearColor];
  
  return self;
}

- (void)setFontSize:(CGFloat)size {
  self.font = [UIFont fontWithName:self.font.fontName size:size];
}

- (CGFloat)fontSize {
  return self.font.pointSize;
}

@end
