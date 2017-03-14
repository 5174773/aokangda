//
//  TSEVideoViewController.m
//  XCAR
//
//  Created by Morris on 9/21/15.
//  Copyright (c) 2015 Samtse. All rights reserved.
//
#import "TSLatestNewsViewController.h"
#import "TSVideoViewController.h"
#import "TSEWebViewController.h"
#import "TSEBarButtonItem.h"
#import "TSEXCARLoopView.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#import "TSCarNews.h"
#import "TSEHttpTool.h"
#import "TSAdvertisementNews.h"
#import "TSVideoTableViewCell.h"
#import "TSCarTableViewCellFrame.h"
#import "CacheTool.h"
#import "AppDelegate.h"
#import "Public.h"


@interface TSVideoViewController () <UITableViewDataSource, UITableViewDelegate,TSEXCARLoopViewDelegate>

@property (nonatomic, strong) NSMutableArray *videoNewsFrame;
@property (nonatomic, strong) NSMutableDictionary *paras;
@property (nonatomic, strong) NSArray *videoNews;
//广告数组
@property (nonatomic, strong) NSArray *ADImage;
//广告图片
@property (nonatomic, strong) NSMutableArray *imgsArr;
//测试图片
@property (nonatomic, strong) NSArray *imagesArr;

@property (nonatomic, weak) TSEXCARLoopView *loopView;
@property (nonatomic, weak) TSVideoViewController *webVC;
@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) int pagecount;
@property (nonatomic,strong) NSMutableArray *localAddArray;  // 本地添加数据个数
@property (nonatomic,strong) NSMutableArray *localADArray;   // 本地广告数据
@end

@implementation TSVideoViewController
//1 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
     _pagecount=1;
     _pageSize=20;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 设置tableview
    [self setupTableView];
    
    // 下拉加载最新数据
    [self pullDownToRefreshVideoNews];
    // 上拉加载更多数据
    [self pullUpToLoadMoreVideoNews];
}

#pragma mark - 刷新数据
/**
 *  下拉加载最新数据
 */
- (void)pullDownToRefreshVideoNews {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requesVideoNews)];
    // 设置header
    [self.tableView.header beginRefreshing];
}

/**
 *  上拉加载更多数据
 */
- (void)pullUpToLoadMoreVideoNews {
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMoreVideoNews];
    }];
}

- (void)requesVideoNews {
   
    // 获取轮播图片
    [self getSCrollerViewImage];
    //先从数据库查找数据
    NSArray *getArray = [CacheTool queryVideoChannelDataHistory];

        if (getArray.count > 0) {
            _localAddArray = [TSCarNews objectArrayWithKeyValuesArray:getArray];
            // 创建frame模型对象
            NSMutableArray *newsArray = [NSMutableArray array];
            for (TSCarNews *news in _localAddArray) {
                TSCarTableViewCellFrame *f = [[TSCarTableViewCellFrame alloc] init];
                f.carNews = news;
                [newsArray addObject:f];
            }
            
            self.videoNewsFrame = newsArray;
            // 刷新tableView
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.header endRefreshing];

        }
    else
    {
        NSString *substring=[NSString stringWithFormat:@"/%d?pageSize=%d", _pagecount, _pageSize];
        NSString *urlString = [kGetVideoCarNewsURL stringByAppendingString:substring];
        
        [TSEHttpTool get:urlString params:_paras success:^(id json) {
            
            //保存数据库
            [CacheTool updateVideoCacheDataHistory:json[@"Data"][@"Shipin"]];
            // 通过数组字典返回模型，该数组中装的都是TSCarNews模型
            NSArray *videoNewsArr = [TSCarNews objectArrayWithKeyValuesArray:json[@"Data"][@"Shipin"]];
            
            // 创建frame模型对象
            NSMutableArray *newsArray = [NSMutableArray array];
            for (TSCarNews *news in videoNewsArr) {
                TSCarTableViewCellFrame *f = [[TSCarTableViewCellFrame alloc] init];
                f.carNews = news;
                [newsArray addObject:f];
            }
            
            self.videoNewsFrame = newsArray;
            // 刷新tableView
            [self.tableView reloadData];
            // 结束刷新
            [self.tableView.header endRefreshing];
            
        } failure:^(NSError *error) {
            TSELog(@"error-------/n%@", error);
            // 结束刷新
            [self.tableView.header endRefreshing];
        }];
 
    }

}

