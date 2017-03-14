//
//  BaseViewController.h
//  iMark
//
//  Created by wei_yijie on 15/10/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)addStatusBlackBackground;                                           //状态栏和默认背景
- (void)addBackButton:(BOOL)sendNotification;                               //导航栏返回 BackButtonNotification 是否发通知
- (void)addTitleWithName:(id)name wordNun:(int)num;                         //设置图片或文字导航栏标题
- (void)addActityText:(NSString *)text deleyTime:(float)duration;           //添加文字提示框
- (void)addActityLoading:(NSString *)title subTitle:(NSString *)subTitle;   //加载中提示
- (void)showActityHoldView;
- (void)hiddenActityHoldView;

@end
