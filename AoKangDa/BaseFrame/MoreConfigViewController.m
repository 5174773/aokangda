//
//  MoreConfigViewController.m
//  AoKangDa
//
//  Created by 深圳市 秀软科技有限公司 on 15/12/18.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "MoreConfigViewController.h"

@interface MoreConfigViewController ()

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation MoreConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addBackButton:NO];
    [self addStatusBlackBackground];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Car_logo"]];
    
    [self getCarConfig];
}

- (void)getCarConfig
{
    __weak typeof(self) weakSelf = self;
    [RequestManager getCarConfigWithCarId:self.CarID Succeed:^(NSData *data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([VALUEFORKEY(result, @"Status") integerValue] == 200) {
            weakSelf.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBARHEIGHT)];
            [weakSelf.webView loadHTMLString:FORMATSTRING(VALUEFORKEY(result, @"Data")) baseURL:nil];
            weakSelf.webView.backgroundColor = [UIColor whiteColor];
            [weakSelf.view addSubview:weakSelf.webView];
        }
    } failed:^(NSError *error) {
        
    }];
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
