//
//  BuyService.h
//  Club
//
//  Created by MartinLi on 14-8-23.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BuyViewController;
#import "GoodsViewController.h"
#import "Index0_3ViewController.h"
@interface BuyService : NSObject

@property(nonatomic,strong)NSDictionary *firstLevelData;
-(void)setSelectedColorInCollectionView:(UICollectionView *)collectionView withSelectedRow:(NSInteger)row withDatas:(NSArray *)datas;
-(void)loadGoodTypesWithToken:(NSString *)token andUser_type:(NSInteger )user_type InViewController:(UIViewController *)viewController;
//-(void)type_goodsWithToken:(NSString *)token andUser_type:(NSInteger )user_type andSubtypeId:(NSString *)subtypeId andPageString:(NSString *)pageString withDone:(doneWithObject)done;
-(void)type_goodsWithToken:(NSString *)token andUser_type:(NSInteger )user_type andSubtypeId:(NSString *)subtypeId andPageString:(NSString *)pageString inTabBarController:(UITabBarController *)tabBarController withDone:(doneWithObject)done;
@end
