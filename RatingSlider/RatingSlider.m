/*
 * RatingSlider, rating like slider interface controller
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

#import "RatingSlider.h"

@interface RatingSlider ()

@property(nonatomic, retain) NSMutableArray *imageViews;

@end


@implementation RatingSlider

@synthesize value;
@synthesize min;
@synthesize max;
@synthesize stars;
@synthesize integerValue;
@synthesize emptyImage;
@synthesize halfImage;
@synthesize fullImage;
@synthesize imageViews;

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.imageViews = [NSMutableArray array];
  
  return self;
}

- (void)dealloc {
  for (UIImageView *image in self.imageViews) {
    [image removeFromSuperview];
  }
  self.imageViews = nil;
  [self.emptyImage release];
  [self.halfImage release];
  [self.fullImage release];
  
  [super dealloc];
}

- (void)update {
  if (self->emptyImage == nil || self->halfImage == nil ||
      self->fullImage == nil || self->stars == 0) {
    return;
  }

  CGRect f = CGRectMake(0, 0,
                        self->emptyImage.size.width, 
                        self->emptyImage.size.height);
  float delta = self->max - self->min;
  float step = delta / self->stars;
  float v = self->min;
  for (UIImageView *image in self.imageViews) {
    float d = self.value - v;
    image.frame = f;

    if (d < step / 4) {
      image.image = self->emptyImage;
    } else if (d >= step / 4 && d <= (step / 4) * 3) {
      image.image = self->halfImage;
    } else {
      image.image = self->fullImage;
    }
    
    v += step;
    f.origin.x += f.size.width;
  }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  if (self.emptyImage == nil || self.emptyImage.size.width == 0 ||
      self->stars == 0) {
    return NO;
  }
  
  CGPoint p = [touch locationInView:self];
  
  self->value = (self->min +
                 (self->max - self->min) * 
                 (p.x / (self.emptyImage.size.width * self->stars)));
  if (self->value < self->min) {
    self->value = self->min;
  } else if (self->value > self->max) {
    self->value = self->max;
  }
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  [self update];
  
  return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  return [self beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
}

- (void)setMin:(float)aMin {
  self->min = aMin;
  
  if (self->value < aMin) {
    self->value = aMin;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
  
  if (aMin > self->max) {
    self->max = aMin;
  }
  
  [self update];
}

- (void)setMax:(float)aMax {
  self->max = aMax;
  
  if (self->value > aMax) {
    self->value = aMax;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
  
  if (aMax < self->min) {
    self->min = aMax;
  }
  
  [self update];
}

- (void)setValue:(float)aValue {
  if (aValue > self->max) {
    aValue = self->max;
  } else if (aValue < self.min) {
    aValue = self->min;
  }
  
  if (aValue == self->value) {
    return;
  }
  
  self->value = aValue;
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  [self update];
}

- (float)value {
  if (self->integerValue) {
    return ceil(self->value);
  } else {
    return self->value;
  }
}

- (void)setStars:(NSUInteger)aStars {
  if (self->stars == aStars) {
    return;
  }
  
  self->stars = aStars;
  
  for (UIImageView *image in self.imageViews) {
    [image removeFromSuperview];
  }
  [self.imageViews removeAllObjects];
  
  for (int i = 0; i < aStars; i++) {
    UIImageView *image = [[[UIImageView alloc] init] autorelease];
    [self addSubview:image];
    [self.imageViews addObject:image];
  }
  
  [self update];
}

- (void)setIntegerValue:(BOOL)isIntegerValue {
  self->integerValue = isIntegerValue;
  [self update];
}

- (void)setEmptyImage:(UIImage *)aImage {
  [self->emptyImage release];
  self->emptyImage = [aImage retain];
  [self update];
}

- (UIImage *)emptyImage {
  return [[self->emptyImage retain] autorelease];
}

- (void)setHalfImage:(UIImage *)aImage {
  [self->halfImage release];
  self->halfImage = [aImage retain];
  [self update];
}

- (UIImage *)halfImage {
  return [[self->halfImage retain] autorelease];
}

- (void)setFullImage:(UIImage *)aImage {
  [self->fullImage release];
  self->fullImage = [aImage retain];
  [self update];
}

- (UIImage *)fullImage {
  return [[self->fullImage retain] autorelease];
}

@end
