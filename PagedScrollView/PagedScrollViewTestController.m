#import "PagedScrollViewTestController.h"
#import "PagedScrollViewTestView.h"

@implementation PagedScrollViewTestController

- (void)viewDidLoad {
  self.title = @"PagedScrollViewTestController";
  self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (NSUInteger)pagedScrollViewNumberOfPages:(PagedScrollView *)pagedScrollView {
  return 5;
}

- (UIView *)pagedScrollView:(PagedScrollView *)pagedScrollView
                viewForPage:(NSUInteger)index
                      frame:(CGRect)aRect {
  return [[[PagedScrollViewTestView alloc]
           initWithFrame:aRect index:index]
          autorelease];
}

@end
