//
//  TSGetArticleDetailViewController.m
//  AoKangDa
//
//  Created by showsoft on 15/12/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "Public.h"
#import "WXApi.h"
#import "WeChatManager.h"
#import "TSEHttpTool.h"
#import "TSEBarButtonItem.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "TSGetArticleDetailData.h"
#import "BaseViewController.h"
#import "TSGetArticleDetailViewController.h"



@interface TSGetArticleDetailViewController ()<UIWebViewDelegate,WXApiDelegate>
{
    //数据
    NSMutableDictionary *jsonDic;
    
    UIView        *bgView;
    UIButton      *weiXinBtn;
    UIButton      *friendBtn;
    UIButton      *collectBtn;
    UIButton      *rightButton;
    UILabel       *titleView;
    UILabel       *AuthorView;
    UILabel       *createTimeView;
    UIImageView   *ArticleImageView;
    
    UIScrollView  *ScrollViewView;
    UIWebView     *textWebView;
}
@end

@implementation TSGetArticleDetailViewController

static CGFloat margin  = 10.0f;
static BOOL showView=NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addStatusBlackBackground];
    [self addBackButton:NO];
    [self addTitleWithName:@"新闻详情" wordNun:4];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"shipin_share@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(moreInfoClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self requestHttpArticleInfo];
    
}
#pragma mark -请求文章信息requestHttpArticleInfo
-(void)requestHttpArticleInfo
{
    jsonDic=[NSMutableDictionary dictionary];
    NSString *substring=[NSString stringWithFormat:@"/%@?token=%@",self.ArticleID,LATESTTOKEN];
    NSString *urlString = [kGetArticleDetailURL stringByAppendingString:substring];
    [TSEHttpTool get:urlString params:nil success:^(id json) {
       ;
     jsonDic=json[@"Data"];

     [self setUpArticleDetailView];
     } failure:^(NSError *error) {
         
        TSELog(@"error-------/n%@", error);
    }];

    
    
}
#pragma mark- 新闻分享
-(void)moreButtonwillShareClick
{
    NSLog(@"新闻分享");
}
#pragma mark- 返回头视图
- (void)setUpArticleDetailView {
    
    ScrollViewView =[[UIScrollView alloc]init];
    ScrollViewView.frame=self.view.bounds;
    ScrollViewView.showsVerticalScrollIndicator=NO;
    ScrollViewView.showsHorizontalScrollIndicator=NO;
    ScrollViewView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:ScrollViewView];
    
    
    /*文章标题*/
    titleView=[[UILabel alloc]init];
    titleView.font=[UIFont systemFontOfSize:KWIDTHShiPei 16.0f];
    titleView.text=[NSString stringWithFormat:@"%@",VALUEFORKEY(jsonDic,@"Title")];
    titleView.frame=CGRectMake(margin, margin, SCREEN_WIDTH-margin, 100*PSDSCALE_Y);
    
    /*文章发布者*/
    AuthorView=[[UILabel alloc]init];
    AuthorView.font=[UIFont systemFontOfSize:KWIDTHShiPei 14.0f];
    AuthorView.textColor=[UIColor lightGrayColor];
    AuthorView.text=[NSString stringWithFormat:@"%@",VALUEFORKEY(jsonDic,@"Author")];
    AuthorView.frame=CGRectMake(margin, CGRectGetMaxY(titleView.frame), 200*PSDSCALE_Y, 87*PSDSCALE_Y);
    
    /*文章发布时间*/
    createTimeView=[[UILabel alloc]init];
    createTimeView.font=[UIFont systemFontOfSize:KWIDTHShiPei 14.0f];
    createTimeView.textColor=[UIColor lightGrayColor];
    
    NSString *createTimeStr = [[NSString stringWithFormat:@"%@",VALUEFORKEY(jsonDic,@"AddTime")] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    createTimeView.text=createTimeStr;
    createTimeView.frame=CGRectMake(margin+CGRectGetMaxX(AuthorView.frame), CGRectGetMaxY(titleView.frame), 700*PSDSCALE_Y, 87*PSDSCALE_Y);
    
    ArticleImageView=[[UIImageView alloc]init];
    NSString *imageStr=[NSString stringWithFormat:@"%@",VALUEFORKEY(jsonDic,@"Image")];
    NSURL *Imageurl=[NSURL URLWithString:imageStr];
    [ArticleImageView sd_setImageWithURL:Imageurl placeholderImage:[UIImage imageNamed:@"me"]];;
    ArticleImageView.contentMode=UIViewContentModeScaleToFill;
    ArticleImageView.frame=CGRectMake(margin, 207*PSDSCALE_Y,SCREEN_WIDTH-2*margin, 575*PSDSCALE_Y);


    //文章详情
    textWebView = [[UIWebView alloc]init];
    textWebView.frame = CGRectMake(margin,820*PSDSCALE_Y, SCREEN_WIDTH-2*margin, 600*PSDSCALE_Y);
    [ScrollViewView addSubview:textWebView];
    textWebView.delegate=self;
    //大小自适应
    [textWebView setScalesPageToFit:NO];
    textWebView.scrollView.backgroundColor=[UIColor whiteColor];
    textWebView.userInteractionEnabled=NO;
    NSString *strHTML =VALUEFORKEY(jsonDic,@"Details");
    [textWebView loadHTMLString:strHTML baseURL:nil];
    
    [ScrollViewView addSubview:titleView];
    [ScrollViewView addSubview:AuthorView];
    [ScrollViewView addSubview:createTimeView];
    [ScrollViewView addSubview:ArticleImageView];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    CGRect frame = webView.frame;
    //webView的宽度
    frame.size = CGSizeMake(ScreenWidth-2*margin, 0);
    webView.frame = frame;
    float content_height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    frame = webView.frame;
    //webView的宽度和高度
    frame.size = CGSizeMake(ScreenWidth-2*margin, content_height);
    webView.frame = frame;
    
    NSLog(@"-----%d",(int) frame.size.height);
    //这里以后在修改
    ScrollViewView.contentSize=CGSizeMake(0, frame.size.height+820*PSDSCALE_Y);
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertVCustom = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"网络连接错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [alertVCustom show];
}
#pragma mark -分享
-(void)moreInfoClick{
    
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
    NSLog(@"微信朋友圈");
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = VALUEFORKEY(jsonDic,@"Title");
    
    message.description = VALUEFORKEY(jsonDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(jsonDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(jsonDic,@"Url");
    
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
    
    message.title = VALUEFORKEY(jsonDic,@"Title");
    
    message.description = VALUEFORKEY(jsonDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(jsonDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(jsonDic,@"Url");
    
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
    
    message.title = VALUEFORKEY(jsonDic,@"Title");
    
    message.description = VALUEFORKEY(jsonDic,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(jsonDic,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(jsonDic,@"Url");
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = WXSceneSession;
    
    
    [WXApi sendReq:req];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
