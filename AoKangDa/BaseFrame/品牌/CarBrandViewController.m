//
//  CarBrandViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/9.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CarBrandViewController.h"

#import "CarSeriesViewController.h"
#import "Public.h"

#import "CarBrandTableViewCell.h"
#import "WMPageController.h"


#import "AppDelegate.h"
#import "CacheTool.h"


#import "MJRefresh.h"

@interface CarBrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *carArray;

@property (nonatomic,copy) NSString *innerValue;

@end

@implementation CarBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carArray = [NSMutableArray new];
    
    
    NSArray *getArray = [CacheTool getChannels];
    WMPageController *parentVC = (WMPageController*)self.parentViewController;
    
    if (parentVC.viewControllerClasses.count - 5 == getArray.count ) {
        
        NSDictionary *getDict = getArray[parentVC.selectIndex - 5];
        
        
        if ([VALUEFORKEY(getDict, @"Type") isEqualToString:@"pinpai"]) {
            _innerValue = [Header formateString:VALUEFORKEY(getDict, @"Value")];
        }
    }
    
    
    [self createUI];
    
    [_tableView.header beginRefreshing];
 
}

- (void)createUI
{
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, ViewScreen_Height - navHeight - 40)];
    tableView.backgroundColor = MeGlobalBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpGetSeries)];
    _tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark -- tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _carArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[CarBrandTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.infoDict = _carArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    CarSeriesViewController *carSeriesVC = [[CarSeriesViewController alloc]init];
    carSeriesVC.ID = VALUEFORKEY(_carArray[indexPath.section], @"ID");
    carSeriesVC.title = VALUEFORKEY(_carArray[indexPath.section], @"Name");
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
    [nav pushViewController:carSeriesVC animated:YES];
    
//    [self.navigationController pushViewController:carSeriesVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}



#pragma mark -- httpRequest
- (void)httpGetSeries
{
    
    if (_innerValue) {
        [RequestManager getSeriesListWihtID:_innerValue Succeed:^(NSData *data) {
            
            
            
            NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSArray *returnArray = returnDict[@"Data"];
            
            if (returnArray.count > 0) {
                _carArray = [returnArray mutableCopy];
                [_tableView reloadData];
            }
            
            [_tableView.header endRefreshing];
            
        } failed:^(NSError *error) {
            [_tableView.header endRefreshing];
            
        }];

    }else{
        
        [_tableView.header endRefreshing];
    }
    
}



@end
