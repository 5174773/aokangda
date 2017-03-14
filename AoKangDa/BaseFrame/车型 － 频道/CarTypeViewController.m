//
//  CarTypeViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/17.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CarTypeViewController.h"


#import "ConcernOnSoldTableViewCell.h"

#import "Public.h"

#import "SelectChannelScrollView.h"
#import "SelectLogoScrollView.h"
#import "CacheTool.h"
#import "WMPageController.h"

#import "MJRefresh.h"

@interface CarTypeViewController ()<UITableViewDataSource,UITableViewDelegate,SelectLogoScrollViewDelegate,SelectChannelScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *brandArray;
@property (nonatomic,strong) NSArray *priceArray;

@property (nonatomic,strong) SelectLogoScrollView *pinpaiScrollView;
@property (nonatomic,strong) SelectChannelScrollView *jiageScrollView;

@property (nonatomic,copy) NSString *innerType;
@property (nonatomic,copy) NSString *CarPrice;
@property (nonatomic,copy) NSString *Carbrand;

@end

@implementation CarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray new];
    _CarPrice = @"";
    _Carbrand = @"";
    
   
    [self creatUI];
    
    [_tableView.header beginRefreshing];
    
}


-(void)creatUI
{
    self.view.backgroundColor = MeGlobalBackgroundColor;
    
    float startY = 0;
    float scrollViewWidth = 30;
    
    ////
    SelectLogoScrollView *pinpaiScrollView = [[SelectLogoScrollView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, scrollViewWidth)];
    pinpaiScrollView.backgroundColor = [UIColor whiteColor];
    pinpaiScrollView.dataArray = _brandArray;
    pinpaiScrollView.delegate = self;
    _pinpaiScrollView = pinpaiScrollView;
    [self.view addSubview:pinpaiScrollView];
    
    ////
    startY += VIEW_H(pinpaiScrollView) + 0.5;
    SelectChannelScrollView *jiageScrollView = [[SelectChannelScrollView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, scrollViewWidth)];
    jiageScrollView.flag = 2;
    jiageScrollView.delegate = self;
    _jiageScrollView = jiageScrollView;
    jiageScrollView.backgroundColor = [UIColor whiteColor];
    jiageScrollView.dataArray = _priceArray;
    [self.view addSubview:jiageScrollView];
    
    
    ///
    startY += VIEW_H(jiageScrollView);
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    UITableView *searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, ViewScreen_Height - ButtonGlobalHeight - navHeight - startY)];
    searchTableView.backgroundColor = MeGlobalBackgroundColor;
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadding)];
    _tableView = searchTableView;
    [self.view addSubview:searchTableView];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, 5)];
    view.backgroundColor = MeGlobalBackgroundColor;
    searchTableView.tableFooterView = view;
    
}


#pragma mark -- SelectLogoScrollViewDelegate
-(void)selectLogoScrollViewWith:(NSDictionary *)dictonary
{
    _Carbrand = VALUEFORKEY(dictonary, @"ID");
    [self httpRequestGet];
}

#pragma mark -- SelectChannelScrollViewDelegate
- (void)selectChannelScrollViewWith:(NSDictionary *)dictionary
{
    _CarPrice = VALUEFORKEY(dictionary, @"ID");
    [self httpRequestGet];
}

#pragma mark -- tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.carInfo = _dataArray[indexPath.section];
    
    return cell;
}


#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ConcernTableViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return MeSectionHeight;
}




#pragma mark -- - (void)searchByword
- (void)httpRequestGet
{
    [self showActityHoldView];
    
    [RequestManager jiageListByUserWithBrand:_Carbrand price:_CarPrice type:_innerType pageIndex:@"1" pageSize:@"10" Succeed:^(NSData *data) {
        
         [self hiddenActityHoldView];
        
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        
        if (returnDic) {
            
            _dataArray = returnDic[@"Data"];
            
            [_tableView reloadData];
            
            if (_dataArray.count == 0) {
                [self addActityText:NoDataHttp deleyTime:1];
            }
            
        }
        
    } failed:^(NSError *error) {
        
         [self hiddenActityHoldView];
    }];
}


#pragma mark -- httpRequest
- (void)loadding
{
    
#warning --- !!!!!
    
    NSArray *getArray = [CacheTool getChannels];
    WMPageController *parentVC = (WMPageController*)self.parentViewController;
    
    if (parentVC.viewControllerClasses.count - 5 == getArray.count ) {
        
        NSDictionary *getDict = getArray[parentVC.selectIndex - 5];
        
        MMLog(@"%@",getDict);
        
        if ([VALUEFORKEY(getDict, @"Type") isEqualToString:@"leixing"]) {
            
            _innerType = [Header formateString:VALUEFORKEY(getDict, @"Value")];
            MMLog(@"inntppp   %@",_innerType);
        }
    }
    
    
    if (_innerType) {
        
        __weak __typeof(self)weakSelf = self;
        [RequestManager carTypeLoadWithType:_innerType pageIndex:@"" pageSize:@"" Succeed:^(NSData *data) {
            
             [_tableView.header endRefreshing];
            [_tableView.header removeFromSuperview];
            
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            returnDic = returnDic[@"Data"];
            
            if (returnDic) {
                _brandArray = returnDic[@"Brands"];
                _priceArray = returnDic[@"Prices"];
            }
            
            [weakSelf resetScrollView];
            [weakSelf firstHttp];
        }
        failed:^(NSError *error) {
              [_tableView.header endRefreshing];
        }];
        
    }else{
        [_tableView.header endRefreshing];
    }
   
   
}


- (void)firstHttp
{
    if (_brandArray.count > 0 && _priceArray.count > 0) {
        _Carbrand = VALUEFORKEY(_brandArray[0], @"ID");
        _CarPrice = VALUEFORKEY(_priceArray[0], @"ID");
    }
    [self httpRequestGet];
}

- (void)resetScrollView
{
    
    _pinpaiScrollView.dataArray = _brandArray;
    _jiageScrollView.dataArray = _priceArray;
}

@end
