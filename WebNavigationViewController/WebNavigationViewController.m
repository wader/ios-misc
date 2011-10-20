/*
 * WebNavigationViewController, webviews using a UINavigationController
 * for navigation.
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

#import "WebNavigationViewController.h"

@interface WebNavigationViewController ()
@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) NSString *file;
@end

@implementation WebNavigationViewController

@synthesize webView;
@synthesize file;

- (id)initWithFile:(NSString *)aFile {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.file = aFile;
  
  return self;
}

- (void)dealloc {
  self.file = nil;
  self.webView = nil;
  
  [super dealloc];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  self.title = [self.webView
                stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(BOOL)webView:(UIWebView *)inWeb
shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)inType {
  if (inType == UIWebViewNavigationTypeLinkClicked) {
    if ([[[request URL] scheme] isEqualToString:@"file"]) {
      // figure out realtive resource file path
      NSString *relativeFile = [[[request URL] path] substringFromIndex:
                                [[[NSURL fileURLWithPath:
                                   [[NSBundle mainBundle] resourcePath]] path]
                                 length]];
      [self.navigationController
       pushViewController:
       [[[WebNavigationViewController alloc] initWithFile:relativeFile]
        autorelease]
       animated:YES];
    } else {
      [[UIApplication sharedApplication] openURL:[request URL]];
    }
    
    return NO;
  }
  
  return YES;
}

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.webView = [[[UIWebView alloc] init] autorelease];
  self.webView.frame = self.view.bounds;
  self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight);
  self.webView.backgroundColor = [UIColor clearColor];
  self.webView.delegate = self;
  /* HACK: remove scroll off fader at top and bottom */
  id scroller = [webView.subviews objectAtIndex:0];
  for (UIView *subView in [scroller subviews])
    if ([[[subView class] description] isEqualToString:@"UIImageView"])
      subView.hidden = YES;
  [self.view addSubview:webView];
  
  NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                        stringByAppendingPathComponent:self.file];
  
  NSString *html = [NSString stringWithContentsOfFile:filePath
                                             encoding:NSUTF8StringEncoding
                                                error:NULL];
  [self.webView loadHTMLString:html
                       baseURL:[NSURL fileURLWithPath:
                                [filePath stringByDeletingLastPathComponent]]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

@end
