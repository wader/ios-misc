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

#import "CoreTextLabel.h"

@implementation CoreTextLabel

@synthesize text;
@synthesize textColor;
@synthesize font;
@synthesize adjustsFontSizeToFitWidth;
@synthesize minimumFontSize;
@synthesize textAlignment;
@synthesize lineBreakMode;
@synthesize firstLineHeadIndent;
@synthesize headIndent;
@synthesize tailIndent;
@synthesize defaultTabInterval;
@synthesize lineHeightMultiple;
@synthesize maximumLineHeight;
@synthesize minimumLineHeight;
@synthesize lineSpacing;
@synthesize baseWritingDirection;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return nil;
  }
  
  self.userInteractionEnabled = NO;
  self.opaque = NO;
  
  self.text = @"";
  self.textColor = [UIColor blackColor];
  self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  self.adjustsFontSizeToFitWidth = NO;
  self.minimumFontSize = 0;
  self.textAlignment = kCTLeftTextAlignment;
  self.lineBreakMode = kCTLineBreakByWordWrapping;
  self.firstLineHeadIndent = 0.0f;
  self.headIndent = 0.0f;
  self.tailIndent = 0.0f;
  self.defaultTabInterval = 0.0f;
  self.lineHeightMultiple = 0.0f;
  self.maximumLineHeight = 0.0f;
  self.minimumLineHeight = 0.0f;
  self.lineSpacing = 0.0f;
  self.baseWritingDirection = 0.0f;
  
  return self;
}

- (void)dealloc {
  self.text = nil;
  self.textColor = nil;
  self.font = nil;
  
  [super dealloc];
}

- (void)drawRect:(CGRect)aRect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  CGContextTranslateCTM(context, 0, self.bounds.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);
  
  CGColorRef backgroundCGColor = (self.backgroundColor != nil ?
                                  self.backgroundColor.CGColor :
                                  [UIColor clearColor].CGColor);
  CGContextSetFillColorSpace(context, CGColorGetColorSpace(backgroundCGColor));
  CGContextSetFillColor(context, CGColorGetComponents(backgroundCGColor));
  CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
  
  CTFontRef ctfont = CTFontCreateWithName((CFStringRef)self.font.fontName,
                                          self.font.pointSize,
                                          NULL);
  CTParagraphStyleSetting paragraphSettings[] = {
    {
      kCTParagraphStyleSpecifierAlignment,
      sizeof(self->textAlignment),
      &self->textAlignment
    },
    {
      kCTParagraphStyleSpecifierLineBreakMode,
      sizeof(self->lineBreakMode),
      &self->lineBreakMode
    },
    {
      kCTParagraphStyleSpecifierFirstLineHeadIndent,
      sizeof(self->firstLineHeadIndent),
      &self->firstLineHeadIndent
    },
    {
      kCTParagraphStyleSpecifierHeadIndent,
      sizeof(self->headIndent),
      &self->headIndent
    },
    {
      kCTParagraphStyleSpecifierTailIndent,
      sizeof(self->tailIndent),
      &self->tailIndent
    },    {
      kCTParagraphStyleSpecifierDefaultTabInterval,
      sizeof(self->defaultTabInterval),
      &self->defaultTabInterval
    },
    {
      kCTParagraphStyleSpecifierLineHeightMultiple,
      sizeof(self->lineHeightMultiple),
      &self->lineHeightMultiple
    },
    {
      kCTParagraphStyleSpecifierMaximumLineHeight,
      sizeof(self->maximumLineHeight),
      &self->maximumLineHeight
    },
    {
      kCTParagraphStyleSpecifierMinimumLineHeight,
      sizeof(self->minimumLineHeight),
      &self->minimumLineHeight
    },
    {
      kCTParagraphStyleSpecifierLineSpacing,
      sizeof(self->lineSpacing),
      &self->lineSpacing
    },
    {
      kCTParagraphStyleSpecifierBaseWritingDirection,
      sizeof(self->baseWritingDirection),
      &self->baseWritingDirection
    }    
  };
  CTParagraphStyleRef paragraphStyle =
  CTParagraphStyleCreate(paragraphSettings,
                         sizeof(paragraphSettings) /
                         sizeof(paragraphSettings[0]));
  NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc]
                                            initWithString:self.text] 
                                           autorelease];
  [attrString
   addAttributes:
   [NSDictionary dictionaryWithObjectsAndKeys:
    (id)self.textColor.CGColor, kCTForegroundColorAttributeName,
    (id)ctfont, kCTFontAttributeName,
    (id)paragraphStyle, kCTParagraphStyleAttributeName,
    nil]
   range:NSMakeRange(0, [self.text length])];
  CFRelease(ctfont);
  CFRelease(paragraphStyle);
  
  if (self.adjustsFontSizeToFitWidth) {
    CGFloat tryDelta = 0.5f;
    NSInteger tryDirection = 0;
    CGFloat tryFontSize = self.font.pointSize;
    
    for (;;) {
      CFRange fitRange;
      tryFontSize += tryDirection * tryDelta;
      
      CTFontRef ctfont = CTFontCreateWithName((CFStringRef)self.font.fontName,
                                              tryFontSize,
                                              NULL);
      [attrString addAttribute:(id)kCTFontAttributeName
                         value:(id)ctfont
                         range:NSMakeRange(0, [self.text length])];
      CFRelease(ctfont);
      
      CTFramesetterRef tryFramesetter =
      CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attrString);
      CTFramesetterSuggestFrameSizeWithConstraints(tryFramesetter,
                                                   CFRangeMake(0, 0),
                                                   NULL,
                                                   self.bounds.size,
                                                   &fitRange);
      CFRelease(tryFramesetter);
      
      if (tryDirection == 0) {
        tryDirection = fitRange.length < [self.text length] ? -1 : 1;
        continue;
      } else if(tryDirection == -1) {
        if (fitRange.length == [self.text length] ||
            tryFontSize <= self.minimumFontSize)
          break;
      } else if(tryDirection == 1) {
        if (fitRange.length < [self.text length]) {
          // go back one delta
          tryFontSize -= tryDelta;
          break;
        }
      }
    }
    
    [self->font release];
    self->font = [[UIFont fontWithName:self.font.fontName
                                  size:tryFontSize]
                  retain];
    CTFontRef ctfont = CTFontCreateWithName((CFStringRef)self.font.fontName,
                                            self.font.pointSize,
                                            NULL);
    [attrString addAttribute:(id)kCTFontAttributeName
                       value:(id)ctfont
                       range:NSMakeRange(0, [self.text length])];
    CFRelease(ctfont);
  }
  
  CTFramesetterRef framesetter =
  CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attrString);
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, self.bounds);
  
  CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                              CFRangeMake(0, 0), path, NULL);
  CFRelease(path);
  CFRelease(framesetter);
  CTFrameDraw(frame, context);
  CFRelease(frame);
}

