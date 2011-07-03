#import "CoreTextLabelTestView.h"
#import "CoreTextLabel.h"

@implementation CoreTextLabelTestView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self == nil) {
    return nil;
  }
  
  NSString *saganQuote =
  @"The Earth is a very small stage in a vast cosmic arena. "
  @"Think of the rivers of blood spilled by all those generals "
  @"and emperors so that, in glory and triumph, they could become "
  @"the momentary masters of a fraction of a dot.";
  
  CoreTextLabel *label1 = [[[CoreTextLabel alloc]
                            initWithFrame:CGRectMake(20, 40, 120, 180)]
                           autorelease];
  label1.text = saganQuote;
  label1.textAlignment = kCTJustifiedTextAlignment;
  label1.adjustsFontSizeToFitWidth = YES;
  label1.font = [UIFont fontWithName:@"TrebuchetMS" size:10];
  [self addSubview:label1];
  
  CoreTextLabel *label2 = [[[CoreTextLabel alloc]
                            initWithFrame:CGRectMake(180, 40, 120, 180)]
                           autorelease];
  label2.text = saganQuote;
  label2.textAlignment = kCTRightTextAlignment;
  label2.adjustsFontSizeToFitWidth = YES;
  label2.font = [UIFont fontWithName:@"TrebuchetMS" size:10];
  [self addSubview:label2];
  
  CoreTextLabel *label3 = [[[CoreTextLabel alloc]
                            initWithFrame:CGRectMake(20, 240, 280, 140)]
                           autorelease];
  label3.text = saganQuote;
  label3.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:15];
  label3.textColor = [UIColor lightGrayColor];
  label3.backgroundColor = [UIColor blueColor];
  label3.lineBreakMode = kCTLineBreakByCharWrapping;
  label3.firstLineHeadIndent = 30;
  label3.tailIndent = 260;
  label3.lineHeightMultiple = 1.1f;
  label3.lineSpacing = 2;
  [self addSubview:label3];
  
  return self;
}

@end
