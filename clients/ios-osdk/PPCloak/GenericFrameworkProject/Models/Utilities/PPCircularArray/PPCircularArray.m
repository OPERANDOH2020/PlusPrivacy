//
//  PPCircularArray.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PPCircularArray.h"

@interface PPCircularArray()
@property (strong, nonatomic) NSMutableArray *backingArray;
@property (assign, nonatomic) NSInteger capacity;
@property (assign, nonatomic) NSInteger numOfItemsEverInserted;

@end

@implementation PPCircularArray

-(instancetype)initWithCapacity:(NSInteger)capacity {
    if (self = [super init]) {
        if (capacity <= 0) {
            return nil;
        }
        
        self.backingArray = [[NSMutableArray alloc] initWithCapacity:capacity];
        self.capacity = capacity;
        self.numOfItemsEverInserted = 0;
    }
    
    return self;
}


-(void)addObject:(id)object {
    NSInteger index = self.numOfItemsEverInserted % self.capacity;
    [self.backingArray insertObject:object atIndex:index];
    self.numOfItemsEverInserted++;
}

-(void)addObjects:(NSArray *)objects{
    for (id obj in objects) {
        [self addObject:obj];
    }
}

-(NSArray *)allObjects {
    return [NSArray arrayWithArray:self.backingArray];
}

@end
