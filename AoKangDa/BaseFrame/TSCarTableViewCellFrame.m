//
//  TSCarTableViewCellFrame.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSCarTableViewCellFrame.h"
#import "TSCarNews.h"
#import "Public.h"
@implementation TSCarTableViewCellFrame
//重写属性的setter方法，取得模型数据 计算frame  计算行高
- (void)setCarNews:(TSCarNews *)carNews
{
    _carNews = carNews;
    
    CGFloat margin = 20*PSDSCALE_X;
    //标题
    CGFloat titleW = SCREEN_WIDTH-2*margin;
    CGFloat titleH = 127*PSDSCALE_Y;
    CGFloat titleX = margin;
    CGFloat titleY = 0;
    _titleLabelFrame = CGRectMake(titleX, titleY, titleW, titleH);
    //视频图片
    CGFloat imageX = margin;
    CGFloat imageY = titleH;
    CGFloat imageW = SCREEN_WIDTH-2*margin;
    CGFloat imageH = 572*PSDSCALE_Y;
   
    _imageViewFrame = CGRectMake(imageX, imageY, imageW ,imageH);
    //视频播放
    CGFloat playBtnW = 122*PSDSCALE_X;
    CGFloat playBtnH = 122*PSDSCALE_Y;
    CGFloat playBtnX = (SCREEN_WIDTH-playBtnW)/2;
    CGFloat playBtnY = imageY+(imageH-playBtnH)/2;
    
    _playBtnFrame = CGRectMake(playBtnX, playBtnY, playBtnW ,playBtnH);
    //时长
    CGFloat TotaltimeW = 130*PSDSCALE_X;
    CGFloat TotaltimeH = 43*PSDSCALE_Y;
    CGFloat TotaltimeY = 631*PSDSCALE_Y;
    CGFloat TotaltimeX = 888*PSDSCALE_X;
    _totaltimeFrame = CGRectMake(TotaltimeX, TotaltimeY, TotaltimeW ,TotaltimeH);
    //新闻来源
    CGFloat fromSourceLableW = 144*PSDSCALE_X;
    CGFloat fromSourceLableH = 82*PSDSCALE_Y;
    CGFloat fromSourceLableY = imageY+imageH;
    CGFloat fromSourceLableX = margin;
    _fromSourceLableFrame = CGRectMake(fromSourceLableX, fromSourceLableY, fromSourceLableW ,fromSourceLableH);
    //上传时间
    CGFloat createTimeLableW = 316*PSDSCALE_X;
    CGFloat createTimeLableH = 82*PSDSCALE_Y;
    CGFloat createTimeLableY = fromSourceLableY;
    CGFloat createTimeLableX = 187*PSDSCALE_X;
    _createTimeLableFrame = CGRectMake(createTimeLableX, createTimeLableY, createTimeLableW ,createTimeLableH);
    
    // 收藏
    CGFloat collectLabelW = 98*PSDSCALE_X;
    CGFloat collectLabelH = 82*PSDSCALE_Y;
    CGFloat collectLabelY = fromSourceLableY;
    CGFloat collectLabelX = 555*PSDSCALE_X;
    _collectLabelFrame = CGRectMake(collectLabelX, collectLabelY, collectLabelW ,collectLabelH);
    CGFloat collectBtnW = 65*PSDSCALE_X;
    CGFloat collectBtnH = 82*PSDSCALE_Y;
    CGFloat collectBtnY =fromSourceLableY;
    CGFloat collectBtnX = 650*PSDSCALE_X;
    _collectBtnFrame = CGRectMake(collectBtnX, collectBtnY, collectBtnW ,collectBtnH);
    
    
    //分享
    CGFloat shareLabelW = 144*PSDSCALE_X;
    CGFloat shareLabelH = 82*PSDSCALE_Y;
    CGFloat shareLabelY = fromSourceLableY;
    CGFloat shareLabelX = 711*PSDSCALE_X;
    _shareLabelFrame = CGRectMake(shareLabelX, shareLabelY, shareLabelW ,shareLabelH);
    //微信
    CGFloat weChatBtnW = 102*PSDSCALE_X;
    CGFloat weChatBtnH = 82*PSDSCALE_Y;
    CGFloat weChatBtnY = fromSourceLableY;
    CGFloat weChatBtnX = 856*PSDSCALE_X;
    _weChatBtnFrame = CGRectMake(weChatBtnX, weChatBtnY, weChatBtnW ,weChatBtnH);
    //朋友圈
    CGFloat shareBtnW = 102*PSDSCALE_X;
    CGFloat shareBtnH = 82*PSDSCALE_Y;
    CGFloat shareBtnY = fromSourceLableY;
    CGFloat shareBtnX = 958*PSDSCALE_X;
    _friendsBtnFrame= CGRectMake(shareBtnX, shareBtnY, shareBtnW ,shareBtnH);
    _rowHeight = shareBtnY+shareBtnH;
}
@end
