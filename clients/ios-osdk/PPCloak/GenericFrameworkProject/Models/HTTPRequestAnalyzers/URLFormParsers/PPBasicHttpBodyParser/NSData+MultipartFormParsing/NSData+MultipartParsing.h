//
//  NSData+MultipartParsing.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

// courtesy of user Darkngs, at http://stackoverflow.com/a/22710504

#import <Foundation/Foundation.h>


@interface NSData(MultipartParsing)

- (NSArray *)multipartArray;
- (NSDictionary *)multipartDictionary;

@end
