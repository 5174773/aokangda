//
//  DeputyClaimsViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/12/1.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "Header.h"
#import "Public.h"
#import "TSEHttpTool.h"
#import "UIImageView+WebCache.h"
#import "DeputyClaimsViewController.h"

@interface DeputyClaimsViewController ()<UIWebViewDelegate>
{
    UIScrollView *scroView;
    UIButton *SalePhone;
    UIWebView *webView;
}
@end

@implementation DeputyClaimsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton:NO];
    self.tabBarController.tabBar.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setUpWebView];
    [self addTitle];
    [self setUpScrollowView];
    
    // Do any additional setup after loading the view.
}
-(void)addTitle
{
    [self addTitleWithName:title wordNun:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{
       NSFontAttributeName:[UIFont systemFontOfSize:17],//字体
       NSForegroundColorAttributeName:[UIColor whiteColor]  //颜色
       }
     ];
}
-(void)setUpScrollowView
{
    scroView=[[UIScrollView alloc]init];
    scroView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scroView.contentSize=CGSizeMake(0, SCREEN_HEIGHT*5);
    [self.view addSubview:scroView];
    //添加底部拨打电话按
    UIView *phoneView=[[UIView alloc]init];
    phoneView.backgroundColor=[UIColor whiteColor];
    phoneView.frame=CGRectMake(0,400, SCREEN_WIDTH, 100);

    
    SalePhone=[[UIButton alloc]init];
    SalePhone.frame=CGRectMake(0,1490*PSDSCALE_Y, SCREEN_WIDTH, 280*PSDSCALE_Y);
    [SalePhone setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [SalePhone setBackgroundImage:[UIImage imageNamed:@"phone_bgimage.png"] forState:UIControlStateNormal];
    UILabel *leftLabel=[[UILabel alloc]init];
    leftLabel.text=@"轻轻一点";
    leftLabel.frame=CGRectMake(70*PSDSCALE_X, 155*PSDSCALE_Y, 300*PSDSCALE_X, 50*PSDSCALE_Y);
    leftLabel.textAlignment=NSTextAlignmentCenter;
    leftLabel.textColor=[UIColor whiteColor];
    leftLabel.font=[UIFont boldSystemFontOfSize:20];
    UILabel *rightLabel=[[UILabel alloc]init];
    rightLabel.text=@"轻松理赔";
    rightLabel.frame=CGRectMake(700*PSDSCALE_X, 155*PSDSCALE_Y, 300*PSDSCALE_X, 50*PSDSCALE_Y);
    rightLabel.textAlignment=NSTextAlignmentCenter;
    rightLabel.textColor=[UIColor whiteColor];
    rightLabel.font=[UIFont boldSystemFontOfSize:20];
    
    [SalePhone addSubview:leftLabel];
    [SalePhone addSubview:rightLabel];
    
    [self.view addSubview:SalePhone];
    [self.view bringSubviewToFront:SalePhone];
    
    
}


-(void)setUpWebView
{
    
    //kCallPhoneCarNewsURL
    
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:kCallPhoneCarNewsURL]];
        UIImage* imageV=[UIImage imageWithData:data];
        //给一张默认图片，先使用默认图片，当图片加载完成后再替换
        
        
        
        // 当图片下载完成后，刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.image=imageV;
            imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, scroView.contentSize.height);
            [scroView addSubview:imageView];
        });
    });
    
    
    
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
