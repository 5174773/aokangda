//
//  TSEHotNewsViewController.m
//  XCAR
//
//  Created by Morris on 9/21/15.
//  Copyright (c) 2015 Samtse. All rights reserved.


#import "TSRecommendViewController.h"
#import "CacheTool.h"
#import "TSLatestCarNews.h"
#import "Public.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "TSAdvertisementNews.h"
#import "TSEHttpTool.h"
#import "TSEHomeViewNews.h"
#import "TSEXCARLoopView.h"
#import "TSCarDetailViewController.h"
#import "AppDelegate.h"
#import "TSOneTableViewCell.h"
#import "TSCarsTableViewCell.h"
#import "TSThreeTableViewCell.h"
#import "TSShipinTableViewCell.h"
#import "TSGetArticleDetailViewController.h"
#import "TSEWebViewController.h"


@interface TSRecommendViewController() <UITableViewDataSource, UITableViewDelegate,TSEXCARLoopViewDelegate,TSOneTableViewCellDelegate>

//新闻数组
@property (nonatomic,strong)NSMutableArray *latestNewsFrame;
@property (nonatomic, strong) NSMutableDictionary *paras;


//广告链接数组
@property (nonatomic, strong) NSArray *ADNewsArr;
//广告图片数组
@property (nonatomic, strong) NSMutableArray *ADimagesArr;
//新闻数组
@property (nonatomic,strong)NSMutableArray *RecommendArr;

@property (nonatomic, weak) TSEXCARLoopView *loopView;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int pagecount;

@property (nonatomic,strong) NSMutableArray *localNewsArray;  // 本地添加列表数据个数
@property (nonatomic,strong) NSMutableArray *localADArray;   // 本地广告数据
@end
@implementation TSRecommendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _pageSize=20;
    _pagecount=1;
    // 设置tableView
    [self setupTableView];
    // 下拉加载最新数据
    [self pullDownToRefreshLatestNews];
     //上拉加载更多数据
    [self pullUpToLoadMoreNews];

    // 获取轮播图片
    [self getSCrollerADViewImage];
}

#pragma mark - 刷新数据
/**
 *  下拉加载最新数据
 */
- (void)pullDownToRefreshLatestNews {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLatestNew)];
    // 设置header
    [self.tableView.header beginRefreshing];
}

/**
 *  上拉加载更多数据
 */
- (void)pullUpToLoadMoreNews {
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
     [weakSelf requestMoreLatestNews];
    }];
}

- (void)requestLatestNew {

    //从数据库获取数据
    NSArray *getArray = [CacheTool queryRecommendNewsDataHistory];
    if (getArray) {
        if (getArray.count > 0) {
           
            _localNewsArray = [TSEHomeViewNews objectArrayWithKeyValuesArray:getArray];
            
            // 创建frame模型对象
            NSMutableArray *newsArray = [NSMutableArray array];
            for (TSEHomeViewNews *news in _localNewsArray) {
                 [newsArray addObject:news];
            }
            self.latestNewsFrame = newsArray;
            [self.tableView reloadData];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }
    }
    else
    {
        //从网络获取数据
        [self requestHttpData];
    }

}

- (void)requestMoreLatestNews {
    // 每次刷新参数"pagecount"会动态加1
    _pagecount +=1;
    
    NSString *substring=[NSString stringWithFormat:@"/%d?pageSize=%d&token=%@", _pagecount, _pageSize, LATESTTOKEN];
    NSString *urlString = [kGetTuijianNewsURL stringByAppendingString:substring];

    [TSEHttpTool get:urlString params:nil success:^(id json) {
        NSArray *loc_array =[TSEHomeViewNews objectArrayWithKeyValuesArray:json[@"Data"][@"News"]];
        
        for (TSEHomeViewNews *news in loc_array) {
            [self.latestNewsFrame addObject:news];

        }
        // 刷新tableView
        [self.tableView reloadData];
        // 停止刷新
        [self.tableView.footer endRefreshing];

  
    }failure:^(NSError *error) {
        TSELog(@"fail------%@", error);
        [self.tableView.footer endRefreshing];
    }];

}


- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    // 设置tableView的额外滚动区域
    [tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, TableViewContentInset, 0.0)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:MeGlobalBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TSEXCARLoopView *loopView = [[TSEXCARLoopView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 432*PSDSCALE_Y)];
    loopView.delegate = self;
    self.tableView.tableHeaderView = loopView;
    self.loopView = loopView;
}

#pragma mark - Table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.latestNewsFrame.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSString *loc_imageType=nil;
    if (self.latestNewsFrame.count > indexPath.section) {
        TSEHomeViewNews *loc_object = [self.latestNewsFrame objectAtIndex:indexPath.section];
        loc_imageType = loc_object.ImageType;
        if ([loc_imageType isEqualToString:@"three"]) {
            // 1.创建TSThreeTableViewCell
            TSThreeTableViewCell *cell = [TSThreeTableViewCell ThreeTableViewCellWithTableView:tableView];
            // 2.设置cell的属性
            cell.tag=indexPath.section;
            cell.ThreeImageViewNews = self.latestNewsFrame[indexPath.section];
            return cell;
        }else
        if ([loc_imageType isEqualToString:@"car"]) {
            // 1.创建TSCarsTableViewCell
            TSCarsTableViewCell *cell = [TSCarsTableViewCell CarsTableViewCellWithTableView:tableView];
            // 2.设置cell的属性
            cell.CarsViewNews = self.latestNewsFrame[indexPath.section];
            return cell;
        }else
        if ([loc_imageType isEqualToString:@"shipin"]) {
            // 1.创建TSShipinTableViewCell
            TSShipinTableViewCell *cell = [TSShipinTableViewCell ShipinTableViewCellWithTableView:tableView];
            // 2.设置cell的属性
            cell.ShipinViewNews = self.latestNewsFrame[indexPath.section];
            return cell;
        }else{
            // 1.创建TSOneTableViewCell
            TSOneTableViewCell *cell = [TSOneTableViewCell OneTableViewCellWithTableView:tableView];
            // 2.设置cell的属性
            cell.delegate=self;
            cell.OneImageViewNews=self.latestNewsFrame[indexPath.section];
            return cell;
        }
        
 }
    
    return nil;


}
-(void)CollectBtnclick:(UIButton *)sender
{
     NSInteger rowIndex = [[self.tableView indexPathForCell:(TSOneTableViewCell *) [[sender  superview] superview]] row];
    NSLog(@"%d",rowIndex);
}
#pragma mark - Table view delegate methods
/**
 *  根据相应的数据设置cell的高度
 *
 *  @param indexPath cell的位置
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat loc_numer = 0;
    NSString *loc_imageType =nil;
    if (self.latestNewsFrame.count > indexPath.row) {
        TSEHomeViewNews *loc_object = [self.latestNewsFrame objectAtIndex:indexPath.section];
        loc_imageType = loc_object.ImageType;
        if ([loc_imageType isEqualToString:@"three"]) {
            loc_numer=409*PSDSCALE_Y;
        }else if ([loc_imageType isEqualToString:@"car"]) {
            loc_numer=317*PSDSCALE_Y;
        }
        else if ([loc_imageType isEqualToString:@"shipin"]) {
            loc_numer=778*PSDSCALE_Y;
        }else{
            loc_numer=778*PSDSCALE_Y;
        }
        
    }
    
    return loc_numer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10*PSDSCALE_Y;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*PSDSCALE_Y;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *loc_imageType=nil;
    if (self.latestNewsFrame.count > indexPath.section) {
        TSEHomeViewNews *loc_object = [self.latestNewsFrame objectAtIndex:indexPath.section];
        loc_imageType = loc_object.ImageType;
        if ([loc_imageType isEqualToString:@"three"]) {
            TSGetArticleDetailViewController *ArticleDetailVC = [[TSGetArticleDetailViewController alloc] init];
            ArticleDetailVC.ArticleID = loc_object.ID;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
            [nav pushViewController:ArticleDetailVC animated:YES];

        }else if ([loc_imageType isEqualToString:@"car"])
        {
            TSCarDetailViewController *CarDetailVC = [[TSCarDetailViewController alloc] init];
            CarDetailVC.CarID = loc_object.CarID;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
            [nav pushViewController:CarDetailVC animated:YES];
 
        }
        else if ([loc_imageType isEqualToString:@"shipin"])
        {
            TSEWebViewController *shiPinDetailVC = [[TSEWebViewController alloc] init];
            shiPinDetailVC.movieURL  = loc_object.ShipinUrl;
            shiPinDetailVC.Title   = loc_object.Title;
            shiPinDetailVC.AddTime = loc_object.AddTime;
            shiPinDetailVC.Author  = loc_object.Author;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
            [nav pushViewController:shiPinDetailVC animated:YES];
        }
        else
        {
            TSGetArticleDetailViewController *ArticleDetailVC = [[TSGetArticleDetailViewController alloc] init];
            ArticleDetailVC.ArticleID = loc_object.ID;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
            [nav pushViewController:ArticleDetailVC animated:YES];

        }
        
    }
}

#pragma mark -请求网络数据
-(void)requestHttpData
{
    self.ADNewsArr = [NSMutableArray array];
    NSString *substring=[NSString stringWithFormat:@"/%d?pageSize=%d&token=%@", _pagecount, _pageSize, LATESTTOKEN];
    NSString *urlString = [kGetTuijianNewsURL stringByAppendingString:substring];
    [TSEHttpTool get:urlString params:nil success:^(id json) {
    
        //保存本地数据库
        [CacheTool updateRecommendNewsCacheDataHistory:json[@"Data"][@"News"]];
        //获取推荐页面数据
        NSArray *loc_array =[TSEHomeViewNews objectArrayWithKeyValuesArray:json[@"Data"][@"News"]];
        
        self.latestNewsFrame = [NSMutableArray arrayWithArray:loc_array];
        
        // 刷新tableView
        [self.tableView reloadData];
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        TSELog(@"error-------/n%@", error);
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    }];
    
}


/**
 *  设置tableHeaderView
 *
 *  @param focusNewsArr 装有TSELatestFocusNews模型的广告数组
 */

