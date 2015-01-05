//
//  RewardRecordsViewController.m
//  Club
//
//  Created by dongway on 14-8-15.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "RewardRecordsViewController.h"
#import "RewardCell.h"
#import "MJRefresh.h"
#import "InternetRequest.h"
#import "SVProgressHUD.h"
#import "NSString+MT.h"
#import "SharedData.h"
#import "Login.h"
#import "JSONModelLib.h"
#import "RewardRcord.h"
@interface RewardRecordsViewController ()
{
    
    __weak IBOutlet UITableView *tableview;
    NSMutableArray *datas;
    NSString *identifier;
    NSInteger page;
    NSDictionary *dic;
}
@end

@implementation RewardRecordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    identifier = @"RewardCell";
    UINib *nib = [UINib nibWithNibName:@"RewardCell" bundle:nil];
    [tableview registerNib:nib forCellReuseIdentifier:identifier];
    tableview.delegate = self;
    tableview.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"中奖记录";
    page = 0;
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tableview headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableview.headerPullToRefreshText = @"下拉可以刷新了";
    tableview.headerReleaseToRefreshText = @"松开马上刷新了";
    tableview.headerRefreshingText = @"正在帮你刷新中";
    
    tableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableview.footerRefreshingText = @"正在帮你加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    page = 1;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    SharedData *shareData = [SharedData sharedInstance];
    UserInfo *user = shareData.user;
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:RewardRecordURL,user.token,user.user_type,pageString];
    [RewardRcord getModelFromURLWithString:urlString completion:^(RewardRcord *model,JSONModelError *error){
    NSLog(@"%@",urlString);
        if (model.status==2) {
            datas= (NSMutableArray *)model.info.lucky;
            [tableview reloadData];
            [tableview headerEndRefreshing];
             [SVProgressHUD dismiss];
        }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有抽奖记录"];
        }
    }];
}

- (void)footerRereshing
{
    page++;
    NSString *pageString = [NSString stringWithFormat:@"%ld",(long)page];
    SharedData *shareData = [SharedData sharedInstance];
    UserInfo *user = shareData.user;
    [SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:RewardRecordURL,user.token,user.user_type,pageString];
    [RewardRcord getModelFromURLWithString:urlString completion:^(RewardRcord *model,JSONModelError *error){
        NSLog(@"%@",urlString);
        if (model.status==2) {
            [datas addObjectsFromArray:model.info.lucky];
            [tableview reloadData];
            [tableview footerEndRefreshing];
            [SVProgressHUD dismiss];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有更多记录"];
        }
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.section;
    LuckyInfo *data = datas[row];
    RewardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   
    // Configure the cell...
    cell.rewardValue.text = data.cash;
    cell.time.text = data.regtime;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}


@end
