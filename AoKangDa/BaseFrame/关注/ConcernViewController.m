//
//  ConcernViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "ConcernViewController.h"

#import "Public.h"
#import "ConcernOnSoldTableViewCell.h"
#import "BrandSelectViewController.h"
#import "SBShowTableView.h"
#import "ConcernSelectView.h"
#import "AppDelegate.h"
#import "CacheTool.h"
#import "UIImageView+WebCache.h"

#import "ConcernSubView.h"

#define ConcernButtonTag  1000
#define HelpButtonTag     1001

#define ConcernSelectViewStartTag  2100
#define HelpMeTableviewCellGap  5

#define SelectView_Color    RGBACOLOR(237, 243, 244, 1)




@interface ConcernViewController ()<UITableViewDataSource,UITableViewDelegate,ConcernSelectViewDelegate,BrandSelectViewControllerDelegate,SBShowTableViewDelegate>

@property (nonatomic,strong) UIButton *concernButton;
@property (nonatomic,strong) UIButton *helpMeButton;

@property (nonatomic,strong) UITableView *concernTableView;
@property (nonatomic,strong) UITableView *helpMeTableView;

@property (nonatomic,strong) NSMutableArray *concernArray;


@property (nonatomic,strong) NSMutableArray *carSeriesArray;
@property (nonatomic,strong) NSMutableArray *carStypeArray;


@property (nonatomic,copy) NSString *carStyleID;          //车型ID
@property (nonatomic,strong) NSDictionary *carbrandDict;  //品牌数据
@property (nonatomic,strong) NSMutableArray *localAddArray;  // 本地添加数据个数


@property (nonatomic,assign) NSInteger sbShowSort;


@end

@implementation ConcernViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStatusBlackBackground];
    
    _sbShowSort = 0;
    _concernArray = [NSMutableArray new];
    _carSeriesArray = [NSMutableArray new];
    _carStypeArray = [NSMutableArray new];
    _localAddArray = [NSMutableArray new];
    
    [self createUI];
    
    [_concernButton setSelected:YES];
    
    
    NSArray *getArray = [CacheTool queryConcernHelpMe];
    if (getArray) {
        if (getArray.count > 0) {
            _localAddArray = [getArray mutableCopy];
            MMLog(@"local   %@",_localAddArray);
            
            NSMutableArray *mutArray = [NSMutableArray new];
            for (NSDictionary *dict in _localAddArray) {
                [mutArray addObject:VALUEFORKEY(dict, @"ID")];
            }
            
            [self getCustomFoucusListWith:mutArray];
            
            [_helpMeTableView reloadData];
        }
    }
    
    [self concernOnSoldHttp];
}


- (void)createUI
{
    
    ///
    self.view.backgroundColor = MeGlobalBackgroundColor;
    
    ///
    UIButton *concernButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width * 0.5, ButtonGlobalHeight)];
    concernButton.tag = ConcernButtonTag;
    [concernButton setTitleColor:MeNorMalFontColor forState:UIControlStateNormal];
    [concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [concernButton setBackgroundImage:[UIImage imageNamed:@"Concern_ButtonNormal"] forState:UIControlStateNormal];
    [concernButton setBackgroundImage:[UIImage imageNamed:@"Concer_ButtonSelected"] forState:UIControlStateSelected];
    [concernButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [concernButton setTitle:@"关注在售车型" forState:UIControlStateNormal];
    concernButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _concernButton = concernButton;
    
    UIButton *helpMeButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewScreen_Width * 0.5, 0, ViewScreen_Width * 0.5, ButtonGlobalHeight)];
    helpMeButton.tag = HelpButtonTag;
    [helpMeButton addTarget:self action:@selector(modelSelected:) forControlEvents:UIControlEventTouchUpInside];
    [helpMeButton setTitleColor:MeNorMalFontColor forState:UIControlStateNormal];
    [helpMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [helpMeButton setBackgroundImage:[UIImage imageNamed:@"Concern_ButtonNormal"] forState:UIControlStateNormal];
    [helpMeButton setBackgroundImage:[UIImage imageNamed:@"Concer_ButtonSelected"] forState:UIControlStateSelected];
    [helpMeButton setTitle:@"帮我找车" forState:UIControlStateNormal];
    helpMeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _helpMeButton = helpMeButton;
    
    
    [self.view addSubview:concernButton];
    [self.view addSubview:helpMeButton];
    
    
    [self createOnSoldView];
    [self createHelpMeView];
}

