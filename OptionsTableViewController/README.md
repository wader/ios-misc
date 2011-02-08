OptionsTableViewController
==========================

View controller used for modal option selection. Should be wrapped inside a
UINavigationController that provides title bar and buttons.

Example usage
-------------
        #import "OptionsTableViewController.h"

        - (void)touchOptionsChange:(id)key {
          NSLog(@"%@", key);
        }

        - (void)touchOptions:(id)sender {
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
                               selector:@selector(touchOptionsChange:)]]
                             autorelease];
          modalController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
          [self presentModalViewController:modalController
                                  animated:YES];
          
        }

Modal view will look like this:

![OptionsTableViewController example image](/wader/ios-misc/raw/master/OptionsTableViewController/OptionsTableViewControllerExample.png)
