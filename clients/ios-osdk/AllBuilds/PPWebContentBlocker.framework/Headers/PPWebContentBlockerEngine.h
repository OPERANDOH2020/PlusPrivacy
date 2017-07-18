//
//  PPWebContentBlockerEngine.h
//  PPWebContentBlocker
//
//  Created by Costin Andronache on 3/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//
/* This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#import <Foundation/Foundation.h>
#import "PPActionForWebContent.h"

@interface PPWebContentBlockerEngine : NSObject
-(void)prepareWithCompletion:(void(^ _Nonnull)(NSError * _Nullable errorIfAny))completion;
-(WebContentActionType)actionForRequest:(NSURLRequest* _Nonnull)request;

@end
