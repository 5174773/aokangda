//
//  TSLatestNewsViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/12/1.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSEXCARLoopView.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CacheTool.h"
#import "AppDelegate.h"
#import "TSEHttpTool.h"
#import "TSLatestNews.h"
#import "TSLatestNewsViewController.h"
#import "TSEWebViewController.h"
#import "UIImageView+WebCache.h"
#import "TSAdvertisementNews.h"
#import "TSCarDetailViewController.h"
#import "TSCarChannelTableViewCell.h"
#import "TSCarsTableViewCellFrame.h"

#import "Public.h"

@interface TSLatestNewsViewController () <UITableViewDataSource, UITableViewDelegate,TSEXCARLoopViewDelegate>

@property (nonatomic, weak) TSEXCARLoopView *loopView;
@property (nonatomic, strong) NSMutableArray *latestNewsFrame;
@property (nonatomic, strong) NSMutableDictionary *paras;
@property (nonatomic, strong) NSArray *latestNewsArr;
//广告数组
@property (nonatomic, strong) NSArray *ADNews;
//广告图片
@property (nonatomic, strong) NSMutableArray *ADImageArr;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) int pagecount;

@property (nonatomic,strong) NSMutableArray *localAddArray;  // 本地添加数据个数
@property (nonatomic,strong) NSMutableArray *localADArray;  // 本地广告数据
@end

@implementation TSLatestNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pagecount=1;
    //     设置tableView
    [self setupTableView];
    //    // 下拉加载最新数据
    [self pullDownToRefreshLatestNews];
    //    //     上拉加载更多数据
    [self pullUpToLoadMoreNews];
}

#pragma mark - 刷新数据
/**
 *  下拉加载最新数据
 */
- (void)pullDownToRefreshLatestNews {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLatestNews)];
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
#pragma mark -获取数据
- (void)requestLatestNews {
    
    // 获取轮播图片
    [self getSCrollerViewImage];
    NSArray *getArray = [CacheTool queryLatestHistory];
    if (getArray) {
        if (getArray.count > 0) {
            _localAddArray = [TSLatestNews objectArrayWithKeyValuesArray:getArray];
            // 创建frame模型对象
            NSMutableArray *newsArray = [NSMutableArray array];
            for (TSLatestNews *news in _localAddArray) {
                
                TSCarsTableViewCellFrame *f = [[TSCarsTableViewCellFrame alloc] init];
                f.latestNews = news;
                [newsArray addObject:f];
            }
            self.latestNewsFrame = newsArray;
            [self.tableView reloadData];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        }
    }
    else
    {
        NSString *substring=[NSString stringWithFormat:@"?token=%@", LATESTTOKEN];
        NSString *urlString = [kGetLaststInfoURL stringByAppendingString:substring];
        [TSEHttpTool post:urlString params:self.paras success:^(id json) {
            //    //保存数据库
            [CacheTool updateLastestCacheDataHistory:json[@"Data"][@"Cars"]];
            // 通过数组字典返回模型，该数组中装的都是TSLatestNews模型
            NSArray *latestNewsArr = [TSLatestNews objectArrayWithKeyValuesArray:json[@"Data"][@"Cars"]];
            
            // 创建frame模型对象
            NSMutableArray *newsArray = [NSMutableArray array];
            for (TSLatestNews *news in latestNewsArr) {
                
                TSCarsTableViewCellFrame *f = [[TSCarsTableViewCellFrame alloc] init];
                f.latestNews = news;
                [newsArray addObject:f];
            }
            
            
            self.latestNewsFrame = newsArray;
            // 刷新tableView
            [self.tableView reloadData];
            // 结束刷新状态
            [self.tableView.header endRefreshing];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }
    
    
    
}

- (void)requestMoreLatestNews {
    
    _pagecount +=1;
    NSString *pageCount=[NSString stringWithFormat:@"%d",_pagecount];
    //创建请求路径
    NSString *substring=[NSString stringWithFormat:@"?token=%@", LATESTTOKEN];
    NSString *urlString = [kGetLaststInfoURL stringByAppendingString:substring];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *jsonDic = @{@"order":@"11",@"pageIndex":pageCount,@"pageSize":@"10"};
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    //创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    //设置请求方法
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data.length>0&&connectionError==nil){
            NSDictionary *jsonDic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self setUpMoreLatestArr:jsonDic];
        }
        // 停止刷新
        [self.tableView.footer endRefreshing];
    }];
    
    
    
}
-(void)setUpMoreLatestArr:(NSDictionary*)jsonString
{

    // 通过数组字典返回模型，该数组中装的都是XZMDoesticCarNews模型
    NSArray *latestMoreNewsArr = [TSLatestNews objectArrayWithKeyValuesArray:jsonString[@"Data"][@"Cars"]];
    
    // 创建frame模型对象
    NSMutableArray *newsArray = [NSMutableArray array];
    for (TSLatestNews *news in latestMoreNewsArr) {
        
        TSCarsTableViewCellFrame *f = [[TSCarsTableViewCellFrame alloc] init];
        f.latestNews = news;
        [newsArray addObject:f];
    }
    
    
    [self.latestNewsFrame addObjectsFromArray:newsArray];
    // 刷新tableView
    [self.tableView reloadData];
    // 停止刷新
    [self.tableView.footer endRefreshing];
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
    // 设置tableView的头部视图
    TSEXCARLoopView *loopView = [[TSEXCARLoopView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 432*PSDSCALE_Y)];
    loopView.delegate = self;
    self.tableView.tableHeaderView = loopView;
    self.tableView.userInteractionEnabled=YES;
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
    // 1.创建TSEHomeViewNewsCell
    TSCarChannelTableViewCell *cell = [TSCarChannelTableViewCell CarsTableViewCellWithTableView:tableView];
    // 2.设置cell的属性
    cell.CarsTableViewCellFrame = self.latestNewsFrame[indexPath.section];
    return cell;
}

