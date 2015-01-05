//
//  KillListViewController.m
//  Club
//
//  Created by MartinLi on 14-10-22.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "KillListViewController.h"
#import "KillGoodCell.h"
#import "KillService.h"
#import <UIImageView+WebCache.h>
#import "Kills.h"
#import "KillDetailViewController.h"
#import "KillIconCell.h"
@interface KillListViewController ()
{
    KillService *service;
}
@end

@implementation KillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    service = [[KillService alloc] init];
    _tableview.showsVerticalScrollIndicator =NO;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [service loadKillListInViewController:self];
    SharedData *shareData = [SharedData sharedInstance];
    [service goods_futureWithToken:shareData.user.token andUser_type:shareData.user.user_type withDone:^(int status,KillGoodInfo *model){
        if (status ==2) {
            self.datas = model.goods;
            [self.tableview reloadData];
        }else{
            [SharedAction showErrorWithStatus:status witViewController:self];
        }
       
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==5) {
        if(buttonIndex==1){
            [SharedAction loginAggane];
            NSArray *viewControllers = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count*2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger index = row/2;
    if (row%2==0) {
        KillIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KillIconCell" forIndexPath:indexPath];

        KillGood *good = self.datas[index];
        cell.date.text = good.start_time;
        if (good.seconds==0) {
            cell.backImage.image = [UIImage imageNamed:@"finish_kill_bg"];
        }
        return cell;
    }else{
        KillGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KillGoodCell" forIndexPath:indexPath];
        KillGood *good = self.datas[index];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IP,good.picture]] placeholderImage:[UIImage imageNamed:@"e"]];

        cell.name.text = good.name;
        cell.price.text = [NSString stringWithFormat:@"%@元/%@",good.price,good.unit];
        cell.discount.text = [NSString stringWithFormat:@"%@元/%@",good.discount,good.unit];
        return cell;
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row/2;
    KillGood *good = self.datas[index];
    KillDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KillDetailViewController"];
    viewController.good = good;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if (row%2==0) {
        return 40;
    }else{
        return 95;
    }
}


@end