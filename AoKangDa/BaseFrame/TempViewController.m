//
//  TempViewController.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/8.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TempViewController.h"

#import "Public.h"

#import "SearchViewController.h"
#import "ChannelViewController.h"

@interface TempViewController ()

@end

@implementation TempViewController


//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    for (UIView *view in self.navigationController.navigationBar.subviews) {
//        if (view.tag == SearchBarTag) {
//            [view removeFromSuperview];
//        }
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 60, 60)];
    searchButton.tag = 1;
    [searchButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.backgroundColor = [UIColor redColor];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.view addSubview:searchButton];
    
    UIButton *channelButton = [[UIButton alloc]initWithFrame:CGRectMake(160, 100, 60, 60)];
    channelButton.tag = 2;
    [channelButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    channelButton.backgroundColor = [UIColor redColor];
    [channelButton setTitle:@"频道" forState:UIControlStateNormal];
    [self.view addSubview:channelButton];
    
}

- (void)action:(UIButton *)sender
{
    
    UIViewController *viewcontroller = nil;
    
    if (sender.tag == 1) {
        
        viewcontroller = [[SearchViewController alloc]init];
        
    }else if (sender.tag == 2){
        viewcontroller = [[ChannelViewController alloc]init];
    }
    
    if (viewcontroller) {
        viewcontroller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewcontroller animated:YES];
    }
}

@end
