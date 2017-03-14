//
//  NumerousRaiseViewController.m
//  LvXinDemo
//
//  Created by wei_yijie on 15/8/5.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//

#import "NumerousRaiseViewController.h"

@interface NumerousRaiseViewController (){

}

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation NumerousRaiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addStatusBlackBackground];
    self.view.backgroundColor = [UIColor whiteColor];
}


//增加状态栏黑色背景
- (void)addStatusBlackBackground{
//    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [leftButton setImage:GETTHEIMAGE(@"left_button@3x.png") forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    
//    self.navigationItem.title = MMLocalizedString(@"Chips_KEY", @"");
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
    //背景大图
    //    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    //    bgImageView.image = GETTHEIMAGE(@"power_bg@3x.jpg");
    //    [self.view addSubview:bgImageView];
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
