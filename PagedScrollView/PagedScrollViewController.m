/*
 * PagedScrollViewController, controller managing a PagedScrollView
 *
 * Copyright (c) 2011 <mattias.wadman@gmail.com>
 *
 * MIT License:
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "PagedScrollViewController.h"

@interface PagedScrollViewController ()
@property(nonatomic, assign) NSUInteger currentPage;
@end

@implementation PagedScrollViewController

@synthesize pagedScrollView;

@synthesize currentPage;

- (void)dealloc {
  self.pagedScrollView = nil;
  
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.pagedScrollView loadPages];
  
  [super viewDidAppear:animated];
}

- (void)loadView {
  if (self.pagedScrollView == nil) {
    self.pagedScrollView = [[[PagedScrollView alloc]
                             initWithFrame:[UIScreen mainScreen].bounds]
                            autorelease];
    self.pagedScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                             UIViewAutoresizingFlexibleHeight);
    self.pagedScrollView.pageDelegate = self;
  }
  
  self.view = self.pagedScrollView;
}

- (void)viewDidUnload {
  [self.pagedScrollView removePages];
  [super viewDidUnload];
}

- (NSUInteger)pagedScrollViewNumberOfPages:(PagedScrollView *)pagedScrollView {
  return 0;
}

- (UIView *)pagedScrollView:(PagedScrollView *)pagedScrollView
                viewForPage:(NSUInteger)index
                      frame:(CGRect)aRect {
  return nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
  self.currentPage = [self.pagedScrollView currentPage];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
  [self.pagedScrollView gotoPage:self.currentPage animated:NO];
}

@end
