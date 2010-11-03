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

#import <Foundation/Foundation.h>

NSString *const ObservableHTTPRequestErrorDomain;

NSString *const ObservableHTTPRequestDictEventKey;
NSString *const ObservableHTTPRequestDictStatusCodeKey;
NSString *const ObservableHTTPRequestDictHeadersKey;
NSString *const ObservableHTTPRequestDictBodyKey;
NSString *const ObservableHTTPRequestDictContextKey;
NSString *const ObservableHTTPRequestDictErrorKey;

// dict keys: event, context
NSString *const ObservableHTTPRequestEventRequesting; 

// dict keys: event, context, statusCode, header, body
NSString *const ObservableHTTPRequestEventFinish;

// dict keys: event, context, error
NSString *const ObservableHTTPRequestEventError;


@interface ObservableHTTPRequest : NSObject

@property(nonatomic, assign) NSTimeInterval timeout;
@property(nonatomic, copy) NSDictionary *defaultHeaders;

+ (ObservableHTTPRequest *)shared;

// returns YES if connection was created NO if already exist
- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
    timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName
    context:(id)context;

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
    timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName;

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
observableName:(NSString *)name
    context:(id)context;

- (BOOL)get:(NSString *)url
  arguments:(NSDictionary *)arguments
observableName:(NSString *)name;

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
     timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName
     context:(id)context;

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
     timeout:(NSTimeInterval)aTimeout
observableName:(NSString *)observableName;

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
observableName:(NSString *)name
     context:(id)context;

- (BOOL)post:(NSString *)url
   arguments:(NSDictionary *)arguments
observableName:(NSString *)name;

// YES if connection was found and cancelled
- (BOOL)cancelObservableName:(NSString *)observableName;

@end