#pragma mark - Table view delegate methods
/**
 *  根据相应的数据设置cell的高度
 *
 *  @param indexPath cell的位置
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSCarsTableViewCellFrame *f = self.latestNewsFrame[indexPath.row];
    return f.rowHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*PSDSCALE_Y;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10*PSDSCALE_Y;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TSCarsTableViewCellFrame *f = self.latestNewsFrame[indexPath.section];
    TSLatestNews *news = f.latestNews;
    TSCarDetailViewController *CarDetailVC=[[TSCarDetailViewController alloc]init];
    CarDetailVC.CarID = news.ID;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
    [nav pushViewController:CarDetailVC animated:YES];
}


#pragma mark - lazy load
- (NSMutableDictionary *)paras {
    if (!_paras) {
        _paras = [NSMutableDictionary dictionary];
        _paras[LATESTORDER] = @11;
        _paras[LATESTPAGEINDEX] = @1;
        _paras[LATESTPAGESIZE] = @10;
        
    }
    
    return _paras;
}
#pragma mark -获取视频页面广告图
-(void)getSCrollerViewImage
{
    NSArray *getArray = [CacheTool queryADCacheDataHistory];
    if (getArray) {
        if (getArray.count > 0) {
            _localADArray = [TSAdvertisementNews objectArrayWithKeyValuesArray:getArray[4][@"Ad"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:_localADArray];
            [self.tableView reloadData];
        }
    }
    else
    {
        [TSEHttpTool get:kGetChannelNewsURL params:nil success:^(id json) {
            //获取广告图片
            self.ADNews =[TSAdvertisementNews objectArrayWithKeyValuesArray:json[@"Data"][@"Default"][4 ][@"Ad"]];
            // 设置tableView header
            [self setupTableHeaderViewWithFocusNews:self.ADNews];
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
        self.ADImageArr = [NSMutableArray array];
        for (TSAdvertisementNews *news in ADNews) {
            NSString *urlStr = news.ImageUrl;
            NSURL *imageUrl = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            [self.ADImageArr addObject:image];
        }
        
        // 当图片下载完成后，在主线程设置tableHeaderView的数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.loopView setLoopViewImages:self.ADImageArr autoPlay:YES delay:3.0];
        });
    });
}

@end

