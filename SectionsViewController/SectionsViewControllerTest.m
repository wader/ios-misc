#import "SectionsViewControllerTest.h"

@implementation SectionsViewControllerTest

- (id)init {
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)labelCellSelect:(id)sender {
  NSLog(@"labelCellSelect");
}

- (void)viewDidLoad {
  [super viewDidLoad]; // setup delegates etc
  
  self.title = @"Sections";
  
  UITableViewCell *switchCell = [[[UITableViewCell alloc]
				  initWithStyle:UITableViewCellStyleDefault
				  reuseIdentifier:@"switchCell"]
				 autorelease];
  switchCell.textLabel.text = @"Switch";
  switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
  switchCell.accessoryView = [[[UISwitch alloc] init] autorelease];
  
  UITableViewCell *labelCell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:@"labelCell"]
				autorelease];
  labelCell.textLabel.text = @"Touch label";
  labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
  
  self.sections = [NSArray arrayWithObjects:
		   [Section sectionWithTitle:@"Section 1"
				       array:
		    [NSArray arrayWithObjects:
		     [SectionRow sectionRowWithCell:switchCell],
		     [SectionRow sectionRowWithCell:labelCell
					     target:self
					   selector:@selector(labelCellSelect:)],
		     nil]
		    ],
		   [Section sectionWithTitle:@"Section 2"
					view:[[[UITextView alloc] init] autorelease]
			      portraitHeight:200
			     landscapeHeight:80],
		   nil
		   ];
}

@end