//
//  CNContactStore+PPHOOK.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/5/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Contacts/Contacts.h>
#import <PPApiHooksCore/PPApiHooksCore.h>


@interface CNContactStore(PPHOOK)
HOOKPrefixClass(void, setEventsDispatcher:(PPEventDispatcher*)dispatcher);
@end

