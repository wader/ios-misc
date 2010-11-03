#import "ObservableHTTPRequestTest.h"
#import "ObservableHTTPRequest.h"

@implementation ObservableHTTPRequestTest

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (object == [ObservableHTTPRequest shared]) {    
    NSLog(@"keyPath=%@", keyPath);
    
    NSDictionary *dict = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *event = [dict objectForKey:ObservableHTTPRequestDictEventKey];
    NSString *context = [dict objectForKey:ObservableHTTPRequestDictContextKey];
    
    NSLog(@"event=%@", event);
    NSLog(@"context=%@", context);
    
    if ([event isEqualToString:ObservableHTTPRequestEventFinish]) {
      NSNumber *statusCode = [dict objectForKey:ObservableHTTPRequestDictStatusCodeKey];
      NSDictionary *headers = [dict objectForKey:ObservableHTTPRequestDictHeadersKey];
      NSData *body = [dict objectForKey:ObservableHTTPRequestDictBodyKey];
      
      NSLog(@"statusCode=%d", [statusCode intValue]);
      NSLog(@"headers=%@", headers);
      // TODO: don't assume body is UTF8 encoded
      NSLog(@"body=%@", [[[NSString alloc] initWithData:body
					       encoding:NSUTF8StringEncoding]
			 autorelease]);
    } else if ([event isEqualToString:ObservableHTTPRequestEventRequesting]) {
      // request started
    } else if ([event isEqualToString:ObservableHTTPRequestEventError]) {
      NSError *error = [dict objectForKey:ObservableHTTPRequestDictErrorKey];
      NSLog(@"error=%@", error);
    }
  }
}

- (void)setup {
  [[ObservableHTTPRequest shared] addObserver:self
				   forKeyPath:@"kittensSearch"
				      options:NSKeyValueObservingOptionNew
				      context:NULL];
  [[ObservableHTTPRequest shared] addObserver:self
				   forKeyPath:@"dogsSearch"
				      options:NSKeyValueObservingOptionNew
				      context:NULL];
}

- (void)request {
  [[ObservableHTTPRequest shared] get:@"http://www.google.com"
			    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
				       @"kittens", @"q",
				       nil]
		       observableName:@"kittensSearch"
			      context:@"context"];
  
  // request and cancel
  [[ObservableHTTPRequest shared] get:@"http://www.google.com"
			    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
				       @"dogs", @"q",
				       nil]
		       observableName:@"dogsSearch"
			      context:@"context"];
  [[ObservableHTTPRequest shared] cancelObservableName:@"dogsSearch"];
}

- (void)cleanup {
  [[ObservableHTTPRequest shared] removeObserver:self
				      forKeyPath:@"kittensSearch"];
  [[ObservableHTTPRequest shared] removeObserver:self
				      forKeyPath:@"dogsSearch"];
}

@end