- (void)createOnSoldView
{
    //
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    UITableView *concernTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ButtonGlobalHeight + 5, ViewScreen_Width, ViewScreen_Height - ButtonGlobalHeight - 64 - 25)];
    concernTableView.dataSource = self;
    concernTableView.delegate = self;
    concernTableView.backgroundColor = MeGlobalBackgroundColor;
    concernTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _concernTableView = concernTableView;
    [self.view addSubview:concernTableView];
}


- (void)createHelpMeView
{
    
    float startY = 0;
    float selectViewHeight = ButtonGlobalHeight + 12;
    
    
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    ///
    UITableView *helpMeTableView = [[UITableView alloc]init];
    helpMeTableView.frame = CGRectMake(0, VIEW_H(_concernButton), ViewScreen_Width, ViewScreen_Height - ButtonGlobalHeight - 64 - 25);
    helpMeTableView.dataSource = self;
    helpMeTableView.delegate = self;
    helpMeTableView.backgroundColor = MeGlobalBackgroundColor;
    helpMeTableView.hidden = YES;
    helpMeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _helpMeTableView = helpMeTableView;
    [self.view addSubview:helpMeTableView];
    
    
    ///
    UILabel *tipLabelOne = [[UILabel alloc]initWithFrame:CGRectMake(0,startY, ViewScreen_Width, 18)];
    tipLabelOne.text = @"在这里添加您要寻找的意向车型";
    tipLabelOne.font = [UIFont systemFontOfSize:11];
    tipLabelOne.textColor = MeNorMalFontColor;
    tipLabelOne.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    tipLabelOne.textAlignment = NSTextAlignmentCenter;
    
    
    ///
    startY += VIEW_H(tipLabelOne);
    UILabel *tipLabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, 18)];
    tipLabelTwo.text = @"我们将会把此车型在上市的第一时间推送给您！";
    tipLabelTwo.font = [UIFont systemFontOfSize:11];
    tipLabelTwo.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    tipLabelTwo.textAlignment = NSTextAlignmentCenter;
    
    
    ///
    startY += VIEW_H(tipLabelTwo);
    ConcernSelectView *brandView = [[ConcernSelectView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, selectViewHeight)];
    brandView.tag = ConcernSelectViewStartTag + 1;
    brandView.delegate = self;
    brandView.name = @"品牌";
    
    ///
    startY += VIEW_H(brandView) + 0.5;
    ConcernSelectView *carSeriesView = [[ConcernSelectView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, selectViewHeight)];
    carSeriesView.tag = ConcernSelectViewStartTag + 2;
    carSeriesView.delegate = self;
    carSeriesView.name = @"车系";
    
    ///
    startY += VIEW_H(carSeriesView) + 0.5;
    ConcernSelectView *carTypeView = [[ConcernSelectView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, selectViewHeight)];
    carTypeView.tag = ConcernSelectViewStartTag + 3;
    carTypeView.delegate =self;
    carTypeView.name = @"车型";
    
    ///
    startY += VIEW_H(carTypeView) + 0.5;
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, selectViewHeight + 5)];
    addView.backgroundColor = SelectView_Color;
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(25,0.4 * (VIEW_H(addView) - ButtonGlobalHeight),ViewScreen_Width - 25 * 2, ButtonGlobalHeight)];
    [addButton setTitle:@"继续添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(localAdd) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"concern_cirlceColor"] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [addView addSubview:addButton];
    
    
    startY += VIEW_H(addView);
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, startY)];
    headerView.backgroundColor = MeGlobalBackgroundColor;
    
    [headerView addSubview:tipLabelOne];
    [headerView addSubview:tipLabelTwo];
    [headerView addSubview:brandView];
    [headerView addSubview:carSeriesView];
    [headerView addSubview:carTypeView];
    [headerView addSubview:addView];
    
    
    helpMeTableView.tableHeaderView = headerView;
}


