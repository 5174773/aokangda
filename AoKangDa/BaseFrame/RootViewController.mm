//
//  RootViewController.m
//  LvXinDemo
//
//  Created by wei_yijie on 15/8/5.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "RootViewController.h"

#import "NewsViewController.h"
#import "PowerStationViewController.h"
#import "NumerousRaiseViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate,UIGestureRecognizerDelegate>
{
    UITabBarController *tabbarController;
    
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加Tabbar
    [self addTabbar];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addTabbar{
    NewsViewController *news = [[NewsViewController alloc] init];
    PowerStationViewController *powerStation = [[PowerStationViewController alloc] init];
    NumerousRaiseViewController *numerousRaise = [[NumerousRaiseViewController alloc] init];
    
    tabbarController = [[UITabBarController alloc] init];
    tabbarController.tabBar.backgroundColor = [UIColor orangeColor];
    tabbarController.delegate = self;
    
    nav1 = [[UINavigationController alloc] initWithRootViewController:news];
    nav2 = [[UINavigationController alloc] initWithRootViewController:powerStation];
    nav3 = [[UINavigationController alloc] initWithRootViewController:numerousRaise];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"news1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"news1_selected@3x.png")];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"power1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"power1_selected@3x.png")];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"numerous1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"numerous1_selected@3x.png")];
    
    nav1.tabBarItem = item1;
    nav2.tabBarItem = item2;
    nav3.tabBarItem = item3;
    
    item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    item2.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    tabbarController.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nav3, nil];
    tabbarController.tabBar.backgroundImage = [self scaleToSize:GETYCIMAGE(@"tabbar_backgroundImage@3x.png") size:CGSizeMake(SCREEN_WIDTH, tabbarController.tabBar.frame.size.height)];
//    [self addChildViewController:tabbarController];
    [self.view addSubview:tabbarController.view];
    
    [tabbarController setSelectedIndex:1];
}



- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark UITabberViewControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    if (tabBarController.selectedIndex == 2) {
//        [UIView animateWithDuration:0.5 animations:^{
//            tabbarController.view.transform = CGAffineTransformMakeTranslation(540*PSDSCALE_X, 0);
//            left_view.transform = CGAffineTransformMakeTranslation(540*PSDSCALE_X, 0);
//        } completion:^(BOOL finished) {
//            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.5);
//            dispatch_after(time, dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:2 animations:^{
//                    tabbarController.view.transform = CGAffineTransformMakeTranslation(0, 0);
//                }];
//            });
//        }];
//    }
}

//多语言刷新tabbar
//- (void)refreshTabbar{
//    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"news1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"news1_selected@3x.png")];
//    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"power1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"power1_selected@3x.png")];
//    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"numerous1_unSelected@3x.png") selectedImage:GETYCIMAGE(@"numerous1_selected@3x.png")];
//    if ([SettingConfig shareInstance].languege == English) {
//        item1 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"newsEn_unSelected@3x.png") selectedImage:GETYCIMAGE(@"newsEn_selected@3x.png")];
//        item2 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"powerEn_unSelected@3x.png") selectedImage:GETYCIMAGE(@"powerEn_selected@3x.png")];
//        item3 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"numerousEn_unSelected@3x.png") selectedImage:GETYCIMAGE(@"numerousEn_selected@3x.png")];
//    }else if ([SettingConfig shareInstance].languege == TraditionalChinese) {
//        item1 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"newsTr_unSelected@3x.png") selectedImage:GETYCIMAGE(@"newsTr_selected@3x.png")];
//        item2 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"powerTr_unSelected@3x.png") selectedImage:GETYCIMAGE(@"powerTr_selected@3x.png")];
//        item3 = [[UITabBarItem alloc] initWithTitle:nil image:GETYCIMAGE(@"numerousTr_unSelected@3x.png") selectedImage:GETYCIMAGE(@"numerousTr_selected@3x.png")];
//    }
//
//    nav1.tabBarItem = item1;
//    nav2.tabBarItem = item2;
//    nav3.tabBarItem = item3;
//    item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    item2.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
//    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//}

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
