//
//  PriceChannelViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "PriceChannelViewController.h"
#import "ConcernOnSoldTableViewCell.h"

#import "Public.h"

#import "SelectChannelScrollView.h"
#import "SelectLogoScrollView.h"
#import "CacheTool.h"
#import "WMPageController.h"

#import "MJRefresh.h"

@interface PriceChannelViewController ()<UITableViewDataSource,UITableViewDelegate,SelectLogoScrollViewDelegate,SelectChannelScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSArray *brandArray;
@property (nonatomic,strong) NSArray *carTypeArray;

@property (nonatomic,strong) SelectLogoScrollView *pinpaiScrollView;
@property (nonatomic,strong) SelectChannelScrollView *leixingScrollView;

@property (nonatomic,copy) NSString *innerPrice;
@property (nonatomic,copy) NSString *CarType;
@property (nonatomic,copy) NSString *Carbrand;

@end

@implementation PriceChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray new];
    _CarType = @"";
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
    SelectChannelScrollView *leixingScrollView = [[SelectChannelScrollView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, scrollViewWidth)];
    leixingScrollView.flag = 1;
    leixingScrollView.delegate = self;
    _leixingScrollView = leixingScrollView;
    leixingScrollView.backgroundColor = [UIColor whiteColor];
    leixingScrollView.dataArray = _carTypeArray;
    [self.view addSubview:leixingScrollView];
    
   
    ///
    startY += VIEW_H(leixingScrollView);
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    UITableView *searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, ViewScreen_Height - ButtonGlobalHeight - navHeight - startY)];
    searchTableView.backgroundColor = MeGlobalBackgroundColor;
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadding)];
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _CarType = VALUEFORKEY(dictionary, @"ID");
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
    
   [RequestManager jiageListByUserWithBrand:_Carbrand price:_innerPrice type:_CarType pageIndex:@"" pageSize:@"" Succeed:^(NSData *data) {
       
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
        
        if ([VALUEFORKEY(getDict, @"Type") isEqualToString:@"jiage"]) {
            
            _innerPrice = [Header formateString:VALUEFORKEY(getDict, @"Value")];
            
        }
    }
    
    
    if (_innerPrice) {
        __weak __typeof(self)weakSelf = self;
        [RequestManager jiageLoadWithPrice:_innerPrice pageIndex:@"" pageSize:@"" Succeed:^(NSData *data) {
            
            [_tableView.header endRefreshing];
            [_tableView.header removeFromSuperview];
            
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            returnDic = returnDic[@"Data"];
            
            if (returnDic) {
                _brandArray = returnDic[@"Brands"];
                _carTypeArray = returnDic[@"Types"];
            }
            
            [weakSelf resetScrollView];
            [weakSelf firstHttp];
            
            
        } failed:^(NSError *error) {
            
            [_tableView.header endRefreshing];
            
        }];
    }else{
        [_tableView.header endRefreshing];
    }
    
}



- (void)firstHttp
{
    if (_brandArray.count > 0 && _carTypeArray.count > 0) {
        _Carbrand = VALUEFORKEY(_brandArray[0], @"ID");
        _CarType = VALUEFORKEY(_carTypeArray[0], @"ID");
    }
    [self httpRequestGet];
}

- (void)resetScrollView
{
    
    _pinpaiScrollView.dataArray = _brandArray;
    _leixingScrollView.dataArray = _carTypeArray;
}

@end
