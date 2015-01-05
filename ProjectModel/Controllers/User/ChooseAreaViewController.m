//
//  ChooseAreaViewController.m
//  Club
//
//  Created by dongway on 14-8-17.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import "ChooseAreaViewController.h"
#import "LoginService.h"
#import "SVProgressHUD.h"
#import "InternetRequest.h"
#import "SharedData.h"
#import "Login.h"
@interface ChooseAreaViewController ()
{
    __weak IBOutlet UITableView *tableview;
    NSMutableArray *titles;
    
    NSString *provinceIdSelected;
    NSString *cityIdSelected;
    NSString *areaIdSelected;
    NSString *lifeHallIdSelected;
    NSString *blockIdSelected;
}
@end

@implementation ChooseAreaViewController

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
    tableview.delegate = self;
    tableview.dataSource = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择小区";
    titles = [[NSMutableArray alloc] initWithObjects:@"选择所在省份",@"选择所在城市",@"选择所在区域",@"选择所在小区",@"选择生活馆", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [titles objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *urlString;
    NSString *token =self.user.token;
    switch (row) {
        case 0:
            urlString =  [NSString stringWithFormat:ChooseProvinceURL,token];
            break;
        case 1:
            urlString = [NSString stringWithFormat:ChooseCityURL,provinceIdSelected,token];
            break;
        case 2:
            urlString = [NSString stringWithFormat:ChooseAreaURL,cityIdSelected,token];
            break;
        case 3:
            urlString = [NSString stringWithFormat:ChooseScopeURL,areaIdSelected,token];
            break;
        case 4:
            urlString = [NSString stringWithFormat:ChooseLifehallURL,cityIdSelected,token];
            break;
        default:
            break;
    }
    
    [self loadDataOfProvinceWithURLString:urlString andRow:row];
    
}

- (IBAction)submitAction:(id)sender {
    NSString *urlString = [NSString stringWithFormat:ContcatURL,areaIdSelected,blockIdSelected,lifeHallIdSelected,self.user.token];
    [self bindScopeWithURLString:urlString];
}


#pragma DatasTableViewControllerDelegate
-(void)popViewControllerWithData:(NSDictionary *)data andIndex:(NSInteger)index{
    switch (index) {
        case 0:
            provinceIdSelected = [data objectForKey:@"province"];
            break;
        case 1:
            cityIdSelected = [data objectForKey:@"city"];
            break;
        case 2:
            areaIdSelected = [data objectForKey:@"area"];
            break;
        case 3:
            blockIdSelected = [data objectForKey:@"sid"];
            break;
        case 4:
            lifeHallIdSelected = [data objectForKey:@"lifehall_id"];
            break;
        default:
            break;
    }
    NSString *name = [data objectForKey:@"name"];
    [titles replaceObjectAtIndex:index withObject:name];
    [tableview reloadData];
}

//根据row和url加载省，市，区等信息
-(void)loadDataOfProvinceWithURLString:(NSString *)urlString andRow:(NSInteger)row{
    NSRange range = [urlString rangeOfString:@"null"];
    if (range.length>0) {
        [SVProgressHUD showErrorWithStatus:@"数据异常"];
    }else{
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *result = [InternetRequest loadDataWithUrlString:urlString];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSNumber *status = (NSNumber *)[result objectForKey:@"status"];
                if ([status isEqual:[NSNumber numberWithInt:2]]) {
                    NSArray *datass = [result objectForKey:@"info"];
                    DatasTableViewController *datasViewController = [[DatasTableViewController alloc] initWithNibName:@"DatasTableViewController" bundle:nil];
                    datasViewController.delegate = self;
                    datasViewController.index = row;
                    datasViewController.datas =(NSMutableArray *) datass;
                    [self.navigationController pushViewController:datasViewController animated:YES];
                    [SVProgressHUD dismiss];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
                }
            });
        });
    }
}

//关联小区
-(void)bindScopeWithURLString:(NSString *)urlString{
    NSRange range = [urlString rangeOfString:@"null"];
    if (range.length>0) {
        [SVProgressHUD showErrorWithStatus:@"数据异常"];
    }else{
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *result = [InternetRequest loadDataWithUrlString:urlString];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSNumber *status = (NSNumber *)[result objectForKey:@"status"];
                if ([status isEqual:[NSNumber numberWithInt:2]]) {
                    LoginService *loginService = [[LoginService alloc] init];
                    [loginService handlesWhenDismissLoginViewController:self.loginViewController];
                    [SVProgressHUD showSuccessWithStatus:@"关联小区成功"];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"关联失败出错"];
                }
            });
        });
    }
}
@end