- (void)requestMoreVideoNews {
        
    _pagecount +=1;
    NSString *substring=[NSString stringWithFormat:@"/%d?pageSize=%d", _pagecount, _pageSize];
    NSString *urlString = [kGetVideoCarNewsURL stringByAppendingString:substring];
    
    [TSEHttpTool get:urlString params:_paras success:^(id json) {
        
      [self setUpMoreVideoArr:json];

        // 刷新tableView
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        TSELog(@"error-------/n%@", error);
        // 结束刷新
        [self.tableView.header endRefreshing];
    }];

}

-(void)setUpMoreVideoArr:(NSDictionary*)json
{
    // 通过数组字典返回模型，该数组中装的都是XZMDoesticCarNews模型
    NSArray *videoNewsArr = [TSCarNews objectArrayWithKeyValuesArray:json[@"Data"][@"Shipin"]];

    // 创建frame模型对象
    NSMutableArray *newsArray = [NSMutableArray array];
    for (TSCarNews *news in videoNewsArr) {
    TSCarTableViewCellFrame *f = [[TSCarTableViewCellFrame alloc] init];
    f.carNews = news;
    [newsArray addObject:f];
    }

    [self.videoNewsFrame addObjectsFromArray:newsArray];
    // 刷新tableView
    [self.tableView reloadData];
    // 停止刷新
    [self.tableView.footer endRefreshing];

}
#pragma mark - Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.videoNewsFrame.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建TSVideoTableViewCell
    TSVideoTableViewCell *cell = [TSVideoTableViewCell CarTableViewCellWithTableView:tableView];
    // 2.设置cell的属性
    cell.CarTableViewCellFrame = self.videoNewsFrame[indexPath.section];
    return cell;
}

#pragma mark - Table view delegate methods
/**
 *  根据相应的数据设置cell的高度
 *
 *  @param indexPath cell的位置
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSCarTableViewCellFrame *lnf = self.videoNewsFrame[indexPath.row];
    return lnf.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20*PSDSCALE_Y;
}
#pragma mark -视频跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSCarTableViewCellFrame *f = self.videoNewsFrame[indexPath.row];
    TSCarNews *news = f.carNews;
    TSEWebViewController *webVC = [[TSEWebViewController alloc] init];
    webVC.movieURL = news.ShipinUrl;
    webVC.Title = news.Title;
    webVC.AddTime = news.AddTime;
    webVC.Author = news.Author;
    webVC.Detail = news.Detail;
    webVC.shareDic=news.Share;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
    [nav pushViewController:webVC animated:YES];
  
}

#pragma mark - lazy load
- (NSMutableDictionary *)paras {
    if (!_paras) {
        _paras = [NSMutableDictionary dictionary];
        _paras[VIDEOCOUNT] = @1;
        _paras[VIDEOPAGESIZE] = @20;
       
    }
    
    return _paras;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    // 设置tableView的额外滚动区域
    [tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, TableViewContentInset, 0.0)];
    tableView.backgroundColor= MeGlobalBackgroundColor;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TSEXCARLoopView *loopView = [[TSEXCARLoopView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 432*PSDSCALE_Y)];
    loopView.delegate = self;
    self.tableView.tableHeaderView = loopView;
    self.tableView.userInteractionEnabled=YES;
    self.loopView = loopView;
}

#pragma mark -获取视频页面广告图
-(void)getSCrollerViewImage
{
    //从本地获取广告
    NSArray *getArray = [CacheTool queryADCacheDataHistory];
    if (getArray) {
        if (getArray.count > 0) {
            _localADArray = [TSAdvertisementNews objectArrayWithKeyValuesArray:getArray[2][@"Ad"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:_localADArray];
            [self.tableView reloadData];
        }
    }else
    {
        [TSEHttpTool get:kGetChannelNewsURL params:nil success:^(id json) {
            //获取广告图片
            self.ADImage =[TSAdvertisementNews objectArrayWithKeyValuesArray:json[@"Data"][@"Default"][2][@"Ad"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:self.ADImage];
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
        self.imgsArr = [NSMutableArray array];
        for (TSAdvertisementNews *news in ADNews) {
            NSString *urlStr = news.ImageUrl;
            NSURL *imageUrl = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            [self.imgsArr addObject:image];
        }
        
        // 当图片下载完成后，在主线程设置tableHeaderView的数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.loopView setLoopViewImages:self.imgsArr autoPlay:YES delay:3.0];
        });
    });
}
@end
