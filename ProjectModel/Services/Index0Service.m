//
//  Index0Service.m
//  ProjectModel
//
//  Created by dongway on 14-8-9.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "Index0Service.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "SharedData.h"
#import "Login.h"
#import "JSONModelLib.h"
#import "SharedAction.h"
#import "AdvertPic.h"
#import "MartinLiPageScrollView.h"
#import "CallPhoneViewController.h"
#import "BalanceModel.h"
#import "BalanceData.h"
#import "Login.h"
#import "BuyService.h"
@implementation Index0Service

-(void)loadUserDefaultsInViewController:(UIViewController *)viewController{
    if ([viewController.tabBarController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController.tabBarController.presentedViewController;
        if ([nav.viewControllers.firstObject isKindOfClass:[LoginViewController class]]) {
            NSLog(@"用户从登录界面进来，不需要重复加载数据了");
        }
    }else{
        //用户进来需要实时刷新数据。
        SharedData *sharedData = [SharedData sharedInstance];
        NSString *name = sharedData.loginname;
        NSString *password = sharedData.password;
        NSString *urlString = [NSString stringWithFormat:LoginURL,name,password];
        [SVProgressHUD showWithStatus:@"正在加载用户信息"];
        [Login getModelFromURLWithString:urlString completion:^(Login *model,JSONModelError *error){
            if (model.status==2) {
                sharedData.user=model.info;
//                [self GetBalanceWithToken:sharedData.user.token andUser_type:sharedData.user.user_type onViewController:viewController];
                [SharedAction setUMessageTagsWithUser:model.info];
                [self loadAdverPicWithPos:1 andCity:model.info.city inViewController:viewController];
                BuyService *buyService = [[BuyService alloc] init];
                [buyService loadGoodTypesWithToken:sharedData.user.token andUser_type:sharedData.user.user_type InViewController:viewController];
            }else{
                [SVProgressHUD showErrorWithStatus:model.error];
                [SharedAction presentLoginViewControllerInViewController:viewController];
            }
             NSLog(@"%@",urlString);
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }];
    }
}
//-(void)loadGoodTypeWithToken:(NSString *)token andUser_type:(NSInteger )user_type

/*
 加载广告图片
 */
-(void)loadAdverPicWithPos:(NSInteger)pos andCity:(NSInteger)city inViewController:(Index0_3ViewController *)viewController{
    NSString *urlString = [NSString stringWithFormat:AdPictUrl,city,pos];
    [AdvertPic getModelFromURLWithString:urlString completion:^(AdvertPic *model,JSONModelError *err){
        NSLog(@"%@",urlString);
        if (model.status==2) {
            NSArray *pictures = model.info.picture;
            viewController.pageviewDatas = pictures;
            [viewController.tableview reloadData];
        }else{
            [SharedAction showErrorWithStatus:model.status witViewController:viewController];
        }
    }];
}

-(NSArray *)namesFromPictures:(NSArray *)pictures{
    if (pictures) {
        NSMutableArray *names = [[NSMutableArray alloc] init];
        for (int i=0; i<pictures.count; i++) {
            Picture *picture = pictures[i];
            NSString *name = [NSString stringWithFormat:@"%@%@",IP,picture.name];
            [names addObject:name];
        }
        return names;
    }else{
        return nil;
    }
}

-(NSArray *)titlesFromPictures:(NSArray *)pictures{
    if (pictures) {
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        for (int i=0; i<pictures.count; i++) {
            Picture *picture = pictures[i];
            NSString *title = nil;
            if (picture.title!=nil) {
                title = picture.title;
            }else{
                title = @"";
            }
            [titles addObject:title];
        }
        return titles;
    }else{
        return nil;
    }
}

-(NSArray *)urlsFromPictures:(NSArray *)pictures{
   if (pictures) {
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (int i=0; i<pictures.count; i++) {
            Picture *picture = pictures[i];
            NSString *url = nil;
            if (picture.url!=nil) {
                url = picture.url;
            }else{
                url = @"";
            }
            [urls addObject:url];
        }
        return urls;
    }else{
        return nil;
    }
}

@end
