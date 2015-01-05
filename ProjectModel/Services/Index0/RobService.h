//
//  RobService.h
//  Club
//
//  Created by dongway on 14-8-19.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RobViewController.h"
#import "RobedRecordsTableViewController.h"
#import "PastItemsTableViewController.h"

@interface RobService : NSObject
-(void)setRobModelWithToken:(NSString *)token andUser_type:(NSInteger )user_type withDoneAndStatus:(doneWithObjectAndStatus)done;
-(void)robWithToken:(NSString *)token andUser_type:(NSInteger )user_type andRobModel:(RobModelInfo *)robModel witDoneAndObject:(doneWithObjectAndStatus)done;
-(void)loadAdverPicWithPos:(NSInteger)pos inViewController:(RobViewController *)viewController;
-(void)setItemInfosWithController:(RobViewController *)viewController andGoodModel:(RobModelInfo *)good;
@end
