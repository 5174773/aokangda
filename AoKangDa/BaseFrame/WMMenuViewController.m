//
//  WMMenuViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//
#import "WMCommon.h"
#import "UIImage+WM.h"
#import "Header.h"
#import "WMMenuViewController.h"
#import "WMMenuTableViewCell.h"

@interface WMMenuViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    //菜单
    NSArray  *listArray;
    
    UITableView *MytableView;
    UIButton    *nightModeBtn;
    UIButton    *settingBtn;
    UIImageView *headerImageView;
}
@end

@implementation WMMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArray = @[@"系统消息", @"车型对比", @"卡券包", @"预约保养", @"帮办理赔", @"设置"];
    MytableView =[[UITableView alloc]init];
    MytableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    MytableView.delegate        = self;
    MytableView.dataSource      = self;
    MytableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    MytableView.rowHeight       = 44 * GETSCALE_Y;
    MytableView.backgroundColor=PersonCenter_COLOR;
    MytableView.scrollEnabled=NO;
    [self setUpHeadView];
    [self setUpFootView];
    self.view.backgroundColor=PersonCenter_COLOR;
    [self.view addSubview:MytableView];
}


#pragma mark - tableView代理方法及数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 没有用系统自带的类而用了自己重新定义的cell，仅仅为了之后扩展方便，无他
    WMMenuTableViewCell *cell = [WMMenuTableViewCell cellWithTableView:tableView];
    [cell setCellText:listArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectItem:Tag: )]) {
        [self.delegate didSelectItem:listArray[indexPath.row] Tag:indexPath.row];
    }


}

#pragma mark -头视图
-(void)setUpHeadView
{
    //头视图
    UIView *headView=[[UIView alloc]init];
    headView.frame=CGRectMake(0, 0, self.view.bounds.size.width, 119*GETSCALE_Y);
    headerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me"]];
    headerImageView.image =[UIImage imageNamed:@"me"];
    headerImageView.frame=CGRectMake(25*GETSCALE_X, 25*GETSCALE_Y, 70*GETSCALE_X, 70*GETSCALE_Y);
    [headView addSubview:headerImageView];
    //欢迎语
    UILabel *WelcomeLabel=[[UILabel alloc]init];
    WelcomeLabel.frame=CGRectMake(105*GETSCALE_X, 60*GETSCALE_Y, 240*GETSCALE_X, 30*GETSCALE_Y);
    WelcomeLabel.text=@"澳康达欢迎您";
    WelcomeLabel.font=[UIFont systemFontOfSize:17];
    WelcomeLabel.textColor=[UIColor whiteColor];
    WelcomeLabel.textAlignment=NSTextAlignmentLeft;
    //用户
    UILabel *UserNameLabel=[[UILabel alloc]init];
    UserNameLabel.text=@"许女士";
    UserNameLabel.font=[UIFont boldSystemFontOfSize:19];
    UserNameLabel.frame=CGRectMake(105*GETSCALE_X, 29*GETSCALE_Y, UserNameLabel.text.length*20*GETSCALE_X, 30*GETSCALE_Y);
    UserNameLabel.textColor=[UIColor whiteColor];
    UserNameLabel.textAlignment=NSTextAlignmentLeft;
    //性别
    UIImageView *genderImage=[[UIImageView alloc]init];
    genderImage.image=GETNCIMAGE(@"xingxing_yellow@2x.png");
    CGFloat GenderX=CGRectGetMaxX(UserNameLabel.frame)-10*GETSCALE_X;
    CGFloat GenderY=UserNameLabel.frame.origin.y+6*GETSCALE_Y;
    CGFloat GenderH=18*GETSCALE_Y;
    CGFloat GenderW=18*GETSCALE_X;
    genderImage.frame=CGRectMake(GenderX, GenderY,GenderW,GenderH);
    //分割线
    UIView *separateLine=[[UIView alloc]init];
    separateLine.frame=CGRectMake(0, 119*GETSCALE_Y, self.view.bounds.size.width, 1.0*GETSCALE_Y);
    separateLine.backgroundColor=[UIColor grayColor];
    [headView addSubview:separateLine];
    [headView addSubview:genderImage];
    [headView addSubview:UserNameLabel];
    [headView addSubview:WelcomeLabel];
    headView.backgroundColor=PersonCenter_COLOR;
    MytableView.tableHeaderView =headView;
    
}
#pragma mark -脚视图
-(void)setUpFootView
{
    
    // 设置tableFooterView为一个空的View，这样就不会显示多余的空白格子了
    UIView* FooterView = [[UIView alloc] init];
    FooterView.frame=CGRectMake(0, 200*GETSCALE_Y, SCREEN_WIDTH, 200*GETSCALE_Y);
    FooterView.backgroundColor=PersonCenter_COLOR;
    MytableView.tableFooterView=FooterView;
    UIButton *exitBtn=[[UIButton alloc]init];
    exitBtn.frame=CGRectMake(30*GETSCALE_X, 45*GETSCALE_Y, 150*GETSCALE_X, 30*GETSCALE_Y);
    exitBtn.backgroundColor=PersonCenter_COLOR;
    exitBtn.layer.masksToBounds=YES;
    exitBtn.layer.cornerRadius=20;
    exitBtn.layer.borderWidth=1.0f;
    exitBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    //    [exitBtn setBackgroundImage:GETNCIMAGE(@"exitBtn@2x.png") forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
    [MytableView.tableFooterView addSubview:exitBtn];
    
    
}
-(void)exitLogin
{
    NSLog(@"退出登录");
}

@end
