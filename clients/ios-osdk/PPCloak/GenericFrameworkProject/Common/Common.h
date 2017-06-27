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
#define WEAKSELF __weak typeof(self) weakSelf = self;

#endif /* Common_h */
