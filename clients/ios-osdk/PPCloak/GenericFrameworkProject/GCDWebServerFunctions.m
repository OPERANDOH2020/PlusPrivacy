/*
 Copyright (c) 2012-2015, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/* PLUS PRIVACY (c) 2017 
   MODIFICATIONS: REMOVED EVERYTHING AND KEPT ONLY THE NECESSARY CODE TO PERFORM URLFORM DECODING
 
 */

#if !__has_feature(objc_arc)
#error GCDWebServer requires ARC
#endif
#import "GCDWebServerFunctions.h"


NSString* GCDWebServerEscapeURLString(NSString* string) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":@/?&=+"), kCFStringEncodingUTF8));
#pragma clang diagnostic pop
}

NSString* GCDWebServerUnescapeURLString(NSString* string) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  return CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)string, CFSTR(""), kCFStringEncodingUTF8));
#pragma clang diagnostic pop
}

NSDictionary* GCDWebServerParseURLEncodedForm(NSString* form) {
  NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
  NSScanner* scanner = [[NSScanner alloc] initWithString:form];
  [scanner setCharactersToBeSkipped:nil];
  while (1) {
    NSString* key = nil;
    if (![scanner scanUpToString:@"=" intoString:&key] || [scanner isAtEnd]) {
      break;
    }
    [scanner setScanLocation:([scanner scanLocation] + 1)];

    NSString* value = nil;
    [scanner scanUpToString:@"&" intoString:&value];
    if (value == nil) {
      value = @"";
    }

    key = [key stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString* unescapedKey = key ? GCDWebServerUnescapeURLString(key) : nil;
    value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString* unescapedValue = value ? GCDWebServerUnescapeURLString(value) : nil;
    if (unescapedKey && unescapedValue) {
      [parameters setObject:unescapedValue forKey:unescapedKey];
    } else {
      NSLog(@"Failed parsing URL encoded form for key \"%@\" and value \"%@\"", key, value);
    }

    if ([scanner isAtEnd]) {
      break;
    }
    [scanner setScanLocation:([scanner scanLocation] + 1)];
  }
  return parameters;
}
