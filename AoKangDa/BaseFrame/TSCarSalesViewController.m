//
//  TSCarSalesViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/12/1.
//  Copyright © 2015年 showsoft. All rights reserved.
//
#import "MJRefresh.h"
#import "TSEHttpTool.h"
#import "Header.h"
#import "Utils.h"
#import "Public.h"
#import "TSEHttpTool.h"
#import "TSCarSalesViewController.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+AFNetworking.h"
#import "WMPageController.h"
@interface TSCarSalesViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    //返回数据：电话以及图片
    NSString *phoneNumber;
    NSString *CarSellImage;
    UIImageView *carImageView;
    WMPageController *pageVC;
    
    UIScrollView *scroView;
    UIButton *SalePhone;
    UIWebView *webView;
    UIImageView *backGroundImageView;
}
@end

@implementation TSCarSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self addActityLoading:@"刷新中..." subTitle:nil];
    self.tabBarController.tabBar.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self requestSaleDetailNews];
    
    
    
    [self performSelector:@selector(setUpScrollowView) withObject:nil afterDelay:0.1];
    
    
    // Do any additional setup after loading the view.
}
-(void)setUpScrollowView
{
    scroView=[[UIScrollView alloc]init];
    scroView.frame=CGRectMake(0, -80*PSDSCALE_Y, SCREEN_WIDTH, SCREEN_HEIGHT);
    scroView.contentSize=CGSizeMake(0, 6000*PSDSCALE_Y);
    [self.view addSubview:scroView];
    //添加底部拨打电话按钮
    SalePhone=[[UIButton alloc]init];
    CGFloat SalePhoneX=0;
    CGFloat SalePhoneH=280*PSDSCALE_Y;
    CGFloat SalePhoneW=SCREEN_WIDTH;
    
    CGFloat SalePhoneY=self.view.bounds.size.height-SalePhoneH;
    
//    NSLog(@"%@:%f",NSStringFromCGRect(self.view.bounds),SCREEN_HEIGHT);
    
    SalePhone.frame=CGRectMake(SalePhoneX,SalePhoneY, SalePhoneW, SalePhoneH);
//    SalePhone.backgroundColor = [UIColor redColor];
    if (SalePhone.selected) {
        [SalePhone setImage:[UIImage imageNamed:@"appointment_click"] forState:UIControlStateSelected];
    }
    else{
        [SalePhone setImage:[UIImage imageNamed:@"appointment_normal"] forState:UIControlStateNormal];
    }
    [SalePhone setBackgroundImage:[UIImage imageNamed:@"phone_bgimage.png"] forState:UIControlStateNormal];
    [SalePhone addTarget:self action:@selector(sendCall) forControlEvents:UIControlEventTouchUpInside];
    UILabel *leftLabel=[[UILabel alloc]init];
    leftLabel.text=@"轻轻一点";
    leftLabel.frame=CGRectMake(70*PSDSCALE_X, 155*PSDSCALE_Y, 300*PSDSCALE_X, 50*PSDSCALE_Y);
    leftLabel.textAlignment=NSTextAlignmentCenter;
    leftLabel.textColor=[UIColor whiteColor];
    leftLabel.font=[UIFont boldSystemFontOfSize:KWIDTHShiPei 20];
    UILabel *rightLabel=[[UILabel alloc]init];
    rightLabel.text=@"一键预约";
    rightLabel.frame=CGRectMake(700*PSDSCALE_X, 155*PSDSCALE_Y, 300*PSDSCALE_X, 50*PSDSCALE_Y);
    rightLabel.textAlignment=NSTextAlignmentCenter;
    rightLabel.textColor=[UIColor whiteColor];
    rightLabel.font=[UIFont boldSystemFontOfSize: KWIDTHShiPei 20];
    
    [SalePhone addSubview:leftLabel];
    [SalePhone addSubview:rightLabel];
    NSLog(@"%f",SalePhone.frame.size.height);
    
    [self.view addSubview:SalePhone];
    [self.view bringSubviewToFront:SalePhone];
    
    [self requestSaleDetailNews];
}


-(void)setUpWebView
{
    
    //kCallPhoneCarNewsURL
    
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:CarSellImage]];
        UIImage* imageV=[UIImage imageWithData:data];
        NSData *imagedata= UIImagePNGRepresentation(imageV);
        // 保存图片数据
        [UserDefaults setObject:imagedata forKey:@"backGroundImage"];
        [UserDefaults setObject:phoneNumber forKey:@"telephone"];
        [UserDefaults synchronize];
        //给一张默认图片，先使用默认图片，当图片加载完成后再替换
        // 当图片下载完成后，刷新界面
        [self showImage:imageV];
    });
    
    
    
}
-(void)showImage:(UIImage*)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        backGroundImageView=[[UIImageView alloc]init];
        backGroundImageView.contentMode=UIViewContentModeScaleAspectFit;
        backGroundImageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, scroView.contentSize.height);
        [scroView addSubview:backGroundImageView];
        backGroundImageView.image=image;
//        [self removeActityLoading];
    });
}
- (void)requestSaleDetailNews {
    //从本地获取数据
   NSData *imageData=[UserDefaults objectForKey:@"backGroundImage"];
   phoneNumber=[UserDefaults objectForKey:@"telephone"];
    
    if (imageData) {
        UIImage *bgImage=[UIImage imageWithData:imageData];
        [self showImage:bgImage];
    }
    else
    {
        [TSEHttpTool get:kGetCarSellNewsURL params:nil success:^(id json) {
            phoneNumber=json[@"Data"][@"Phone"];
            CarSellImage=json[@"Data"][@"Image"];
            [self setUpWebView];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
 
    
}


/**
 *  打开通讯录更多数据
 */
-(void)sendCall
{
    SalePhone.selected=YES;
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您是否要申请预约？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}


@end
