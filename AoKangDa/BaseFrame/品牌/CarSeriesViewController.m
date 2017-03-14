//
//  CarSeriesViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CarSeriesViewController.h"

#import "Public.h"
#import "LeftIamge_Button.h"
#import "ConcernOnSoldTableViewCell.h"
#import "MJRefresh.h"
#define BothGap  8

@interface CarSeriesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) LeftIamge_Button *tempSelectButton;
@property (nonatomic,strong) LeftIamge_Button *priceButton;
@property (nonatomic,strong) LeftIamge_Button *yearButton;
@property (nonatomic,strong) LeftIamge_Button *muliButton;

@property (nonatomic,assign) NSInteger searchOrder;       // 排序
@property (nonatomic,assign) BOOL isSelectDown;       // 记录向下还是向上

@property (nonatomic,strong) NSMutableArray *carArray;

@end

@implementation CarSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 默认参数
    
    
    
//    _searchOrder = 1;
    _carArray = [NSMutableArray new];
    
    
    [self creatUI];
    
 
    [_tableView.header beginRefreshing];
    
//    _tempSelectButton = _priceButton;
//    _isSelectDown = YES;
//    [_priceButton chooseDownImage];
//    [_priceButton setSelected:YES];
}

- (void)creatUI
{
    float buttonHeight = 30;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///下去在封装
    float usedMulitipleWidth = (ViewScreen_Width - BothGap) / 11.0f;
    
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(BothGap, 0, usedMulitipleWidth * 2, buttonHeight)];
    sortLabel.text = @"排列";
    sortLabel.backgroundColor = [UIColor whiteColor];
    sortLabel.textColor = RGBACOLOR(141, 141, 141, 1);
    sortLabel.textAlignment = NSTextAlignmentLeft;
    sortLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sortLabel];
    
    
    LeftIamge_Button *priceButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 2 + BothGap, 0, usedMulitipleWidth * 3, buttonHeight)];
    [priceButton setTitle:@"按价格" forState:UIControlStateNormal];
    [priceButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _priceButton = priceButton;
    [self.view addSubview:priceButton];
    
    LeftIamge_Button *yearButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 5 + BothGap, 0, usedMulitipleWidth * 3, buttonHeight)];
    [yearButton setTitle:@"按年份" forState:UIControlStateNormal];
    [yearButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _yearButton = yearButton;
    [self.view addSubview:yearButton];
    
    LeftIamge_Button *muliButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 8 + BothGap, 0, usedMulitipleWidth * 3, buttonHeight)];
    [muliButton setTitle:@"按公里数" forState:UIControlStateNormal];
    [muliButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _muliButton = muliButton;
    [self.view addSubview:muliButton];
    
    
    
    ////
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,VIEW_H(muliButton), ViewScreen_Width, ViewScreen_Height - navHeight - buttonHeight)];
    tableView.backgroundColor = MeGlobalBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpGetCarList)];
}

#pragma mark -- buttonAction
- (void)sortSelectAction:(LeftIamge_Button *)sender
{
    
    
    if (sender == _priceButton) {
        
        [self upDownImage:_priceButton];
        
        if (_isSelectDown) {
            _searchOrder = 1;
        }else{
            _searchOrder = 2;
        }
        
        [_yearButton setSelected:NO];
        [_muliButton setSelected:NO];
        [_priceButton setSelected:YES];
        _tempSelectButton = _priceButton;
        
    }else if (sender == _yearButton){
        
        [self upDownImage:_yearButton];
        
        if (_isSelectDown) {
            _searchOrder = 3;
        }else{
            _searchOrder = 4;
        }
        
        [_priceButton setSelected:NO];
        [_muliButton setSelected:NO];
        [_yearButton setSelected:YES];
        _tempSelectButton = _yearButton;
        
    }else if (sender == _muliButton){
        
        [self upDownImage:_muliButton];
        
        if (_isSelectDown) {
            _searchOrder = 5;
        }else{
            _searchOrder = 6;
        }
        
        [_priceButton setSelected:NO];
        [_yearButton setSelected:NO];
        [_muliButton setSelected:YES];
        _tempSelectButton = _muliButton;
    }
    
    [self touchRefresh];
    
}

- (void)touchRefresh
{
    [_tableView.header beginRefreshing];
}


- (void)upDownImage:(LeftIamge_Button*)sender
{
    if (_tempSelectButton == sender) {
        if (_isSelectDown) {
            [sender chooseUpImage];
            _isSelectDown = NO;
            
        }else{
            [sender chooseDownImage];
            _isSelectDown = YES;
        }
    }else{
        _isSelectDown = YES;
        [sender chooseDownImage];
    }
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
    ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.carInfo = _carArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    return 5;
}


#pragma mark -- httpRequest
- (void)httpGetCarList
{
    NSString *order = [NSString stringWithFormat:@"%ld",(long)_searchOrder];
    if (_searchOrder == 0) {
        order = @"";
    }
    
    [RequestManager getCarListWithSeries:_ID pageIndex:@"" pageSize:@"" order:order Succeed:^(NSData *data) {
        
        
        [_tableView.header endRefreshing];
        
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *returnArray = returnDict[@"Data"];
        
       
        _carArray = [returnArray mutableCopy];
           
        

         [_tableView reloadData];
        [_tableView setContentOffset:CGPointZero];
        
    } failed:^(NSError *error) {
        
        [_tableView.header endRefreshing];
        
    }];
    
}


@end
