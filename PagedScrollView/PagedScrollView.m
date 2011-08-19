/*
 * PagedScrollView, paged scroll view using a delegate to manage page views
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

#import "PagedScrollView.h"

@interface PagedScrollViewPage : NSObject
+ (PagedScrollViewPage *)pagedScrollViewPageWithIndex:(NSUInteger)aIndex
                                                 view:(UIView *)aView;
- (PagedScrollViewPage *)initWithIndex:(NSUInteger)aIndex
                                  view:(UIView *)aView;

@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, retain) UIView *view;
@end

@implementation PagedScrollViewPage
@synthesize index;
@synthesize view;

+ (PagedScrollViewPage *)pagedScrollViewPageWithIndex:(NSUInteger)aIndex
                                                 view:(UIView *)aView {
  return [[[PagedScrollViewPage alloc] initWithIndex:aIndex view:aView]
          autorelease];
}

- (PagedScrollViewPage *)initWithIndex:(NSUInteger)aIndex
                                  view:(UIView *)aView {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.index = aIndex;
  self.view = aView;
  
  return self;
}

- (void)dealloc {
  self.view = nil;
  
  [super dealloc];
}


@end

@interface PagedScrollView ()
@property(nonatomic, assign) NSUInteger numberOfPages;
@property(nonatomic, retain) NSMutableSet *pages;
@end

@implementation PagedScrollView

@synthesize pageDelegate;

@synthesize numberOfPages;
@synthesize pages;


- (id)initWithFrame:(CGRect)aRect {
  self = [super initWithFrame:aRect];
  if (self == nil) {
    return nil;
  }
  
  self.pages = [NSMutableSet set];
  
  self.delegate = self;
  self.pagingEnabled = YES;
  self.clipsToBounds = NO;
  self.scrollEnabled = YES;
  
  return self;
}

- (void)dealloc {
  [self removePages];
  self.pages = nil;
  
  [super dealloc];
}

- (void)removePages {
  for (PagedScrollViewPage *page in self.pages) {
    [page.view removeFromSuperview];
  }
  [self.pages removeAllObjects];
}

- (void)loadPages {
  self.numberOfPages = [self.pageDelegate pagedScrollViewNumberOfPages:self];
  self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * self.numberOfPages,
                                CGRectGetHeight(self.bounds));
  [self managePages];
}

- (PagedScrollViewPage *)findPage:(NSUInteger)index {
  for (PagedScrollViewPage *page in self.pages) {
    if (page.index == index) {
      return page;
    }
  }
  
  return nil;
}

- (BOOL)pageExists:(NSUInteger)index {
  return [self findPage:index] != nil;
}

- (NSUInteger)currentPage {
  return MAX((NSUInteger)(CGRectGetMinX(self.bounds) +
                          (CGRectGetWidth(self.bounds) / 2)) /
             (NSUInteger)CGRectGetWidth(self.bounds), 0);
}

- (void)gotoPage:(NSUInteger)index animated:(BOOL)animated {
  [self setContentOffset:CGPointMake(self.bounds.size.width * index, 0)
                animated:animated];
}

- (UIView *)viewForPage:(NSUInteger)index {
  PagedScrollViewPage *page = [self findPage:index];
  return page == nil ? nil : page.view;
}

- (void)managePages {
  NSInteger currentPage = ((NSInteger)CGRectGetMinX(self.bounds) /
                           (NSInteger)CGRectGetWidth(self.bounds));
  NSUInteger firstPage = MAX(currentPage - 1, 0);
  NSUInteger lastPage = MIN(currentPage + 1, self.numberOfPages - 1);
  
  NSMutableSet *invisiblePages = [NSMutableSet set];
  // remove invisible pages that are not close by
  for (PagedScrollViewPage *page in self.pages) {
    if (CGRectIntersectsRect(self.bounds, page.view.frame) ||
        (page.index >= firstPage && page.index <= lastPage)) {
      continue;
    }
    
    [invisiblePages addObject:page];
    [page.view removeFromSuperview];
  }
  [pages minusSet:invisiblePages];
  
  for (NSUInteger i = firstPage; i <= lastPage; i++) {
    if ([self pageExists:i]) {
      continue;
    }
    
    PagedScrollViewPage *page = [PagedScrollViewPage
                                 pagedScrollViewPageWithIndex:i
                                 view:
                                 [self.pageDelegate
                                  pagedScrollView:self
                                  viewForPage:i
                                  frame:CGRectMake(CGRectGetWidth(self.bounds) * i,
                                                   0,
                                                   CGRectGetWidth(self.bounds),
                                                   CGRectGetHeight(self.bounds))]];
    [self.pages addObject:page];
    // make sure to add from bottom, addSubview seams to somtimes add view
    // on top of scroll indicator
    [self insertSubview:page.view atIndex:0];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self managePages];
}

- (void)layoutSubviews {
  self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * self.numberOfPages,
                                CGRectGetHeight(self.bounds));
  
  for (PagedScrollViewPage *page in self.pages) {
    CGRect newFrame = CGRectMake(CGRectGetWidth(self.bounds) * page.index,
                                 0,
                                 CGRectGetWidth(self.bounds),
                                 CGRectGetHeight(self.bounds));
    // don't touch if not changed
    if (CGRectEqualToRect(page.view.frame, newFrame)) {
      continue;
    }
    
    page.view.frame = newFrame;
  }
}

@end
