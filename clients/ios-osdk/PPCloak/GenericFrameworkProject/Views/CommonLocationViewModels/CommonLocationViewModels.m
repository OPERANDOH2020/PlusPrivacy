//
//  CommonLocationViewModels.m
//  PPCloak
//
//  Created by Costin Andronache on 4/4/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonLocationViewModels.h"

@interface CommonLocationViewModel()
@property (readwrite, strong, nonatomic) NSArray<CLLocation*> *initialLocations;
@property (readwrite, assign, nonatomic) BOOL editable;
@end

@implementation CommonLocationViewModel
-(instancetype)initWithLocations:(NSArray<CLLocation *> *)locations editable:(BOOL)editable {
    if (self = [super init]) {
        self.initialLocations = locations;
        self.editable = editable;
    }
    return self;
}
@end

@implementation CommonLocationViewCallbacks
@end

@implementation RandomWalkLocationSettingsModel
@end

@implementation RandomWalkLocationStatusModel
@end
