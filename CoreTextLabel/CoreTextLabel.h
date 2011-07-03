/*
 * CoreTextLabel, CoreText UIView wrapper similar to UILabel
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
#import <CoreText/CoreText.h>

@interface CoreTextLabel : UIView
@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) UIColor *textColor;
@property(nonatomic, retain) UIFont *font;
@property(nonatomic, assign) BOOL adjustsFontSizeToFitWidth;
@property(nonatomic, assign) CGFloat minimumFontSize;
@property(nonatomic, assign) CTTextAlignment textAlignment;
@property(nonatomic, assign) CTLineBreakMode lineBreakMode;
@property(nonatomic, assign) CGFloat firstLineHeadIndent;
@property(nonatomic, assign) CGFloat headIndent;
@property(nonatomic, assign) CGFloat tailIndent;
@property(nonatomic, assign) CGFloat defaultTabInterval;
@property(nonatomic, assign) CGFloat lineHeightMultiple;
@property(nonatomic, assign) CGFloat maximumLineHeight;
@property(nonatomic, assign) CGFloat minimumLineHeight;
@property(nonatomic, assign) CGFloat lineSpacing;
@property(nonatomic, assign) CTWritingDirection baseWritingDirection;
@end
