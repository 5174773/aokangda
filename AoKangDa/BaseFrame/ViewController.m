//
//  ViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "ViewController.h"
#import "WMPageController.h"
#import "WMHomeViewController.h"
#import "WMMenuViewController.h"
#import "WMOtherViewController.h"
#import "WMNavigationController.h"
#import "SearchViewController.h"
#import "WMCommon.h"
//子控制器
#import "MoreCouponViewController.h"
#import "CarContrastViewController.h"
#import "DeputyClaimsViewController.h"
#import "SystemMessageViewController.h"
#import "PersonalSettingsViewController.h"
#import "AppointmentMaintainViewController.h"
//子标题
//五个固定标题
#import "TSVideoViewController.h"
#import "TSRecommendViewController.h"
#import "TSCarSalesViewController.h"
#import "TSLatestNewsViewController.h"
#import "TSAttentionViewController.h"
#import "TSOtherMoreViewController.h"
#import "PriceChannelViewController.h"
#import "ConcernViewController.h"
#import "CarBrandViewController.h"

#import "AppDelegate.h"
#import "CacheTool.h"
#import "Public.h"


typedef enum state {
    kStateHome,
    kStateMenu
}state;

static const CGFloat viewSlideHorizonRatio = 0.6;
static const CGFloat viewHeightNarrowRatio = 0.9;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface ViewController () < WMMenuViewControllerDelegate>
{
    NSMutableArray *titleArray;
}
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值

@property (strong, nonatomic) UIView                 *cover;
@property (strong, nonatomic) WMCommon               *common;
@property (strong, nonatomic) WMMenuViewController   *menuVC;
@property (strong, nonatomic) WMPageController       *pageVC;
@property (strong, nonatomic) SearchViewController *SearchVC;
@property (nonatomic,strong) NSArray *getChannels;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addStatusBlackBackground];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Car_logo"]];
    titleArray = [NSMutableArray arrayWithObjects:
                 @"推荐",@"最新",@"视频",@"卖车",@"关注",nil];
    
    self.common = [WMCommon getInstance];
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = self.common.screenW * menuStartNarrowRatio / 2.0;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = self.common.screenW * viewSlideHorizonRatio;
    
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    bg.frame        = [[UIScreen mainScreen] bounds];
    [self.view addSubview:bg];
    
    // 设置menu的view
    // 设置menu的view
    self.menuVC = [[WMMenuViewController alloc] init];
    self.menuVC.delegate = self;
    // 用于实现 cell 的点击事件
    self.menuVC.view.frame = [[UIScreen mainScreen] bounds];
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart, self.menuVC.view.center.y);
    [self.view addSubview:self.menuVC.view];
    
    // 设置控制器的状态，添加手势操作
    [self p_defaultController];
    [self channelChange];
    
    
    ///
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelChange) name:ChannelAddNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelChange) name:ChannelDeleteNotification object:nil];
}


- (void)channelChange
{
    NSArray *getChannels = [CacheTool getChannels];
    _getChannels = getChannels;
    
    
    ///
    for (NSDictionary *dict in getChannels) {
        
        if (![self judegeBeHaveWith:VALUEFORKEY(dict, @"Text")]) {
            [titleArray addObject:VALUEFORKEY(dict, @"Text")];
        }
    }
    
    
    
    ///
    NSDictionary *getDict = [self regroundViewController];
    NSArray *viewControllers = getDict[@"viewcontroller"];
    NSArray *titles = getDict[@"titles"];
    
    
    _pageVC.titles = titles;
    _pageVC.viewControllerClasses = viewControllers;
    
    //[_pageVC reloadData];
}

