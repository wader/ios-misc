/*
 * GradientLabel, UILabel with gradient support
 *
 * Does not work well with multi line text as the gradient is done on the
 * whole height of the label.
 *
 * Copyright (c) 2010 <mattias.wadman@gmail.com>
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

#import "GradientLabel.h"

@interface GradientLabel ()

@property(nonatomic, assign) CGFloat *gradientColorsArray;
@property(nonatomic, assign) CGFloat *gradientLocationsArray;

@end

@implementation GradientLabel

@synthesize gradientColors;
@synthesize gradientLocations;
@synthesize gradientColorsArray;
@synthesize gradientLocationsArray;

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self->gradientColorsArray = NULL;
  self.gradientColors = [NSArray arrayWithObjects:
			 [UIColor colorWithWhite:1.0f alpha:1.0f],
			 [UIColor colorWithWhite:0.5f alpha:1.0f],
			 nil];
  self->gradientLocationsArray = NULL;
  self.gradientLocations = [NSArray arrayWithObjects:
			    [NSNumber numberWithFloat:0.0f],
			    [NSNumber numberWithFloat:1.0f],
			    nil];
  
  return self;
}

- (void)dealloc {
  free(self.gradientColorsArray);
  [self->gradientColors release];
  free(self.gradientLocationsArray);
  [self->gradientLocations release];
  
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  if ([self.gradientColors count] != [self.gradientLocations count]) {
    [NSException
     raise:NSInternalInconsistencyException
     format:@"gradientColors count %d != gradientLocation count %d",
     [self.gradientColors count],
     [self.gradientLocations count]];
  }
  
  CGRect dstRect;
  
  if (UIGraphicsBeginImageContextWithOptions != NULL) {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
  } else {
    UIGraphicsBeginImageContext(self.bounds.size);
  }
  // render black text with no shadow so it can be used as a mask
  UIColor *backupTextColor = self.textColor;
  UIColor *backupShadowColor = self.shadowColor;
  self.textColor = [UIColor blackColor];
  self.shadowColor = nil;
  [super drawRect:rect];
  self.textColor = backupTextColor;
  self.shadowColor = backupShadowColor;
  UIImage *textUIImage = UIGraphicsGetImageFromCurrentImageContext();
  CGImageRef textImage = textUIImage.CGImage;
  if (UIGraphicsBeginImageContextWithOptions != NULL) {
    dstRect = CGRectMake(0, 0,
			 CGImageGetWidth(textImage) / textUIImage.scale,
			 CGImageGetHeight(textImage) / textUIImage.scale);
  } else {
    dstRect = CGRectMake(0, 0,
			 CGImageGetWidth(textImage),
			 CGImageGetHeight(textImage));
  }
  UIGraphicsEndImageContext();
  
  if (UIGraphicsBeginImageContextWithOptions != NULL)
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
  else
    UIGraphicsBeginImageContext(self.bounds.size);
  [[UIColor whiteColor] setFill];
  CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, dstRect.size.height);
  CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
  CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), dstRect, textImage);
  CGImageRef textMaskImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
  UIGraphicsEndImageContext();
  
  CGImageRef textMask = CGImageMaskCreate(CGImageGetWidth(textMaskImage),
					  CGImageGetHeight(textMaskImage),
					  CGImageGetBitsPerComponent(textMaskImage),
					  CGImageGetBitsPerPixel(textMaskImage),
					  CGImageGetBytesPerRow(textMaskImage),
					  CGImageGetDataProvider(textMaskImage),
					  NULL,
					  NO);
  
  if (UIGraphicsBeginImageContextWithOptions != NULL)
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
  else
    UIGraphicsBeginImageContext(self.bounds.size);
  
  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace,
							       self->gradientColorsArray,
							       self->gradientLocationsArray,
							       [self.gradientColors count]);
  CGColorSpaceRelease(colorspace);
  CGRect currentBounds = self.bounds;
  CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds),
				  0.0f);
  CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds),
				  CGRectGetMaxY(currentBounds));
  CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(),
			      gradient,
			      topCenter,
			      midCenter,
			      0);
  CGGradientRelease(gradient);
  CGImageRef gradientFillImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
  UIGraphicsEndImageContext();
  
  
  CGImageRef gradientTextImage = CGImageCreateWithMask(gradientFillImage, textMask);
  
  CGImageRef shadowTextImage = NULL;
  if (self.shadowColor != nil) {
    if (UIGraphicsBeginImageContextWithOptions != NULL)
      UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    else
      UIGraphicsBeginImageContext(self.bounds.size);
    [self.shadowColor setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    CGImageRef shadowFillImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    shadowTextImage = CGImageCreateWithMask(shadowFillImage, textMask);
  }
  
  CGImageRelease(textMask);
  
  CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, dstRect.size.height);
  CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
  
  if (shadowTextImage != NULL) {
    CGContextDrawImage(UIGraphicsGetCurrentContext(),
		       CGRectMake(self.shadowOffset.width,
				  -self.shadowOffset.height,
				  dstRect.size.width,
				  dstRect.size.height),
		       shadowTextImage
		       );
    CGImageRelease(shadowTextImage);
  }
  
  CGContextDrawImage(UIGraphicsGetCurrentContext(),
                     CGRectMake(0, 0,
				dstRect.size.width,
                                dstRect.size.height),
		     gradientTextImage
                     );
  CGImageRelease(gradientTextImage);
}

- (void)setGradientColors:(NSArray *)colors {
  [self->gradientColors release];
  self->gradientColors = [colors retain];
  
  self->gradientColorsArray = realloc(self->gradientColorsArray,
				      sizeof(*self->gradientColorsArray) * 4 *
				      [colors count]);
  int i = 0;
  for (UIColor *uc in colors) {
    const CGFloat *components = CGColorGetComponents(uc.CGColor);
    size_t nrcomponents = CGColorGetNumberOfComponents(uc.CGColor);
    if (nrcomponents == 2) {
      self->gradientColorsArray[i+0] = components[0]; // r
      self->gradientColorsArray[i+1] = components[0]; // g
      self->gradientColorsArray[i+2] = components[0]; // b
      self->gradientColorsArray[i+3] = components[1]; // a
    } else if (nrcomponents == 4) {
      self->gradientColorsArray[i+0] = components[0];
      self->gradientColorsArray[i+1] = components[1];
      self->gradientColorsArray[i+2] = components[2];
      self->gradientColorsArray[i+3] = components[3];
    }
    
    i += 4;
  }
  
  [self setNeedsDisplay];
}

- (NSArray *)gradientColors {
  return [[self->gradientColors retain] autorelease];
}

- (void)setGradientLocations:(NSArray *)locations {
  [self->gradientLocations release];
  self->gradientLocations = [locations retain];
  
  self->gradientLocationsArray = realloc(self->gradientLocationsArray,
					 sizeof(*self->gradientLocationsArray) *
					 [locations count]);
  int i = 0;
  for (NSNumber *n in locations) {
    self->gradientLocationsArray[i++] = [n floatValue];
  }
  
  
  [self setNeedsDisplay];
}

- (NSArray *)gradientLocations {
  return [[self->gradientLocations retain] autorelease];
}

@end
