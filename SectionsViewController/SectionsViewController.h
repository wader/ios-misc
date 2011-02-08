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

#import <UIKit/UIKit.h>

@interface Section : NSObject

@property(nonatomic, retain) UIView *view;
@property(nonatomic, retain) NSArray *array;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) CGFloat portraitHeight;
@property(nonatomic, assign) CGFloat landscapeHeight;

+ sectionWithTitle:(NSString *)aTitle
	      view:(UIView *)aView
    portraitHeight:(CGFloat)aPortraitHeight
   landscapeHeight:(CGFloat)aLandscapeHeight;

+ sectionWithTitle:(NSString *)aTitle
	     array:(NSArray *)aArray;

@end

@interface SectionRow : NSObject

@property(nonatomic, retain) UITableViewCell *cell;
@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL selector;

+ sectionRowWithCell:(UITableViewCell *)aCell
	      target:(id)aTarget
	    selector:(SEL)aSelector;

+ sectionRowWithCell:(UITableViewCell *)aCell;

@end

@interface SectionsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSMutableArray *sections;

@end