- (BOOL)judegeBeHaveWith:(NSString*)title
{
    BOOL beHave = NO;
    
    for (NSString *subTitle in titleArray) {
        if ([title isEqualToString:subTitle]) {
            beHave = YES;
            return beHave;
        }
    }
    
    return beHave;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated
{
    //导航栏返回按钮
    [self addBackButton];
    [self addRightButton];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

//导航栏返回按钮
- (void)addBackButton{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [leftButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [leftButton setTitle:nil forState:UIControlStateNormal];
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    leftButton.enabled=NO;
//    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

//导航栏右侧按钮
- (void)addRightButton{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
/**
 *  进入搜索
 */
- (void)rightButtonClick
{
    SearchViewController *SearchVC=[[SearchViewController alloc]init];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
    [nav pushViewController:SearchVC animated:YES];
    
}

/**
 *  设置statusbar的状态
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
// 处理拖动事件
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 当滑动水平 X 大于 75 时禁止滑动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
        // 手势在当前视图中的位置
    }
    if (self.sta == kStateHome && self.panStartX >= 75) {
        return;
    }
    
    CGFloat x = [recognizer translationInView:self.view].x;
    // 手势在当前视图中移动有范围
    
    // 禁止在主界面的时候向左滑动
    if (self.sta == kStateHome && x < 0) {
        return;
    }
    
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= self.common.screenW * viewSlideHorizonRatio / 2.0) {
            
            [self showMenu];
        } else {
            [self showHome];
        }
        return;
    }
    
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    
    // 手势还在移动时，以下数据持续发生变化
    //    self.homeVC.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    //    self.homeVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    self.pageVC.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y-64);
    self.pageVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVC.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y-64);
    self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
}

// 展示侧边栏
- (void)showMenu {
    [self.pageVC.view bringSubviewToFront:self.cover];
    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:viewHeightNarrowRatio];
}
// 展示主界面
- (void)showHome {
    [self.pageVC.view sendSubviewToBack:self.cover];
    self.distance = 0;
    self.sta = kStateHome;
    [self doSlide:1];
}
// 实施自动滑动，proportion 滑动比例
- (void)doSlide:(CGFloat)proportion {
    // 手势终止时，自动执行动画效果
    [UIView animateWithDuration:0.3 animations:^{
        self.pageVC.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y-64);
        self.pageVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;
        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
        }
        self.menuVC.view.center = CGPointMake(menuCenterX, self.view.center.y-84);
        self.menuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - WMHomeViewController代理方法
- (void)leftBtnClicked {
    if (self.sta == kStateHome) {
        [self showMenu];
    }else{
        [self showHome];
    }
}

#pragma mark - WMMenuViewController代理方法
- (void)didSelectItem:(NSString *)title Tag:(NSInteger)tag{
    
    CarContrastViewController *CarVC=[[CarContrastViewController alloc]init];
    MoreCouponViewController *MoreCouponVC=[[MoreCouponViewController alloc]init];
    SystemMessageViewController *sysytemVC=[[SystemMessageViewController alloc]init];
    DeputyClaimsViewController *DeputyClaimsVC=[[DeputyClaimsViewController alloc]init];
    PersonalSettingsViewController *SettingVC=[[PersonalSettingsViewController alloc]init];
    AppointmentMaintainViewController *AppointmentMaintainVC=[[AppointmentMaintainViewController alloc]init];
    switch (tag) {
        case 0:
            sysytemVC.title=title;
            [self.navigationController pushViewController:sysytemVC animated:NO];
            NSLog(@"系统消息");
            break;
        case 1:
            CarVC.title=title;
            [self.navigationController pushViewController:CarVC animated:NO];
            NSLog(@"车型对比");
            break;
        case 2:
            MoreCouponVC.title=title;
            [self.navigationController pushViewController:MoreCouponVC animated:NO];
            NSLog(@"卡券包");
            break;
        case 3:
            AppointmentMaintainVC.title=title;
            [self.navigationController pushViewController:AppointmentMaintainVC animated:NO];
            NSLog(@"预约保养");
            break;
        case 4:
            DeputyClaimsVC.title=title;
            [self.navigationController pushViewController:DeputyClaimsVC animated:NO];
            NSLog(@"帮办理赔");
            break;
        case 5:
            SettingVC.title=title;
            [self.navigationController pushViewController:SettingVC animated:NO];
            NSLog(@"设置");
            break;
        default:
            break;
    }
}


- (NSDictionary*)regroundViewController
{
    
    NSMutableArray *tempViewController = [NSMutableArray new];
    NSMutableArray *tempTitles = [NSMutableArray new];
    
    for (int i = 0; i < titleArray.count; i++) {
        
       
        NSString *subTitle = titleArray[i];
        
        if ([subTitle isEqualToString:@"推荐"]) {
            
            [tempViewController addObject:[TSRecommendViewController class]];
            [tempTitles addObject:subTitle];
            
        }else if ([subTitle isEqualToString:@"最新"]){
            
            [tempViewController addObject:[TSLatestNewsViewController class]];
            [tempTitles addObject:subTitle];
            
        }else if ([subTitle isEqualToString:@"视频"]){
            
            [tempViewController addObject:[TSVideoViewController class]];
            [tempTitles addObject:subTitle];
            
        }else if ([subTitle isEqualToString:@"卖车"]){
            
            [tempViewController addObject:[TSCarSalesViewController class]];
            [tempTitles addObject:subTitle];
            
        }else if ([subTitle isEqualToString:@"关注"]){
          
            [tempViewController addObject:[ConcernViewController class]];
            [tempTitles addObject:subTitle];
            
        }else{
            
            if (_getChannels.count > 0) {
                
                for (NSDictionary *dict in _getChannels) {
                    if ([VALUEFORKEY(dict, @"Text") isEqualToString:subTitle]) {
                        
                        NSString *type = VALUEFORKEY(dict, @"Type");
                        if ([type isEqualToString:@"leixing"]) {
                            
                            [tempViewController addObject:[CarBrandViewController class]];
                            [tempTitles addObject:subTitle];
                            break;
                        }else if([type isEqualToString:@"jiage"]){
                            
                            [tempViewController addObject:[PriceChannelViewController class]];
                            [tempTitles addObject:subTitle];
                            break;
                        }else if ([type isEqualToString:@"pinpai"]){
                            
                            [tempViewController addObject:[CarBrandViewController class]];
                            [tempTitles addObject:subTitle];
                            break;
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    NSDictionary *tempDict = @{@"viewcontroller":tempViewController,@"titles":tempTitles};
    
    return tempDict;
}



#pragma mark -WMPageController
- (void)p_defaultController {

    NSDictionary *getDict = [self regroundViewController];
    NSArray *viewControllers = getDict[@"viewcontroller"];
    NSArray *titles = getDict[@"titles"];
    
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    self.pageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    pageVC.pageAnimatable = YES;
    pageVC.bounces = YES;
    //每个 MenuItem 的宽度
    pageVC.menuItemWidth=SCREEN_WIDTH/6.5;
    //滚动视图的高度
    pageVC.menuHeight= 40;
    pageVC.postNotification = YES;
    pageVC.menuViewStyle = WMMenuViewStyleDefault;
    pageVC.titleColorNormal =[UIColor blackColor];
    pageVC.titleColorSelected =[UIColor orangeColor];
    self.pageVC = pageVC;
    // 添加覆盖
    self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.cover.backgroundColor = [UIColor clearColor];
    [self.pageVC.view addSubview:self.cover];
    
   UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    // 添加手势，用于左拉出抽屉效果
    //    [self.homeVC.view addGestureRecognizer:pan];
    //    [self.view addSubview:self.homeVC.view];
    
    [self.cover addGestureRecognizer:pan];
    [self.pageVC.view sendSubviewToBack:self.cover];
    
    
    [self.view addSubview:self.pageVC.view];
}
@end
