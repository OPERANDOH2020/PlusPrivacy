//
//  UILocationListViewCell.h
//  PPCloak
//
//  Created by Costin Andronache on 3/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

typedef void(^UILocationListCellUpdateCallback)(double latitude, double longitude);

@interface UILocationListViewCellCallbacks : NSObject
@property (strong, nonatomic) void(^onCoordinatesUpdate)(double latitude, double longitude);
@property (strong, nonatomic) void(^onDelete)();

@end

@interface UILocationListViewCellModel: NSObject
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) NSInteger locationIndex;
@property (assign, nonatomic) BOOL editable;

@end

@interface UILocationListViewCell: MGSwipeTableCell
+(NSString*)identifierNibName;
-(void)setupWithModel:(UILocationListViewCellModel*)model callbacks:(UILocationListViewCellCallbacks*)callbacks;


@end
