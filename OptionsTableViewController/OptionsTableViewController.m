/*
 * OptionsTableViewController.h, view controller for modal table of options
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

#import "OptionsTableViewController.h"

@interface OptionsTableViewController ()

@property(nonatomic, retain) NSMutableArray *keys;
@property(nonatomic, retain) NSArray *values;

@end

@implementation OptionsTableViewController

@synthesize options;
@synthesize selectedKey;
@synthesize sortDescriptors;
@synthesize target;
@synthesize selector;

@synthesize keys;
@synthesize values;

- (OptionsTableViewController *)initWithTitle:(NSString *)aTitle
					style:(UITableViewStyle)aStyle
				      options:(NSDictionary *)aOptions
				  selectedKey:(id)aSelectedKey
			      sortDescriptors:(NSArray *)aSortDescriptors
				       target:(id)aTarget
				     selector:(SEL)aSelector {
  self = [super initWithStyle:aStyle];
  if (self == nil) {
    return nil;
  }
  
  self.title = aTitle;
  self.options = aOptions;
  self.selectedKey = aSelectedKey;
  self.sortDescriptors = aSortDescriptors;
  self.target = aTarget;
  self.selector = aSelector;
  
  NSArray *origKeys = [self.options allKeys];
  NSArray *origValues = [self.options allValues];
  
  self.values = [origValues sortedArrayUsingDescriptors:self.sortDescriptors];
  self.keys = [NSMutableArray array];
  
  for (id value in self.values) {
    [self.keys addObject:
     [origKeys objectAtIndex:[origValues indexOfObjectIdenticalTo:value]]];
  }
  
  return self;
}

+ (OptionsTableViewController *)optionsTableWithTitle:(NSString *)aTitle
						style:(UITableViewStyle)aStyle
					      options:(NSDictionary *)aOptions
					  selectedKey:(id)aSelectedKey
				      sortDescriptors:(NSArray *)aSortDescriptors
					       target:(id)aTarget
					     selector:(SEL)aSelector {
  return [[[OptionsTableViewController alloc]
	   initWithTitle:aTitle
	   style:aStyle
	   options:aOptions
	   selectedKey:aSelectedKey
	   sortDescriptors:aSortDescriptors
	   target:aTarget
	   selector:aSelector]
	  autorelease];
}

+ (OptionsTableViewController *)optionsTableWithTitle:(NSString *)aTitle
					      options:(NSDictionary *)aOptions
					  selectedKey:(NSString *)aSelectedKey
					       target:(id)aTarget
					     selector:(SEL)aSelector {
  return [[[OptionsTableViewController alloc]
	   initWithTitle:aTitle
	   style:UITableViewStyleGrouped
	   options:aOptions
	   selectedKey:aSelectedKey
	   sortDescriptors:[NSArray arrayWithObject:
			    [[[NSSortDescriptor alloc]
			      initWithKey:@"self"
			      ascending:YES]
			     autorelease]]
	   target:aTarget
	   selector:aSelector]
	  autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [self.keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
	 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[[UITableViewCell alloc] init] autorelease];
  cell.textLabel.text = [[self.values
			  objectAtIndex:[indexPath row]]
			 description];
  
  NSString *key = [self.keys objectAtIndex:[indexPath row]];
  if ([key isEqual:self.selectedKey]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  self.selectedKey = [self.keys objectAtIndex:[indexPath row]];
  [tableView reloadData];
}

- (void)touchDone:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
  [self.target performSelector:self.selector withObject:self.selectedKey];
}

- (void)touchCancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
					    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
					    target:self
					    action:@selector(touchCancel:)]
					   autorelease];
  
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
					     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
					     target:self
					     action:@selector(touchDone:)]
					    autorelease];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)dealloc {
  self.options = nil;
  self.selectedKey = nil;
  self.sortDescriptors = nil;
  self.target = nil;
  self.selector = nil;
  self.keys = nil;
  self.values = nil;
  
  [super dealloc];
}

@end
