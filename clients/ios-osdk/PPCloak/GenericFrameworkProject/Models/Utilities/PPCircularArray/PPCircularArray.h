//
//  PPCircularArray.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCircularArray : NSObject

-(instancetype _Nullable)initWithCapacity:(NSInteger)capacity NS_DESIGNATED_INITIALIZER;

-(void)addObjects:(NSArray* _Nonnull)objects;
-(void)addObject:(id _Nonnull)object;
-(NSArray* _Nonnull)allObjects;


@end
