/*
 * ObservableHTTPRequest, HTTP requests with KVO support
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

#import "ObservableHTTPRequest.h"

NSString *const ObservableHTTPRequestErrorDomain = @"ObservableHTTPRequest";

NSString *const ObservableHTTPRequestDictEventKey = @"event";
NSString *const ObservableHTTPRequestDictStatusCodeKey = @"statusCode";
NSString *const ObservableHTTPRequestDictHeadersKey = @"headers";
NSString *const ObservableHTTPRequestDictBodyKey = @"body";
NSString *const ObservableHTTPRequestDictContextKey = @"context";
NSString *const ObservableHTTPRequestDictErrorKey = @"error";

NSString *const ObservableHTTPRequestEventRequesting = @"requesting";
NSString *const ObservableHTTPRequestEventFinish = @"finish";
NSString *const ObservableHTTPRequestEventError = @"error";

@interface ObservableURLConnection : NSURLConnection

@property(nonatomic, copy) NSString *observableName;
@property(nonatomic, assign) NSInteger statusCode;
@property(nonatomic, retain) NSDictionary *headers;
@property(nonatomic, retain) NSMutableData *body;
@property(nonatomic, retain) id context;

@end

@implementation ObservableURLConnection

@synthesize observableName;
@synthesize statusCode;
@synthesize headers;
@synthesize body;
@synthesize context;

- (id)initWithRequest:(NSURLRequest *)request
             delegate:(id)delegate
       observableName:(NSString*)aObservableName
	      context:(id)aContext {
  self = [super initWithRequest:request delegate:delegate];
  if (self == nil) {
    return nil;
  }
  
  self.observableName = aObservableName;
  self.body = [NSMutableData data];
  self.context = aContext;
  
  return self;
}

- (void)dealloc {
  self.observableName = nil;
  self.headers = nil;
  self.body = nil;
  self.context = nil;
  
  [super dealloc];
}

@end


@interface ObservableHTTPRequest ()

@property(nonatomic, retain) NSMutableDictionary *observables;
@property(nonatomic, retain) NSMutableDictionary *connections;

@end

@implementation ObservableHTTPRequest

@synthesize timeout;
@synthesize defaultHeaders;
@synthesize observables;
@synthesize connections;

+ (ObservableHTTPRequest *)shared {
  static ObservableHTTPRequest *shared = nil;
  
  @synchronized(self) {
    if (shared == nil) {
      shared = [[ObservableHTTPRequest alloc] init];
    }
  }
  
  return shared;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
  return NO;
}

+ (NSString *)urlEncodedDictionary:(NSDictionary *)dict {
  NSMutableString *encoded = [NSMutableString string];
  
  int len = [dict count];
  for (NSString *key in [dict allKeys]) {
    NSString *value = [dict objectForKey:key];
    [encoded appendString:key];
    [encoded appendString:@"="];
    [encoded appendString:
     [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (len > 1) {
      [encoded appendString:@"&"];
    }
    len--;
  }
  
  return encoded;
}

+ (NSDictionary *)errorDictWithDescription:(NSString *)description
				   context:(id)context {
  NSDictionary *userInfo = [NSDictionary
                            dictionaryWithObject:description
                            forKey:NSLocalizedDescriptionKey];
  return [NSDictionary dictionaryWithObjectsAndKeys:
          ObservableHTTPRequestEventError,
	  ObservableHTTPRequestDictEventKey,
	  context,
	  ObservableHTTPRequestDictContextKey,
          [NSError errorWithDomain:ObservableHTTPRequestErrorDomain
                              code:0
                          userInfo:userInfo],
          ObservableHTTPRequestDictErrorKey,
          nil];
}

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.timeout = 15.0f;
  self.observables = [NSMutableDictionary dictionary];
  self.connections = [NSMutableDictionary dictionary];
  
  return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
  return [self.observables objectForKey:key];
}

- (void)addObserver:(NSObject *)observer
         forKeyPath:(NSString *)keyPath
            options:(NSKeyValueObservingOptions)options
            context:(void *)context {
  if ([self.observables objectForKey:keyPath] != nil) {
    [self.observables setObject:[NSNull null] forKey:keyPath];
  }
  
  [super addObserver:observer
          forKeyPath:keyPath
             options:options
             context:context];
}

- (void)alertObservable:(NSString *)observableName dict:(NSDictionary *)dict {
  [self willChangeValueForKey:observableName];
  [self.observables setObject:dict forKey:observableName];
  [self didChangeValueForKey:observableName];
}

- (void)connection:(ObservableURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
  NSHTTPURLResponse *httpResponse = ((NSHTTPURLResponse *)response);
  
  connection.statusCode = [httpResponse statusCode];
  connection.headers = [httpResponse allHeaderFields];
}

- (void)connection:(ObservableURLConnection *)connection
    didReceiveData:(NSData *)data {
  [connection.body appendData:data];
}

- (void)connectionDidFinishLoading:(ObservableURLConnection *)connection {  
  [self alertObservable:connection.observableName
                   dict:[NSDictionary dictionaryWithObjectsAndKeys:
                         ObservableHTTPRequestEventFinish,
                         ObservableHTTPRequestDictEventKey,
			 connection.context,
			 ObservableHTTPRequestDictContextKey,
                         [NSNumber numberWithInt:connection.statusCode],
                         ObservableHTTPRequestDictStatusCodeKey,
                         connection.headers,
                         ObservableHTTPRequestDictHeadersKey,
                         connection.body,
                         ObservableHTTPRequestDictBodyKey,
                         nil]];
  [self.connections removeObjectForKey:connection.observableName];
}

- (void)connection:(ObservableURLConnection *)connection
  didFailWithError:(NSError *)error {  
  [self alertObservable:connection.observableName
                   dict:[NSDictionary dictionaryWithObjectsAndKeys:
                         ObservableHTTPRequestEventError,
                         ObservableHTTPRequestDictEventKey,
			 connection.context,
			 ObservableHTTPRequestDictContextKey,
                         error,
                         ObservableHTTPRequestDictErrorKey,
                         nil]];
  [self.connections removeObjectForKey:connection.observableName];
}

- (BOOL)makeRequest:(NSString *)url
             method:(NSString *)method
          arguments:(NSDictionary *)arguments
	    timeout:(NSTimeInterval)aTimeout
     observableName:(NSString *)observableName
	    context:(id)context {
  if ([self.connections objectForKey:observableName] != nil) {
    return NO;
  }
  
  if (arguments != nil && [method isEqualToString:@"GET"]) {
    url = [NSString stringWithFormat:@"%@?%@",
           url,
           [[self class] urlEncodedDictionary:arguments]];
  }
  
  NSMutableURLRequest *request = [NSMutableURLRequest
                                  requestWithURL:[NSURL URLWithString:url]
                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:aTimeout];
  
  if (self.defaultHeaders != nil) {
    for (NSString *key in self.defaultHeaders) {
      [request setValue:[self.defaultHeaders objectForKey:key]
     forHTTPHeaderField:key];
    }
  }
  
  [request setHTTPMethod:method];
  
  if (arguments != nil && [method isEqualToString:@"POST"]) {
    NSData *body = [[[self class] urlEncodedDictionary:arguments]
                    dataUsingEncoding:NSUTF8StringEncoding
                    allowLossyConversion:YES];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]]
   forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-Type"];
  }
  
  // context is used when building dict so make sure it's not nil 
  if (context == nil) {
    context = [NSNull null];
  }
  
  ObservableURLConnection *connection = [[[ObservableURLConnection alloc]
					  initWithRequest:request
					  delegate:self
					  observableName:observableName
					  context:context]
					 autorelease];
  if(connection != nil) {
    [self.connections setObject:connection forKey:observableName];
    [self alertObservable:observableName
                     dict:[NSDictionary dictionaryWithObjectsAndKeys:
                           ObservableHTTPRequestEventRequesting,
                           ObservableHTTPRequestDictEventKey,
			   connection.context,
			   ObservableHTTPRequestDictContextKey,
                           nil]];
  } else {
    [self alertObservable:observableName
                     dict:[[self class]
			   errorDictWithDescription:
                           @"ObservableURLConnection failed"
			   context:
			   context]];
  }
  
  return YES;
}

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
    timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName
    context:(id)context {
  return [self makeRequest:url
                    method:@"GET"
                 arguments:arguments
		   timeout:aTimeout
            observableName:observableName
		   context:context];
}

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
    timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName {
  return [self get:url
	 arguments:arguments
	   timeout:aTimeout
    observableName:observableName
	   context:nil];
}

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
observableName:(NSString *)name
    context:(id)context {
  return [self get:url arguments:arguments
	   timeout:self.timeout
    observableName:name
	   context:context];
}

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
observableName:(NSString *)name {
  return [self get:url arguments:arguments
	   timeout:self.timeout
    observableName:name];
}

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
     timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName
     context:(id)context {
  return [self makeRequest:url
                    method:@"POST"
                 arguments:arguments
		   timeout:aTimeout
            observableName:observableName
		   context:context];
}

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
     timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName {
  return [self post:url
	  arguments:arguments
	    timeout:aTimeout
     observableName:observableName
	    context:nil];
}

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
observableName:(NSString *)name
     context:(id)context {
  return [self post:url arguments:arguments
	    timeout:self.timeout
     observableName:name
	    context:context];
}

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
observableName:(NSString *)name {
  return [self post:url arguments:arguments
	    timeout:self.timeout
     observableName:name];
}

- (BOOL)cancelObservableName:(NSString *)observableName {
  ObservableURLConnection *connection = [self.connections
                                         objectForKey:observableName];
  if (connection == nil) {
    return NO;
  }
  
  [connection cancel];
  [self alertObservable:connection.observableName
                   dict:[[self class]
                         errorDictWithDescription:@"Request cancelled"
			 context:connection.context]]; 
  
  return YES;
}

- (void)dealloc {
  for (ObservableURLConnection *connection in self.connections) {
    [connection cancel];
    [self alertObservable:connection.observableName
                     dict:[[self class]
                           errorDictWithDescription:@"Request dealloc"
			   context:connection.context]];    
  }
  
  self.defaultHeaders = nil;
  self.observables = nil;
  self.connections = nil;
  
  [super dealloc];
}

@end
