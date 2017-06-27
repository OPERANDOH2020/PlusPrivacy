//
//  NSURLProtocol+WKWebViewSupport.m
//  Pods
//
//  Created by Dylan on 2016/11/14.
//
//
/*
 Copyright (c) 2016 Dylan <3664132@163.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "NSURLProtocol+WKWebViewSupport.h"
#import <WebKit/WebKit.h>

Class WK_ContextControllerClass() {
  static Class cls;
  if (!cls) {
    cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
  }
  return cls;
}

SEL WK_RegisterSchemeSelector() {
  return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

SEL WK_UnregisterSchemeSelector() {
  return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation NSURLProtocol (WKWebViewSupport)

+ (void)wk_registerScheme:(NSString *)scheme {
  Class cls = WK_ContextControllerClass();
  SEL sel = WK_RegisterSchemeSelector();
  if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
  }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
  Class cls = WK_ContextControllerClass();
  SEL sel = WK_UnregisterSchemeSelector();
  if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
  }
}

@end