- (void)localAdd
{
    if (_carbrandDict) {
        
        if (_carStyleID && [Header formateString:_carStyleID].length != 0) {
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:_carbrandDict];
            [tempDict setObject:@"0" forKey:@"isAttached"];
            _carbrandDict = tempDict;
            
            [_localAddArray addObject:_carbrandDict];
            
            [CacheTool updateconcernHelpMeWithData:_localAddArray];
            
            [_helpMeTableView reloadData];
            
        }
    }
    
}

- (void)modelSelected:(UIButton *)sender
{
    if (sender == _concernButton) {
        if (!_concernButton.selected) {
            [_concernButton setSelected:YES];
            [_helpMeButton setSelected:NO];
        }
    }else if (sender == _helpMeButton){
        
        if (!_helpMeButton.selected) {
            [_concernButton setSelected:NO];
            [_helpMeButton setSelected:YES];
        }
    }
    
    if (_concernButton.selected) {
        _concernTableView.hidden = NO;
        _helpMeTableView.hidden = YES;
    }else{
        _concernTableView.hidden = YES;
        _helpMeTableView.hidden = NO;
    }
    
}


#pragma mark -- ConcernSelectViewDelegate
-(void)ConcernSelectViewtapAction:(ConcernSelectView *)concernSelectView
{
    if (concernSelectView.tag == ConcernSelectViewStartTag + 1) {
        
        BrandSelectViewController *brandVC = [[BrandSelectViewController alloc]init];
        brandVC.delegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
        [nav pushViewController:brandVC animated:YES];
        
    }else if (concernSelectView.tag == ConcernSelectViewStartTag + 2){
        
        if (_carSeriesArray.count > 0) {
            SBShowTableView *show = [[SBShowTableView alloc]initwithStartFrame:concernSelectView.frame];
            show.delegate = self;
            show.dataArray = _carSeriesArray;
            _sbShowSort = 1;
            [show show];
        }
        
        
    }else if (concernSelectView.tag == ConcernSelectViewStartTag + 3){
        if (_carStypeArray.count > 0) {
            SBShowTableView *show = [[SBShowTableView alloc]initwithStartFrame:concernSelectView.frame];
            show.dataArray = _carStypeArray;
            show.delegate = self;
            _sbShowSort = 2;
            [show show];
        }
        
    }
    
}

#pragma mark -- sbshowdelegate
-(void)SBShowTableViewSelect:(SBShowTableView *)sbShowTableView :(NSDictionary *)dictionary
{
    
    
    if (_sbShowSort == 1) {
        
        ConcernSelectView *brandView = [_helpMeTableView.tableHeaderView viewWithTag:ConcernSelectViewStartTag + 2];
        brandView.name = VALUEFORKEY(dictionary, @"Name");
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:_carbrandDict];
        [tempDict setObject:VALUEFORKEY(dictionary, @"Name") forKey:@"SeriesName"];
        _carbrandDict  = tempDict;
        
        [self getCarStyList:VALUEFORKEY(dictionary, @"ID")];
        
    }else if (_sbShowSort == 2){
        
        ConcernSelectView *brandView = [_helpMeTableView.tableHeaderView viewWithTag:ConcernSelectViewStartTag + 3];
        brandView.name = VALUEFORKEY(dictionary, @"Name");
        _carStyleID = VALUEFORKEY(dictionary, @"ID");
    }
}

