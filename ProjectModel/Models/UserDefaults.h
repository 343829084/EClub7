//
//  UserDefaults.h
//  Club
//
//  Created by dongway on 14-8-11.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChangeNameViewController.h"
#import "ChangeAdressViewController.h"
@interface UserDefaults : NSObject


@property (retain, nonatomic) NSUserDefaults *userDefaults1;

@property (copy, nonatomic) NSString *isLogin;
-(void)ChangeNickName:(NSString *)nickname onChangeNameViewController:(ChangeNameViewController *)viewController;
-(void)ChangeAddressgo:(NSString *)address onChangeAddress:(ChangeAdressViewController *)viewController;
@end
