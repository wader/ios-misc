#import "RatingSliderTestView.h"
#import "RatingSlider.h"

@implementation RatingSliderTestView

- (void)valueChanged:(id)sender {
  RatingSlider *slider = sender;
  
  NSLog(@"%f", slider.value);
}
			      
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return nil;
  }
  
  RatingSlider *slider = [[[RatingSlider alloc] init] autorelease];
  slider.frame = CGRectMake(0, 0, 15 * 5, 40);
  slider.emptyImage = [UIImage imageNamed:@"stars-empty.png"];
  slider.halfImage = [UIImage imageNamed:@"stars-half.png"];
  slider.fullImage = [UIImage imageNamed:@"stars-full.png"];
  slider.min = 0.0;
  slider.max = 5.0;
  // after setting min and max
  slider.value = 3.5;
  slider.stars = 5;
  // uncomment to only allow integer values
  //slider.integerValue = YES;
  // uncomment to not allow rating to change
  //slider.enabled = NO;
  [slider addTarget:self
	     action:@selector(valueChanged:)
   forControlEvents:UIControlEventValueChanged];
  [self addSubview:slider];
  
  return self;
}

@end
