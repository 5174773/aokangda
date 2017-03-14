//
//  CZMoviePlayerViewController.m
//  B05_视频播放
//
//  Created by apple on 15-3-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TSEWebViewController.h"
#import "TSEBarButtonItem.h"
#import "UIImageView+WebCache.h"
#import "Public.h"
#import "WeChatManager.h"
#import <MediaPlayer/MediaPlayer.h>
@interface TSEWebViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate,WXApiDelegate>

{
   
    //控件
    UILabel *titleView;
    UILabel *AuthorView;
    UILabel *createTimeView;
    UILabel *textView;
    UIImageView *playBtn;
    UIImageView*AVPlayView;
    //分享按钮
    UIButton *rightButton;
    UIButton *weiXinBtn;
    UIButton *friendBtn;
    UIButton *collectBtn;
    //视图
    UIView *bgView;
    UIWebView*textWebView;
    UIScrollView *ScrollView;
    MPMoviePlayerController *movieContr;
}
@end

@implementation TSEWebViewController
static CGFloat margin  = 10.0f;
static BOOL showView=NO;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addTitle];
    [self initWebView];
    [self setUpVideoView];
    self.view.backgroundColor=[UIColor whiteColor];
}
-(void)addTitle
{
    [self addTitleWithName:@"视频详情" wordNun:NULL];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSFontAttributeName:[UIFont systemFontOfSize:17],//字体
       NSForegroundColorAttributeName:[UIColor whiteColor]  //颜色
       }
     ];
}
#pragma mark -添加右item
- (void)initWebView {
    [self addBackButton:NO];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"shipin_share@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
#pragma mark- 返回视频列表
- (void)backToLatesetView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)moreButtonClick {
    NSLog(@"分享视频");
    [self setUpshareView];
}
#pragma mark- 返回头视图
- (void)setUpVideoView {

    ScrollView=[[UIScrollView alloc]init];
    ScrollView.frame=self.view.bounds;
    ScrollView.showsHorizontalScrollIndicator=NO;
    ScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:ScrollView];
    
    

    /*视频标题*/
    titleView=[[UILabel alloc]init];
    titleView.font=[UIFont systemFontOfSize:KWIDTHShiPei 16.0f];
    titleView.text=self.Title;
    titleView.frame=CGRectMake(margin, margin, SCREEN_WIDTH, 100*PSDSCALE_Y);

    /*视频发布者*/
    AuthorView=[[UILabel alloc]init];
    AuthorView.font=[UIFont systemFontOfSize:KWIDTHShiPei 14.0f];
    AuthorView.textColor=[UIColor lightGrayColor];
    AuthorView.text=self.Author;
    AuthorView.frame=CGRectMake(margin, CGRectGetMaxY(titleView.frame), 200*PSDSCALE_Y, 87*PSDSCALE_Y);

    /*视频发布时间*/
    createTimeView=[[UILabel alloc]init];
    createTimeView.font=[UIFont systemFontOfSize:KWIDTHShiPei 14.0f];
    createTimeView.textColor=[UIColor lightGrayColor];
    NSString *createTimeStr = [[NSString stringWithFormat:@"%@",self.AddTime] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    createTimeView.text=createTimeStr;
    createTimeView.frame=CGRectMake(margin+CGRectGetMaxX(AuthorView.frame), CGRectGetMaxY(titleView.frame), 700*PSDSCALE_Y, 87*PSDSCALE_Y);
    
    //断言
    NSAssert(self.movieURL != nil, @"请先设置movieURL");
    self.view.backgroundColor=[UIColor whiteColor];
    

    movieContr = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
    
    //设置movieContr的View的尺寸
    movieContr.view.frame = CGRectMake(margin, CGRectGetMaxY(AuthorView.frame), self.view.frame.size.width-2*margin, 700*PSDSCALE_Y);
    
    //设置视频播放的适配UIViewAutoresizingNone
    movieContr.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    movieContr.view.layer.backgroundColor=[[UIColor whiteColor]CGColor];
    //把movieContr的View 添加到当前视频控制器的View
    [ScrollView addSubview:movieContr.view];
    
    //播放
    [movieContr prepareToPlay];
    
    [movieContr play];

    
    //监听Done事件 通过通知的方式实现
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(exit) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    //监听视频播放完成
    [center addObserver:self selector:@selector(exit) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    UITapGestureRecognizer *loc_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(canclePlay:)];
    [movieContr.view addGestureRecognizer:loc_tap];
    
    //视频详情
    textWebView = [[UIWebView alloc]init];
    textWebView.frame = CGRectMake(margin,820*PSDSCALE_Y, SCREEN_WIDTH-2*margin, 800*PSDSCALE_Y);
    [ScrollView addSubview:textWebView];
    textWebView.delegate=self;
    //大小自适应
    [textWebView setScalesPageToFit:NO];
    textView.layer.borderColor=[[UIColor whiteColor]CGColor];
    textWebView.scrollView.backgroundColor=[UIColor whiteColor];
    textWebView.userInteractionEnabled=NO;
    NSString *strHTML =self.Detail;
    [textWebView loadHTMLString:strHTML baseURL:nil];
    //拦截网页图片  并修改图片大小
    [textWebView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 100.0;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [textWebView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];


    [ScrollView addSubview:titleView];
    [ScrollView addSubview:AuthorView];
    [ScrollView addSubview:createTimeView];
}
-(void)canclePlay:(UITapGestureRecognizer*)_tap{

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark 退出
-(void)exit{
 
    //退出当前的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)playBtnDidClick
{
    NSLog(@"播放视频");
}
#pragma mark -分享
-(void)setUpshareView{
    
    if (!bgView) {
        bgView=[[UIView alloc]init];
    }
    
    bgView.backgroundColor=TSEAColor(64, 68, 77,0.5);
    bgView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 120*PSDSCALE_Y);
    //微信
    weiXinBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 489*PSDSCALE_X,120*PSDSCALE_Y)];
    [weiXinBtn setImage:GETNCIMAGE(@"weChat@2x") forState:UIControlStateNormal];
    [weiXinBtn addTarget:self action:@selector(testWeiXinAct) forControlEvents:UIControlEventTouchUpInside];
    UIView *FirstselectView=[[UIView alloc]init];
    FirstselectView.backgroundColor=[UIColor whiteColor];
    FirstselectView.frame=CGRectMake(489*PSDSCALE_X, 0, 1,120*PSDSCALE_Y);
    //微信朋友圈
    friendBtn=[[UIButton alloc]initWithFrame:CGRectMake(490*PSDSCALE_X, 0*PSDSCALE_X, 489*PSDSCALE_X, 120*PSDSCALE_Y)];
    [friendBtn setImage:GETNCIMAGE(@"friendShare@2x") forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(testFriendAct) forControlEvents:UIControlEventTouchUpInside];
    UIView *secondSelectView=[[UIView alloc]init];
    secondSelectView.backgroundColor=[UIColor whiteColor];
    secondSelectView.frame=CGRectMake(979*PSDSCALE_X, 0, 1,120*PSDSCALE_Y);
    //收藏
    collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(980*PSDSCALE_X,0*PSDSCALE_X, SCREEN_WIDTH-980*PSDSCALE_X, 120*PSDSCALE_Y)];
    [collectBtn setImage:GETNCIMAGE(@"collect_normal@2x") forState:UIControlStateNormal];
    [collectBtn setImage:GETNCIMAGE(@"collect_click@2x") forState:UIControlStateSelected];
    [collectBtn addTarget:self action:@selector(testCollectBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:FirstselectView];
    [bgView addSubview:secondSelectView];
    [bgView addSubview:weiXinBtn];
    [bgView addSubview:friendBtn];
    [bgView addSubview:collectBtn];
   
    showView=!showView;
    if (showView) {
        [self.view addSubview:bgView];
    }else
    {
        [bgView removeFromSuperview];
    }

}
//收藏
-(void)testCollectBtnDidClick
{
    NSLog(@"收藏按钮被点击");
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = VALUEFORKEY(self.shareDic,@"Title");
    
    message.description = VALUEFORKEY(self.shareDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.shareDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(self.shareDic,@"Url");
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = WXSceneFavorite;
    
    
    [WXApi sendReq:req];
    
}
//微信朋友圈
-(void)testFriendAct
{
    NSLog(@"微信朋友圈");
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = VALUEFORKEY(self.shareDic,@"Title");
    
    message.description = VALUEFORKEY(self.shareDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.shareDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(self.shareDic,@"Url");
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = WXSceneTimeline;
    
    
    [WXApi sendReq:req];


}
    //微信
-(void)testWeiXinAct
{
      NSLog(@"微信");
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = VALUEFORKEY(self.shareDic,@"Title");
    
    message.description = VALUEFORKEY(self.shareDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.shareDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(self.shareDic,@"Url");
    
    message.mediaObject = ext;
        
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = WXSceneTimeline;
    
    
    [WXApi sendReq:req];
 
}
#pragma mark ---- 数据加载完调用webView代理方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    CGRect frame = webView.frame;
    //webView的宽度
    frame.size = CGSizeMake(ScreenWidth, 0);
    webView.frame = frame;
    float content_height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    frame = webView.frame;
    //webView的宽度和高度
    frame.size = CGSizeMake(ScreenWidth, content_height);
    webView.frame = frame;
    
    NSLog(@"-----%d",(int) frame.size.height);
    ScrollView.contentSize=CGSizeMake(0, frame.size.height+900*PSDSCALE_Y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
