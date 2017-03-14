//
//  WMHomeViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMLoopView.h"
#import "WMPageConst.h"
#import "WMHomeViewController.h"
//五个固定标题
#import "TSVideoViewController.h"
#import "TSRecommendViewController.h"
#import "TSCarSalesViewController.h"
#import "TSLatestNewsViewController.h"
#import "TSAttentionViewController.h"
@interface WMHomeViewController ()
@end
@implementation WMHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"首页";
    [self addBackButton:NO];
    [self addRightButton:NO];
}
//导航栏返回按钮
- (void)addBackButton:(BOOL)sendNotification{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    [leftButton setTitle:nil forState:UIControlStateNormal];
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [leftButton addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}


//导航栏右侧按钮
- (void)addRightButton:(BOOL)sendNotification{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"tab_qworld_nor@2x.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

//增加状态栏颜色及默认背景
- (void)addStatusColorBackground{
    float statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -statusHeight, SCREEN_WIDTH, statusHeight+2)];
    statusView.backgroundColor = PersonCenter_COLOR;
    [self.navigationController.navigationBar addSubview:statusView];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    //背景大图
    //    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:SCREEN_BOUNDS];
    //    bgImageView.image = GETTHEIMAGE(@"Register_background@3x.png");
    //    [self.view insertSubview:bgImageView atIndex:0];
    //    if (IS_Phone4S) {
    //        bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 568);
    //    }
}
- (void)rightButtonAction:(UIButton *)sender
{
    NSLog(@"主页右侧按钮被点击了");
  
  
}

- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
        [self.delegate leftBtnClicked];
    }
      NSLog(@"主页菜单被点击了");
}

#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WMCell"];
//    }
//    cell.textLabel.text = @"Hello,I'm Mark.";
//    cell.detailTextLabel.text = @"And I'm now a student.";
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    cell.imageView.image = [UIImage imageNamed:@"github.png"];
//    return cell;
//}
//- (void)dealloc {
//    NSLog(@"%@ destroyed",[self class]);
//}
@end
