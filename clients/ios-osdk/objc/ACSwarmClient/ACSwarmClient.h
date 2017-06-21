/*
 * Copyright (c) 2016 ROMSOFT.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the The MIT License (MIT).
 * which accompanies this distribution, and is available at
 * http://opensource.org/licenses/MIT
 *
 * Contributors:
 *    Cătălin Pomîrleanu (ROMSOFT)
 * Initially developed in the context of OPERANDO EU project www.operando.eu
 */


#import <Foundation/Foundation.h>

@interface ACSwarmClient : NSObject

- (id)init;
- (void)createSocket;
- (void)emitRequestWithSwarmingName:(NSString *)swarmingName command:(NSString *)command ctor:(NSString *)constructor arguments:(NSArray *)args serverRequestType:(NSInteger)reqType;
- (void)getLoginApprovalForUsername:(NSString *)username andPassword:(NSString *)password;

@end
