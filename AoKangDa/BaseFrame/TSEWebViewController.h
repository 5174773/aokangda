//
//  CZMoviePlayerViewController.h
//  B05_视频播放
//
//  Created by apple on 15-3-3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSEWebViewController : BaseViewController

/** 视频详情 */
@property (nonatomic, copy) NSString *Content;
/** 视频标题 */
@property (nonatomic, copy) NSString *Title;

/** 视频作者*/
@property (nonatomic, copy) NSString *Author;
/** 视频发布时间*/
@property (nonatomic, copy) NSString *AddTime;
/** 视频详情 */
@property (nonatomic, copy) NSString *Detail;

/** 视频分享 */
@property (nonatomic, strong) NSDictionary *shareDic;

@property (nonatomic, strong) UIWebView *webView;

@property(strong,nonatomic)NSURL *movieURL;



@end
