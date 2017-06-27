//
//  PPApiHooksStart.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>



void registerHookedClass(Class class);
char** createListOfCurrentlyRegisteredClassNames(int *nCount);

