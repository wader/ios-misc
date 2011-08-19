/*
 * NSString+colorValue, NSString category creating UIColor from "#rrggbb(aa)"
 * string
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

#import "NSString+colorValue.h"

#import "UIColor+hexString.h"

@implementation NSString (colorValue)

- (NSUInteger)colorValueIntegerFromHexString {
  NSUInteger n;
  return [[NSScanner scannerWithString:self] scanHexInt:&n] ? n : 0;
}

- (UIColor *)colorValue {
  static NSRegularExpression *re = nil;
  if (re == nil) {
    re = [[NSRegularExpression
           regularExpressionWithPattern:
           @"^"
           @"#?" // ignore optional starting #
           @"(?:" // alternate group and dont capture
            @"([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})?" // #rrggbb(aa), group 1-4
            @"|" // or
            @"([0-9a-f])([0-9a-f])([0-9a-f])([0-9a-f])?" // #rgb(a), group 5-8
           @")$"
           options:NSRegularExpressionCaseInsensitive
           error:NULL]
          retain];
  }
  
  NSArray *matches = [re matchesInString:self
                                 options:0
                                   range:NSMakeRange(0, [self length])];
  if ([matches count] == 0) {
    return nil;
  }
  NSTextCheckingResult *match = [matches objectAtIndex:0];
  // what capture groups to use
  NSUInteger offset = [match rangeAtIndex:1].location == NSNotFound ? 5 : 1;
  NSUInteger r = [[self substringWithRange:[match rangeAtIndex:offset]]
                  colorValueIntegerFromHexString];
  NSUInteger g = [[self substringWithRange:[match rangeAtIndex:offset+1]]
                  colorValueIntegerFromHexString];
  NSUInteger b = [[self substringWithRange:[match rangeAtIndex:offset+2]]
                  colorValueIntegerFromHexString];
  NSUInteger a = ([match rangeAtIndex:offset+3].location == NSNotFound ? 255 :
                  [[self substringWithRange:[match rangeAtIndex:offset+3]]
                   colorValueIntegerFromHexString]);
  // f -> ff
  if (offset == 5) {
    r = (r << 4) | r;
    g = (g << 4) | g;
    b = (b << 4) | b;
    a = ((a << 4) | a) & 0xff; // a set to 255 above
  }
  
  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f
                         alpha:a / 255.0f];
}

- (UIColor *)colorValueWithFallback:(UIColor *)fallbackColor {
  return [self colorValue] ? : fallbackColor;
}

@end
