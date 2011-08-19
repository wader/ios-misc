WebNavigationViewController 
===========================

UIViewController displaying web pages. Local pages pushes a new
WebNavigationViewController non-local opens in Mobile safari.

Example usage
-------------
  
        [self.navigationController
         [[[WebNavigationViewController alloc] initWithFile:@"test1.html"]
          autorelease]
         animated:YES];

Looks like:

![WebNavigationViewController example image](/wader/ios-misc/raw/master/WebNavigationViewController/WebNavigationViewControllerExample.png)
