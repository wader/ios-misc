#import "PagedOrthoScrollView.h"

typedef enum {
  PagedOrthoScrollViewLockDirectionNone,
  PagedOrthoScrollViewLockDirectionVertical,
  PagedOrthoScrollViewLockDirectionHorizontal
} PagedOrthoScrollViewLockDirection; 

@interface PagedOrthoScrollView ()
@property(nonatomic, assign) PagedOrthoScrollViewLockDirection dirLock;
@property(nonatomic, assign) CGFloat valueLock;
@end

@implementation PagedOrthoScrollView
@synthesize dirLock;
@synthesize valueLock;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return self;
  }
  
  self.dirLock = PagedOrthoScrollViewLockDirectionNone;
  self.valueLock = 0;
  
  return self;
}

- (void)setBounds:(CGRect)bounds {
  int mx, my;
  
  if (self.dirLock == PagedOrthoScrollViewLockDirectionNone) {
    // is on even page coordinates, set dir lock and lock value to closest page 
    mx = abs((int)CGRectGetMinX(bounds) % (int)CGRectGetWidth(self.bounds));
    if (mx != 0) {
      self.dirLock = PagedOrthoScrollViewLockDirectionHorizontal;
      self.valueLock = (round(CGRectGetMinY(bounds) / CGRectGetHeight(self.bounds)) *
                        CGRectGetHeight(self.bounds));
    } else {
      self.dirLock = PagedOrthoScrollViewLockDirectionVertical;
      self.valueLock = (round(CGRectGetMinX(bounds) / CGRectGetWidth(self.bounds)) *
                        CGRectGetWidth(self.bounds));
    }
    
    // show only possible scroll indicator
    self.showsVerticalScrollIndicator = dirLock == PagedOrthoScrollViewLockDirectionVertical;
    self.showsHorizontalScrollIndicator = dirLock == PagedOrthoScrollViewLockDirectionHorizontal;
  }
  
  if (self.dirLock == PagedOrthoScrollViewLockDirectionHorizontal) {
    bounds.origin.y = self.valueLock;
  } else {
    bounds.origin.x = self.valueLock;
  }
  
  mx = abs((int)CGRectGetMinX(bounds) % (int)CGRectGetWidth(self.bounds));
  my = abs((int)CGRectGetMinY(bounds) % (int)CGRectGetHeight(self.bounds));
  
  if (mx == 0 && my == 0) {
    // is on even page coordinates, reset lock
    self.dirLock = PagedOrthoScrollViewLockDirectionNone;
  }
  
  [super setBounds:bounds];
}

@end
