#import "PagedScrollViewTestView.h"

@interface PagedScrollViewTestView ()
@property(nonatomic, retain) UIView *borderView;
@property(nonatomic, retain) UILabel *textLabel;
@end

@implementation PagedScrollViewTestView
@synthesize borderView;
@synthesize textLabel;

- (id)initWithFrame:(CGRect)aRect index:(NSUInteger)aIndex {
  self = [super initWithFrame:aRect];
  if (self == nil) {
    return nil;
  }
  
  self.borderView = [[[UIView alloc] init] autorelease];
  self.borderView.backgroundColor = [UIColor colorWithRed:1.0f - (aIndex / 10.0f)
                                                    green:0.7f
                                                     blue:0.7f
                                                    alpha:1.0f];
  [self addSubview:self.borderView];
  
  self.textLabel = [[[UILabel alloc] init] autorelease];
  self.textLabel.textAlignment = UITextAlignmentCenter;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.text = [NSString stringWithFormat:@"Page for index %d", aIndex];
  [self.borderView addSubview:self.textLabel];
  
  return self;
}

- (void)layoutSubviews {  
  self.borderView.frame = CGRectMake(10, 10,
                                     self.bounds.size.width - 20,
                                     self.bounds.size.height - 20 );
  self.textLabel.frame = CGRectMake(0, 100,
                                    self.borderView.bounds.size.width,
                                    20);
}

- (void)dealloc {
  self.borderView = nil;
  self.textLabel = nil;
  
  [super dealloc];
}

@end