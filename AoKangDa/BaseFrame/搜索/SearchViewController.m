//
//  SearchViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/8.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SearchViewController.h"

#import "SBShowTableView.h"
#import "Public.h"

#import "LeftIamge_Button.h"

#import "ConcernOnSoldTableViewCell.h"
#import "SBSearchBar.h"
#import "SearchHistoryTableViewCell.h"
#import "CacheTool.h"
#import "NavLeftImage_Button.h"


#define HistoryFont   15
#define BothGap  8
#define HistoryCellHeight  40
#define SBShowTag   66611

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,SearchHistoryTableViewCellDelegate,SBShowTableViewDelegate>

@property (nonatomic,strong) UITableView *searchTableView;


@property (nonatomic,strong) SBSearchBar *searchBar;      // 搜索框
//@property (nonatomic,assign) NSInteger pageIndex;         // 页码
@property (nonatomic,assign) NSInteger searchOrder;       // 排序
@property (nonatomic,strong) NSMutableArray *searchCars;  // 搜索到的车辆

@property (nonatomic,strong) UIScrollView *navScrollView;

@property (nonatomic,assign) BOOL isSelectDown;       // 记录向下还是向上
@property (nonatomic,strong) LeftIamge_Button *tempSelectButton;
@property (nonatomic,strong) LeftIamge_Button *priceButton;
@property (nonatomic,strong) LeftIamge_Button *yearButton;
@property (nonatomic,strong) LeftIamge_Button *muliButton;

@property (nonatomic,strong) UITableView *historyTableView;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,strong) NSArray *autoLinkArray;

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStatusBlackBackground];
    [self addBackButton:YES];

    
    /// 默认参数
    
//    _pageIndex = 1;
//    _searchOrder = 1;
    _searchCars = [NSMutableArray new];
    _historyArray = [NSMutableArray new];
    
    
    ///
    [self createUI];
    [self creatHistoryView];
    
    ///
//    _tempSelectButton = _priceButton;
//    _isSelectDown = YES;
//    [_priceButton chooseDownImage];
//    [_priceButton setSelected:YES];
    
    
    ///
    NSArray *getArray = [CacheTool querySearchHistory];
    if (getArray && getArray.count > 0) {
        _historyArray = [getArray mutableCopy];
        [_historyTableView reloadData];
        [_deleteButton setTitle:@"清除搜索历史纪录" forState:UIControlStateNormal];
        _deleteButton.userInteractionEnabled = YES;
    }
    
    ///
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearanceNotificaton:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardhiddenNotificaton:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if (view.tag == SearchBarTag) {
            [view removeFromSuperview];
        }
    }
}


- (void)keyboardAppearanceNotificaton:(NSNotification*)notification
{
    
    
    NSDictionary *keyboard_user_info = notification.userInfo;
    CGRect frame = [keyboard_user_info[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat height = frame.size.height;

    frame = _historyTableView.frame;
    frame.origin.y = 0;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - 64 - height;
    _historyTableView.frame = frame;
    
    _historyTableView.hidden = NO;
}

- (void)keyboardhiddenNotificaton:(NSNotification*)notification
{
    _historyTableView.hidden = YES;
    
//    CGRect frame = _historyTableView.frame;
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
//    _historyTableView.frame = frame;
}


- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTopView];
    
    float StartY = 0;
    float buttonHeight = 30;
    
    UIScrollView *navScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, StartY, ViewScreen_Width, 45)];
    navScrollView.contentSize = CGSizeMake(0, 0);
    navScrollView.showsHorizontalScrollIndicator = NO;
    navScrollView.showsVerticalScrollIndicator = NO;
    navScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_navBackground"]];
    _navScrollView = navScrollView;
    [self.view addSubview:navScrollView];
    
    
    ///下去在封装
    StartY += VIEW_H(navScrollView);
    float usedMulitipleWidth = (ViewScreen_Width - BothGap) / 11.0f;
    
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(BothGap, StartY, usedMulitipleWidth * 2, buttonHeight)];
    sortLabel.text = @"排列";
    sortLabel.backgroundColor = [UIColor whiteColor];
    sortLabel.textColor = RGBACOLOR(141, 141, 141, 1);
    sortLabel.font = [UIFont systemFontOfSize:15];
    sortLabel.textColor = [UIColor lightGrayColor];
    sortLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sortLabel];
    

    LeftIamge_Button *priceButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 2 + BothGap, StartY, usedMulitipleWidth * 3, buttonHeight)];
    [priceButton setTitle:@"按价格" forState:UIControlStateNormal];
    [priceButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _priceButton = priceButton;
    [self.view addSubview:priceButton];
    
    LeftIamge_Button *yearButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 5 + BothGap, StartY, usedMulitipleWidth * 3, buttonHeight)];
    [yearButton setTitle:@"按年份" forState:UIControlStateNormal];
    [yearButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _yearButton = yearButton;
    [self.view addSubview:yearButton];
    
    LeftIamge_Button *muliButton = [[LeftIamge_Button alloc]initWithFrame:CGRectMake(usedMulitipleWidth * 8 + BothGap, StartY, usedMulitipleWidth * 3, buttonHeight)];
    [muliButton setTitle:@"按公里数" forState:UIControlStateNormal];
    [muliButton addTarget:self action:@selector(sortSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    _muliButton = muliButton;
    [self.view addSubview:muliButton];
    
    
    ///
    StartY += VIEW_H(sortLabel);
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    UITableView *searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StartY, ViewScreen_Width, ViewScreen_Height - StartY - navHeight)];
    searchTableView.backgroundColor = MeGlobalBackgroundColor;
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView = searchTableView;
    [self.view addSubview:searchTableView];
}