#pragma mark -获取视频页面广告图
-(void)getSCrollerADViewImage
{
    NSArray *getArray = [CacheTool queryADCacheDataHistory];
    if (getArray) {
        if (getArray.count > 0) {
            self.localADArray = [TSAdvertisementNews objectArrayWithKeyValuesArray:getArray[3][@"Ad"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:self.localADArray];
            
            [self.tableView reloadData];
        }
    }else
    {
        //从网络获取
        [TSEHttpTool get:kGetChannelNewsURL params:nil success:^(id json) {
            
            //获取广告图片
            self.ADNewsArr =[TSAdvertisementNews objectArrayWithKeyValuesArray:json[@"Data"][@"Default"][3][@"Ad"]];
            
            //保存数据到本地数据库
            [CacheTool updateADCacheDataHistory:json[@"Data"][@"Default"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:self.ADNewsArr];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    }

    
}
/**
 *  设置tableHeaderView
 *
 *
 */
- (void)setupTableHeaderViewWithFocusNews:(NSArray *)ADNews {
    
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.ADimagesArr = [NSMutableArray array];
        for (TSAdvertisementNews *news in ADNews) {
            NSString *urlStr = news.ImageUrl;
            NSURL *imageUrl = [NSURL URLWithString:urlStr];
//            UIImageView sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            [self.ADimagesArr addObject:image];
        }
        
        // 当图片下载完成后，在主线程设置tableHeaderView的数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.loopView setLoopViewImages:self.ADimagesArr autoPlay:YES delay:3.0];
        });
    });
}
@end
