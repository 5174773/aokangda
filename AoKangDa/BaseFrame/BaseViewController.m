//
//  BaseViewController.m
//  iMark
//
//  Created by wei_yijie on 15/10/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"
#import "Public.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addStatusBlackBackground];
    [self addTitleWithName:self.title wordNun:0];
    [self addBackButton:YES];
}

/////////////////////////
//more write  more lazy
/////////////////////////

//增加状态栏颜色及默认背景
- (void)addStatusBlackBackground{
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = MeGlobalBackgroundColor;
    float statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusHeight, SCREEN_WIDTH, statusHeight+2)];
//    statusView.backgroundColor = RGBACOLOR(68, 71, 76, 1);
    [self.navigationController.navigationBar addSubview:statusView];
    
    
//    self.navigationController.navigationBar.barTintColor = RGBACOLOR(68, 71, 76, 1);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TopNav"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    

    
    //背景大图
    //    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    //    bgImageView.image = GETTHEIMAGE(@"Register_background@3x.png");
    //    [self.view insertSubview:bgImageView atIndex:0];
    //    if (IS_Phone4S) {
    //        bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 568);
    //    }
}




//导航栏返回按钮
- (void)addBackButton:(BOOL)sendNotification{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 44)];

    [leftButton setImage:[UIImage imageNamed:@"back_btn@3x.png"] forState:UIControlStateNormal];
    [leftButton setTitle:nil forState:UIControlStateNormal];
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
   
    [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    if (sendNotification) {
        [NotificationCenter postNotificationName:@"BackButtonNotification" object:nil];
    }
    
    
}
- (void)backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航栏标题
- (void)addTitleWithName:(id )name wordNun:(int)num{
    if ([name isKindOfClass:[NSString class]]) {
        self.navigationItem.title = name;
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{
//           NSFontAttributeName:[UIFont boldSystemFontOfSize:20],//字体
           NSFontAttributeName:[UIFont systemFontOfSize:20],//字体
           NSForegroundColorAttributeName:[UIColor whiteColor]  //颜色
           }
         ];
    }
    if ([name isKindOfClass:[UIImage class]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 27/2*num, 23)];//初始化图片视图控件
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = name;
        self.navigationItem.titleView = imageView;//设置导航栏的titleView为imageView
    }
}

//文字提示框
- (void)addActityText:(NSString *)text deleyTime:(float)duration;
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    //    hud.color = RGBACOLOR(253, 165, 86, 1);
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    hud.margin = 15;
    hud.cornerRadius = 3;
    [hud hide:YES afterDelay:duration];
}

//加载提示
- (void)addActityLoading:(NSString *)title subTitle:(NSString *)subTitle{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;//模式
    hud.color = RGBACOLOR(102, 102, 102, 1);//颜色
    hud.labelText = title;
    hud.detailsLabelText = subTitle;
    [self.view addSubview:hud];
}

//等待框
- (void)showActityHoldView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍候...";
    
}

- (void)hiddenActityHoldView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
