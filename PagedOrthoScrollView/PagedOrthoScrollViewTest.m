

#import "PagedOrthoScrollViewTest.h"

@implementation PagedOrthoScrollViewTest

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return nil;
  }
  
  self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                           UIViewAutoresizingFlexibleHeight);
  self.pagingEnabled = YES;
  self.contentSize = CGSizeMake(CGRectGetWidth(frame) * 5,
                                CGRectGetHeight(frame) * 5);
  UIView *v = [[[UIView alloc]
                initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2,
                                         CGRectGetHeight(frame) / 2,
                                         CGRectGetWidth(frame) * 2,
                                         CGRectGetHeight(frame) * 2)]
               autorelease];
  v.backgroundColor = [UIColor greenColor];
  [self addSubview:v];
  
  return self;
}

@end
