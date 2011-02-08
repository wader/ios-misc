/*
 * SectionsViewController.h, simplified UITableViewController interface
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

#import <QuartzCore/QuartzCore.h>
#import "SectionsViewController.h"

@interface NSIndexPath (stringPath)
- (NSString *)stringPath;
@end

@implementation NSIndexPath (stringPath)
- (NSString *)stringPath {
  NSMutableString *path = [NSMutableString stringWithCapacity:0];
  
  for (int i = 0; i < [self length]; i++) {
    [path appendFormat:@"%u%@",
     [self indexAtPosition:i],
     i < [self length] - 1 ? @"." : @""];
  }
  
  return path;
}
@end

@implementation Section

@synthesize view;
@synthesize array;
@synthesize title;
@synthesize portraitHeight;
@synthesize landscapeHeight;

+ sectionWithTitle:(NSString *)aTitle
	      view:(UIView *)aView
    portraitHeight:(CGFloat)aPortraitHeight
   landscapeHeight:(CGFloat)aLandscapeHeight {
  Section *section = [[[Section alloc] init] autorelease];
  section.view = aView;
  section.title = aTitle;
  section.portraitHeight = aPortraitHeight;
  section.landscapeHeight = aLandscapeHeight;
  
  return section;
}

+ sectionWithTitle:(NSString *)aTitle
	     array:(NSArray *)aArray {
  Section *section = [[[Section alloc] init] autorelease];
  section.array = aArray;
  section.title = aTitle;
  
  return section;
}

- (void)dealloc {
  self.view = nil;
  self.title = nil;
  [super dealloc];
}

@end


@implementation SectionRow

@synthesize cell;
@synthesize target;
@synthesize selector;

+ sectionRowWithCell:(UITableViewCell *)aCell
	      target:(id)aTarget
	    selector:(SEL)aSelector {
  SectionRow *sectionRow = [[[SectionRow alloc] init] autorelease];
  sectionRow.cell = aCell;
  sectionRow.target = aTarget;
  sectionRow.selector = aSelector;
  
  return sectionRow;
}

+ sectionRowWithCell:(UITableViewCell *)aCell {
  SectionRow *sectionRow = [[[SectionRow alloc] init] autorelease];
  sectionRow.cell = aCell;
  
  return sectionRow;
}

@end


@implementation SectionsViewController

@synthesize sections;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Section *section = [self.sections objectAtIndex:[indexPath section]];
  
  if (section.array != nil) {
    return self.tableView.rowHeight;
  }
  
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
    return section.portraitHeight;
  } else {
    return section.landscapeHeight;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
  Section *section = [self.sections objectAtIndex:sectionIndex];
  
  if (section.view != nil) {
    return 1;
  }
  
  return [section.array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return ((Section *)[self.sections objectAtIndex:section]).title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *id_ = [indexPath stringPath];
  UITableViewCell *viewCell = [self.tableView dequeueReusableCellWithIdentifier:id_];
  if (viewCell != nil) {
    return viewCell;
  }
  
  Section *section = [self.sections objectAtIndex:[indexPath section]];
  
  if (section.view != nil) {
    viewCell = [[[UITableViewCell alloc]
		 initWithStyle:UITableViewCellStyleDefault
		 reuseIdentifier:id_]
		autorelease];
    CGFloat height;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
      height = section.portraitHeight;
    } else {
      height = section.landscapeHeight;
    }
    
    viewCell.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    section.view.layer.cornerRadius = 9;
    section.view.frame = viewCell.contentView.frame;
    section.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
				     UIViewAutoresizingFlexibleHeight);
    [viewCell.contentView addSubview:section.view];
    
    return viewCell;
  } else {
    SectionRow *sectionRow = [section.array objectAtIndex:[indexPath row]];
    return sectionRow.cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Section *section = [self.sections objectAtIndex:[indexPath section]];
  if (section.view != nil) {
    return;
  }
  
  SectionRow *sectionRow = [section.array objectAtIndex:[indexPath row]];
  if (sectionRow.target == nil) {
    return;
  }
  
  [sectionRow.target performSelector:sectionRow.selector];
}

- (void)viewDidLoad {
  self.tableView.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)dealloc {
  self.sections = nil;
  
  [super dealloc];
}

@end