- (void)createTopView
{
    
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(44, 0, ViewScreen_Width - 44, self.navigationController.navigationBar.frame.size.height)];
    backView.tag = SearchBarTag;
//    backView.backgroundColor = RGBACOLOR(20, 153, 231, 1);
    [self.navigationController.navigationBar addSubview:backView];
    
    
    float barHeight = self.navigationController.navigationBar.frame.size.height;
    float searchBarHeight = 36;
    float StartY = (barHeight - searchBarHeight) * 0.5;
    float sureCancelButtonWidth = 50;
    
    ///
    UIButton *sureCancelButton = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_W(backView) - BothGap - sureCancelButtonWidth, StartY, sureCancelButtonWidth, searchBarHeight)];
    [sureCancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    [sureCancelButton setTitleColor:MeDefine_Color forState:UIControlStateNormal];
    [sureCancelButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureCancelButton];
    
    ///
    SBSearchBar *searchBar = [[SBSearchBar alloc]initWithFrame:CGRectMake(0, StartY, VIEW_W(backView) - BothGap - sureCancelButtonWidth, searchBarHeight)];
    [searchBar addTarget:self action:@selector(changeWord:) forControlEvents:UIControlEventEditingChanged];
//     [searchBar addTarget:self action:@selector(changeWord:) forControlEvents:UIControlEventEditingDidBegin];
    [backView addSubview:searchBar];
    _searchBar = searchBar;
    
}


- (void)changeWord:(UITextField*)sender
{
    
    MMLog(@"UUUUUU");
    
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == SBShowTag) {
            if ([view isKindOfClass:[SBShowTableView class]]) {
             
                [view removeFromSuperview];
            }
        }
    }

    [self autoLinkSearch];
}

- (void)search:(UIButton*)sender
{
    [_searchBar resignFirstResponder];
    
    if (_searchBar.text.length > 0) {
        [self addHistoryWithString:_searchBar.text];
        [self searchByword];
    }
    
}


- (void)addHistoryWithString:(NSString*)string
{
    if (string.length > 0) {
        NSArray *getArray = [CacheTool updateSearchHistoryWithString:string];
        _historyArray = [getArray mutableCopy];
        [_historyTableView reloadData];
        if (getArray.count > 0) {
            [_deleteButton setTitle:@"清除搜索历史纪录" forState:UIControlStateNormal];
            _deleteButton.userInteractionEnabled = YES;
        }else{
            [_deleteButton setTitle:@"当前无搜索历史纪录" forState:UIControlStateNormal];
            _deleteButton.userInteractionEnabled = NO;
        }
        
    }
}



/// UI
- (void)creatHistoryView
{
    // 不知道为何，封装不了
    float navHeight = 0;
    if (!self.navigationController.navigationBarHidden) {
        navHeight = 64;
    }
    
    ///
    UITableView *historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ViewScreen_Width, ViewScreen_Height  - navHeight)];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView = historyTableView;
    _historyTableView.hidden = YES;
    [self.view addSubview:historyTableView];
    
    ///
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, HistoryCellHeight)];
    titleLabel.text = @"搜索历史";
    titleLabel.font = [UIFont systemFontOfSize:HistoryFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    historyTableView.tableHeaderView = titleLabel;
    

    
    ///
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, HistoryCellHeight)];
    footerView.backgroundColor = RGBACOLOR(237, 243, 244, 1);
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake((ViewScreen_Width - 240) * 0.5, 0, 240, HistoryCellHeight + 5)];
    [deleteButton setTitle:@"当前无搜索历史纪录" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:HistoryFont];
    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAllHistory) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.userInteractionEnabled = NO;
    _deleteButton = deleteButton;
    [footerView addSubview:deleteButton];
    
    historyTableView.tableFooterView = footerView;
}


- (void)deleteAllHistory
{
    NSArray *getArray = [CacheTool deleteAllHistory];
    _historyArray = [getArray mutableCopy];
    [_historyTableView reloadData];
    if (getArray == nil || getArray.count == 0) {
        [_deleteButton setTitle:@"当前无搜索历史纪录" forState:UIControlStateNormal];
        _deleteButton.userInteractionEnabled = NO;
    }
    
}


