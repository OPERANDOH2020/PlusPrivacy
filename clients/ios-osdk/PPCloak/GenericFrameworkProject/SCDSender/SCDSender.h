//
//  SCDSender.h
//  PPCloak
//
//  Created by Costin Andronache on 7/21/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCDSendParamaters : NSObject
@property (readonly, nonatomic) NSString *scdJSONText;
@property (readonly, nonatomic) NSString *deviceId;
@property (readonly, nonatomic) NSString *appBundleIdentifier;

-(instancetype)initWithJSON:(NSString* _Nonnull)JSON deviceId:(NSString* _Nonnull)deviceId bundleId:(NSString *_Nonnull)bundleId;

@end

NS_ASSUME_NONNULL_END

@protocol SCDSender <NSObject>
-(void)sendSCDParameters:(SCDSendParamaters* _Nonnull)params withCompletion:(void(^_Nullable)(NSError* __nullable errorIfAny))completion;
@end

@interface SCDSender : NSObject <SCDSender>

@end