#pragma mark -- BrandSelectViewControllerDelegate
-(void)BrandSelectViewSelect:(NSDictionary *)dictionary
{
    
    
    _carbrandDict = dictionary;
    
    ConcernSelectView *brandView = [_helpMeTableView.tableHeaderView viewWithTag:ConcernSelectViewStartTag + 1];
    brandView.name = VALUEFORKEY(dictionary, @"Name");
    
    
    [self getSeriesWith:VALUEFORKEY(dictionary, @"ID")];
}



#pragma mark -- tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _concernTableView) {
        return _concernArray.count;
    }else if (tableView == _helpMeTableView){
        
        return _localAddArray.count;
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellIdentifier = @"cell";
    
    if (tableView == _concernTableView) {
        
        ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.carInfo = _concernArray[indexPath.section];
        
        return cell;
    }
    else if (tableView == _helpMeTableView){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
            
            
            [self resetCell:cell];
            
        }
        
        UIView *view = [cell viewWithTag:6201];
        if (view) {
            [view removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = _localAddArray[indexPath.section];
        
        [(UIImageView*)([cell viewWithTag:8101]) sd_setImageWithURL:VALUEFORKEY(dict, @"Image") placeholderImage:[UIImage imageNamed:@"temp_logo"]];
        ((UILabel*)([cell viewWithTag:8102])).text = VALUEFORKEY(dict, @"Name");
        ((UILabel*)([cell viewWithTag:8103])).text = [NSString stringWithFormat:@"%@系 %@",VALUEFORKEY(dict,@"Letter"),VALUEFORKEY(dict, @"SeriesName")];
        
        
        if ([dict[@"isAttached"] isEqualToString:@"1"]) {
            
            NSArray *array = _localAddArray[indexPath.section][@"details"];
            
            ConcernSubView *subView = [[ConcernSubView alloc]initWithFrame:CGRectMake(0, HelpMeTableViewTopHeight, ViewScreen_Width, array.count * (ConcernTableViewHeight + 1)) dataArray:array];
            subView.tag = 6201;
            [cell addSubview:subView];
        }else{
            
            UIView *view = [cell viewWithTag:6201];
            if (view) {
                [view removeFromSuperview];
            }
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

#pragma mark -- talbeViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _concernTableView) {
        return 120;
    }else if (tableView == _helpMeTableView){
        
        NSDictionary *dict = _localAddArray[indexPath.section];
        
        
        if ([dict[@"isAttached"] isEqualToString:@"1"]) {
            
            NSArray *array = _localAddArray[indexPath.section][@"details"];
            
//            MMLog(@"%@",_localAddArray[indexPath.section]);
            
            return HelpMeTableViewTopHeight + (ConcernTableViewHeight + 1) * array.count;
            
        }else{
            return HelpMeTableViewTopHeight;
        }
    }
    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HelpMeTableviewCellGap;
}


- (void)resetCell:(UITableViewCell*)cell
{
    
    float lineBothGap = 8;
    float BothGap = 10;
    float newsGap = 25;
    float newsWidth = 117 * 0.5;
    float newsHeight = 35 * 0.5;
    
    ///
    UIImageView *logoImageView = [[UIImageView alloc]init];
    
    logoImageView.tag = 8101;
    logoImageView.frame = CGRectMake(BothGap, HelpMeTableViewTopHeight * 0.1,HelpMeTableViewTopHeight * 0.8,HelpMeTableViewTopHeight * 0.8);
    [cell addSubview:logoImageView];
    
    ///
    UIImageView *lineImageView = [[UIImageView alloc]init];
    lineImageView.image = [UIImage imageNamed:@"Concern_Line"];
    lineImageView.alpha = 0.6;
    lineImageView.frame = CGRectMake(VIEW_W_X(logoImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.25, 1, HelpMeTableViewTopHeight * 0.5);
    [cell addSubview:lineImageView];
    
    
    ///
    UIButton *newsImageView = [[UIButton alloc]init];
    [newsImageView setBackgroundImage:[UIImage imageNamed:@"Concern_Row"] forState:UIControlStateNormal];
    [newsImageView setTitle:@"NEW 5" forState:UIControlStateNormal];
    newsImageView.titleLabel.font = [UIFont systemFontOfSize:12];
    [newsImageView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newsImageView.userInteractionEnabled = NO;
    newsImageView.frame = CGRectMake(ViewScreen_Width - newsGap - newsWidth, (HelpMeTableViewTopHeight - newsHeight) * 0.5, newsWidth, newsHeight);
    [cell addSubview:newsImageView];
    
    ///
    float carLabelWidth = VIEW_W(cell) - VIEW_W_X(lineImageView) - VIEW_W(newsImageView) - newsGap - lineBothGap;
    
    UILabel *carLabel = [[UILabel alloc]init];
    //    carLabel.text = @"武林";
    carLabel.tag = 8102;
    carLabel.textAlignment = NSTextAlignmentLeft;
    carLabel.font = [UIFont systemFontOfSize:14];
    carLabel.textColor = MeNorMalFontColor;
    carLabel.frame = CGRectMake(VIEW_W_X(lineImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.1, carLabelWidth, HelpMeTableViewTopHeight * 0.4);
    [cell addSubview:carLabel];
    
    ///
    UILabel *carDecrLabel = [[UILabel alloc]init];
    //    carDecrLabel.text = @"福建省的雷锋精神的快乐";
    carDecrLabel.tag = 8103;
    carDecrLabel.textAlignment = NSTextAlignmentLeft;
    carDecrLabel.font = [UIFont systemFontOfSize:14];
    carDecrLabel.textColor = MeNorMalFontColor;
    carDecrLabel.frame = CGRectMake(VIEW_W_X(lineImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.5, carLabelWidth, HelpMeTableViewTopHeight * 0.4);
    [cell addSubview:carDecrLabel];
    
    
    UIButton *actionButton = [[UIButton alloc]init];
    [actionButton addTarget:self action:@selector(updownAction:) forControlEvents:UIControlEventTouchUpInside];
    actionButton.frame = CGRectMake(0, 0, VIEW_W(cell), HelpMeTableViewTopHeight);
    [cell addSubview:actionButton];
    
    UITableView *subTableView = [[UITableView alloc]init];
    subTableView.dataSource = self;
    subTableView.delegate = self;
    [cell addSubview:subTableView];
    
}

- (void)updownAction:(UIButton*)sender
{
    BOOL isHttpRequest = YES;
    
    UITableViewCell *cell = (UITableViewCell*)sender.superview;
    NSIndexPath *index = [_helpMeTableView indexPathForCell:cell];
    
    
    for (int i = 0; i < _localAddArray.count; i++) {
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:_localAddArray[i]];
        
        if (index.section == i) {
            
            if ([tempDict[@"isAttached"] isEqualToString:@"0"]) {
                [tempDict setObject:@"1" forKey:@"isAttached"];
            }else{
                [tempDict setObject:@"0" forKey:@"isAttached"];
                isHttpRequest = NO;
            }
            
        }else{
            [tempDict setObject:@"0" forKey:@"isAttached"];
            
        }
        
        [tempDict setObject:[NSMutableArray new] forKey:@"details"];
        _localAddArray[i] = tempDict;
    }
    
    
    if (isHttpRequest) {
        [self getCarListByUser:_localAddArray[index.section][@"ID"] indexPath:index];
    }else{
        [_helpMeTableView reloadData];
    }
    
    MMLog(@"%@",_localAddArray[index.section][@"Name"]);
}





#pragma mark -- httpRequest
- (void)concernOnSoldHttp
{
//    [RequestManager searchByWord:@"宝马" PageIndex:@"1" Brand:@"" Price:@"" Type:@"" Series:@"" Order:@"1" Succeed:^(NSData *data) {
//        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        if (returnDic) {
//            
//            
//            //            ///
//            //            NSArray *navArray = VALUEFORKEY(returnDic, @"Nav");
//            //            if (navArray) {
//            //                if (navArray.count > 0) {
//            //
//            //                }
//            //            }
//            //
//            //            ///
//            //            NSArray *cars = VALUEFORKEY(returnDic, @"Cars");
//            //            if (cars) {
//            //                if (cars.count > 0) {
//            //                    _concernArray = [cars mutableCopy];
//            //                    [_concernTableView reloadData];
//            //                }
//            //            }
//        }
//    } failed:^(NSError *error) {
//        
//    }];
}

- (void)getSeriesWith:(NSString*)ID
{
    [self showActityHoldView];
    __weak __typeof(self)weakSelf = self;
    [RequestManager getSeriesListWihtID:ID Succeed:^(NSData *data) {
        
        [self hiddenActityHoldView];
        
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *returnArray = returnDict[@"Data"];
        
        
        if (returnArray.count > 0) {
            
            
            _carSeriesArray = [returnArray mutableCopy];
            
            ConcernSelectView *brandView = [_helpMeTableView.tableHeaderView viewWithTag:ConcernSelectViewStartTag + 2];
            brandView.name = VALUEFORKEY(returnArray[0], @"Name");
            
            ///
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:_carbrandDict];
            [tempDict setObject:VALUEFORKEY(returnArray[0], @"Name") forKey:@"SeriesName"];
            _carbrandDict  = tempDict;
            
            ///
            [weakSelf getCarStyList:VALUEFORKEY(returnArray[0], @"ID")];
            
            
        }
    } failed:^(NSError *error) {
        [self hiddenActityHoldView];
    }];
}


- (void)getCarStyList:(NSString *)ID
{
    [self showActityHoldView];
    
    [RequestManager getCarStyleListWihtID:ID Succeed:^(NSData *data) {
        
        [self hiddenActityHoldView];
        
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *returnArray = returnDict[@"Data"];
        
        if (returnArray) {
            
            _carStypeArray = [returnArray mutableCopy];
            
            ConcernSelectView *brandView = [_helpMeTableView.tableHeaderView viewWithTag:ConcernSelectViewStartTag + 3];
            if (returnArray.count > 0) {
                
                brandView.name = VALUEFORKEY(returnArray[0], @"Name");
                _carStyleID = VALUEFORKEY(returnArray[0], @"ID");
            }else{
                brandView.name = @"";
                _carStyleID = @"";
            }
            
        }
    } failed:^(NSError *error) {
        [self hiddenActityHoldView];
    }];
}

- (void)getCarListByUser:(NSString *)ID indexPath:(NSIndexPath *)indexPath
{
    [self showActityHoldView];
    
    [RequestManager getCarListByUserWithID:ID Succeed:^(NSData *data) {
        
        [self hiddenActityHoldView];
        
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *returnArray = returnDict[@"Data"];
        
        [self helpMetableviewReload:indexPath dataArray:returnArray];
        
    } failed:^(NSError *error) {
        
       [self hiddenActityHoldView];
    }];
}

- (void)helpMetableviewReload:(NSIndexPath *)indexPath dataArray:(NSArray*)dataArray;
{
    
    
    for (int i = 0; i<_localAddArray.count; i++) {
        
        
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_localAddArray[i]];
        
        if (i == indexPath.section) {
            
            [mutDict setObject:dataArray forKey:@"details"];
        }else{
            [mutDict setObject:[NSMutableArray new] forKey:@"details"];
        }
        
        _localAddArray[i] = mutDict;
        
    }
    
    [_helpMeTableView reloadData];
    
    [_helpMeTableView setContentOffset:CGPointMake(0, indexPath.section * (HelpMeTableViewTopHeight + HelpMeTableviewCellGap)) animated:YES];
}


- (void)getCustomFoucusListWith:(NSArray*)dataArray
{
#warning -- 然并卵？
    [RequestManager getCustomFoucusListWithDataArray:dataArray Succeed:^(NSData *data) {
        
    } failed:^(NSError *error) {
        
    }];
}


@end
