//
//  PersonalSettingsViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/12/1.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "PersonalSettingsViewController.h"

@interface PersonalSettingsViewController ()

@end

@implementation PersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton:NO];
    [self addTitle];
    self.view.backgroundColor=[UIColor whiteColor];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
