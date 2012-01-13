#import "IOSMiscSections.h"
#import "IOSMiscDemoController.h"

#import "GradientLabelTestView.h"
#import "RatingSliderTestView.h"
#import "CoreTextLabelTestView.h"
#import "OptionsTableViewController.h"
#import "PagedScrollViewTestController.h"
#import "PagedOrthoScrollViewTest.h"
#import "WebNavigationViewController.h"

@implementation IOSMiscSections

- (id)init {
  return [super initWithStyle:UITableViewStylePlain];
}

- (void)gradientLabel:(id)sender {
  [self.navigationController
   pushViewController:
   [[[IOSMiscDemoController alloc]
     initWithViewClass:[GradientLabelTestView class]]
    autorelease]
   animated:YES];
}

- (void)ratingSlider:(id)sender {
  [self.navigationController
   pushViewController:
   [[[IOSMiscDemoController alloc]
     initWithViewClass:[RatingSliderTestView class]]
    autorelease]
   animated:YES];
}

- (void)coreTextLabel:(id)sender {
  [self.navigationController
   pushViewController:
   [[[IOSMiscDemoController alloc]
     initWithViewClass:[CoreTextLabelTestView class]]
    autorelease]
   animated:YES];
}

- (void)pagedScrollViewController:(id)sender {
  [self.navigationController
   pushViewController:
   [[[PagedScrollViewTestController alloc] init]
    autorelease]
   animated:YES];
}

- (void)webNavigationViewController:(id)sender {
  [self.navigationController
   pushViewController:
   [[[WebNavigationViewController alloc] initWithFile:@"test1.html"]
    autorelease]
   animated:YES];
}

- (void)pagedOrthoScrollView:(id)sender {
  [self.navigationController
   pushViewController:
   [[[IOSMiscDemoController alloc]
     initWithViewClass:[PagedOrthoScrollViewTest class]]
    autorelease]
   animated:YES];
}

- (void)optionsTableViewControllerDone:(id)key {
  NSLog(@"%@", key);
}

- (void)optionsTableViewController:(id)sender {
  UINavigationController *modalController;
  modalController = [[[UINavigationController alloc]
                      initWithRootViewController:
                      [OptionsTableViewController
                       optionsTableWithTitle:@"Options"
                       options:[NSMutableDictionary
                                dictionaryWithObjectsAndKeys:
                                @"First", [NSNumber numberWithInt:1],
                                @"Second", [NSNumber numberWithInt:2],
                                @"Third", [NSNumber numberWithInt:3],
                                nil]
                       selectedKey:[NSNumber numberWithInt:2]
                       target:self
                       selector:@selector(optionsTableViewControllerDone:)]]
                     autorelease];
  modalController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentModalViewController:modalController
                          animated:YES];
}

- (SectionRow *)makeSectionRowWithTitle:(NSString *)aTitle
                               selector:(SEL)aSelector {
  UITableViewCell *labelCell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:aTitle]
				autorelease];
  labelCell.textLabel.text = aTitle;
  labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
  return [SectionRow sectionRowWithCell:labelCell
                                 target:self
                               selector:aSelector];
}

- (void)viewDidLoad {
  [super viewDidLoad]; // setup delegates etc
  
  self.title = @"IOSMisc";
  
  self.sections = [NSArray arrayWithObjects:
		   [Section sectionWithTitle:nil
				       array:
		    [NSArray arrayWithObjects:
		     [self makeSectionRowWithTitle:@"GradientLabel"
                                          selector:@selector(gradientLabel:)],
                     [self makeSectionRowWithTitle:@"RatingSlider"
                                          selector:@selector(ratingSlider:)],
                     [self makeSectionRowWithTitle:@"CoreTextLabel"
                                          selector:@selector(coreTextLabel:)],		    
                     [self makeSectionRowWithTitle:@"OptionsTableViewController"
                                          selector:@selector(optionsTableViewController:)],	
                     [self makeSectionRowWithTitle:@"PagedScrollViewController"
                                          selector:@selector(pagedScrollViewController:)],
                     [self makeSectionRowWithTitle:@"WebNavigationViewController"
                                          selector:@selector(webNavigationViewController:)],    
                     [self makeSectionRowWithTitle:@"PagedOrthoScrollView"
                                          selector:@selector(pagedOrthoScrollView:)], 
                     nil]
		    ],
		   nil
		   ];
}

@end