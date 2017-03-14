//
//  CarContrastViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/12/1.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CarContrastViewController.h"

@interface CarContrastViewController ()

@end

@implementation CarContrastViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
