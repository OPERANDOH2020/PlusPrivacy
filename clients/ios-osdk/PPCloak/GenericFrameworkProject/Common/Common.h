//
//  Common.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define SAFECALL(x, ...) if(x){x(__VA_ARGS__);}
#define SAFEADD(dict, key, value) if(value){dict[key]=value;}
#define WEAKSELF __weak typeof(self) weakSelf = self;

#import "NSArray+ContainsAnyFromArray.h"

typedef void(^EventDataBlock)(NSMutableDictionary* evData);

#endif /* Common_h */