- (void)sizeToFit {
}

- (void)setText:(NSString *)aText {
  [self->text release];
  self->text = [aText retain];
  [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)aColor {
  [self->textColor release];
  self->textColor = [aColor retain];
  [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)aFont {
  [self->font release];
  self->font = [aFont retain];
  [self setNeedsDisplay];
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)aBool {
  self->adjustsFontSizeToFitWidth = aBool;
  [self setNeedsDisplay];
}

- (void)setMinimumFontSize:(CGFloat)aMinimumFontSize {
  self->minimumFontSize = aMinimumFontSize;
  [self setNeedsDisplay];
}

- (void)setTextAlignment:(CTTextAlignment)aTextAlignment {
  self->textAlignment = aTextAlignment;
  [self setNeedsDisplay];
}

- (void)setLineBreakMode:(CTLineBreakMode)aLineBreakMode {
  self->lineBreakMode = aLineBreakMode;
  [self setNeedsDisplay];
}

- (void)setFirstLineHeadIndent:(CGFloat)aFirstLineHeadIndent {
  self->firstLineHeadIndent = aFirstLineHeadIndent;
  [self setNeedsDisplay];
}

- (void)setHeadIndent:(CGFloat)aHeadIndent {
  self->headIndent = aHeadIndent;
  [self setNeedsDisplay];
}

- (void)setTailIndent:(CGFloat)aTailIndent {
  self->tailIndent = aTailIndent;
  [self setNeedsDisplay];
}

- (void)setDefaultTabInterval:(CGFloat)aDefaultTabInterval {
  self->defaultTabInterval = aDefaultTabInterval;
  [self setNeedsDisplay];
}

- (void)setLineHeightMultiple:(CGFloat)aLineHeightMultiple {
  self->lineHeightMultiple = aLineHeightMultiple;
  [self setNeedsDisplay];
}

- (void)setMaximumLineHeight:(CGFloat)aMaximumLineHeight {
  self->maximumLineHeight = aMaximumLineHeight;
  [self setNeedsDisplay];
}

- (void)setMinimumLineHeight:(CGFloat)aMinimumLineHeight {
  self->minimumLineHeight = aMinimumLineHeight;
  [self setNeedsDisplay];
}

- (void)setLineSpacing:(CGFloat)aLineSpacing {
  self->lineSpacing = aLineSpacing;
  [self setNeedsDisplay];
}

- (void)setBaseWritingDirection:(CTWritingDirection)aBaseWritingDirection {
  self->baseWritingDirection = aBaseWritingDirection;
  [self setNeedsDisplay];
}

@end