#pragma mark -- buttonAction
- (void)sortSelectAction:(LeftIamge_Button *)sender
{
    [_searchBar resignFirstResponder];
    
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
    
    if (_searchBar.text.length > 0) {
        [self searchByword];
    }
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

- (void)backButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- SBShowTableViewDelegate
-(void)SBShowTableViewSelectString:(SBShowTableView *)sbShowTableView :(NSString *)string
{
    [_searchBar resignFirstResponder];
    _searchBar.text = string;
    [self searchByword];
    [self addHistoryWithString:_searchBar.text];
}

#pragma mark -- tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    
    if (tableView == _searchTableView) {
        count = _searchCars.count;
    }else if(tableView == _historyTableView)
    {
        count = _historyArray.count;
    }
    
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _searchTableView) {
        ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.carInfo = _searchCars[indexPath.section];
        
        return cell;
    }else{
     
        SearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[SearchHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = _historyArray[indexPath.section];
        
        return cell;
    }
}


#pragma mark -- tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _searchBar.text = _historyArray[indexPath.section];
    [self addHistoryWithString:_historyArray[indexPath.section]];
    [self searchByword];
    [_searchBar resignFirstResponder];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (tableView == _searchTableView) {
        height = ConcernTableViewHeight;
    }else if (tableView == _historyTableView){
        height = HistoryCellHeight;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat gap = 0;
    if (tableView == _searchTableView) {
        gap = 5;
    }else if (tableView == _historyTableView){
        gap = 1;
    }
    return gap;
}


#pragma mark -- SearchHistoryTableViewCellDelegate
-(void)SearchHistoryTableViewCellSelect:(NSString *)selectString
{
   NSArray *getArray = [CacheTool deleteHistoryWith:selectString];
    _historyArray = [getArray mutableCopy];
    [_historyTableView reloadData];
    
    if (getArray == nil || getArray.count == 0) {
        [_deleteButton setTitle:@"当前无搜索历史纪录" forState:UIControlStateNormal];
        _deleteButton.userInteractionEnabled = NO;
    }
}


#pragma mark -- httpRequest
- (void)autoLinkSearch
{
    
    [RequestManager autoLinkSearchByWord:_searchBar.text Succeed:^(NSData *data) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (returnDic) {
            NSArray *array = returnDic[@"Data"];
            _autoLinkArray = array;
            
/// 请求移步
            if (_autoLinkArray.count > 0) {
                
                if (![self judgeBeHave]) {
                    SBShowTableView *show = [[SBShowTableView alloc]initwithStartFrame:CGRectMake(VIEW_X(_searchBar.superview), 0, VIEW_W(_searchBar), 100)];
                    show.tag = SBShowTag;
                    show.flag = 3;
                    show.delegate = self;
                    show.dataArray = _autoLinkArray;
                    [show show];
                }
            }
            
            
            
        }
    } failed:^(NSError *error) {
        
    }];
}


- (BOOL)judgeBeHave
{
    BOOL beHave = NO;
   
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == SBShowTag) {
            if ([view isKindOfClass:[SBShowTableView class]]) {
                
                beHave = YES;
            }
        }
    }
    
    return beHave;
}

- (void)searchByword
{
    [_searchCars removeAllObjects];
    
    [self showActityHoldView];
    
    
    NSString *order = [NSString stringWithFormat:@"%ld",(long)_searchOrder];
    if (_searchOrder == 0) {
        order = @"";
    }
    
    
    [RequestManager searchByWord:_searchBar.text PageIndex:@"" Brand:@"" Price:@"" Type:@"" Series:@"" Order:order pageSize:@"" Succeed:^(NSData *data) {
        
        [self hiddenActityHoldView];
        
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (returnDic) {
            returnDic = returnDic[@"Data"];
//            MMLog(@"searchByWord  %@",returnDic);
            
            [self resetNavScrollView:returnDic[@"Nav"]];
            
            ///
            NSArray *navArray = VALUEFORKEY(returnDic, @"Nav");
            if (navArray) {
                if (navArray.count > 0) {
                    
                }
            }
            
            ///
            NSArray *cars = VALUEFORKEY(returnDic, @"Cars");
           
                
            _searchCars = [cars mutableCopy];
                
            
        }
        
        [_searchTableView reloadData];
        [_searchTableView setContentOffset:CGPointZero];
        
    } failed:^(NSError *error) {
        
         [self hiddenActityHoldView];
        
    }];
}


- (void)resetNavScrollView:(NSArray*)dataArray
{
    for (UIView *view in _navScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    
    float buttonWidth = 80;
    
    for (int i = 0; i<dataArray.count; i++) {
        
        
        NavLeftImage_Button *button = [[NavLeftImage_Button alloc]initWithFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, VIEW_H(_navScrollView))];
        button.backgroundColor = RGBACOLOR(190, 75, 20, 1);
        [button setTitle:VALUEFORKEY(dataArray[i], @"Text") forState:UIControlStateNormal];
        [_navScrollView addSubview:button];
        
        if (i == 0) {
            [button setBackgroundImage:[UIImage imageNamed:@"search_navFirst"] forState:UIControlStateNormal];
        }else{
             [button setBackgroundImage:[UIImage imageNamed:@"search_navOther"] forState:UIControlStateNormal];
        }
    }
    
    _navScrollView.contentSize = CGSizeMake(dataArray.count * buttonWidth, 0);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
