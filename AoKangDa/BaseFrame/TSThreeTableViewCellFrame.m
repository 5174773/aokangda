//
//  TSThreeTableViewCellFrame.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSThreeTableViewCellFrame.h"
#import "TSEHomeViewNews.h"
#import "Public.h"
@implementation TSThreeTableViewCellFrame
-(void)setThreeViewNews:(TSEHomeViewNews *)ThreeViewNews
{
    _ThreeViewNews = ThreeViewNews;
    
    CGFloat margin = 20*PSDSCALE_X;
    //标题
    CGFloat titleW = SCREEN_WIDTH-2*margin;
    CGFloat titleH = 130*PSDSCALE_Y;
    CGFloat titleX = margin;
    CGFloat titleY = margin;
    _titleViewFrame = CGRectMake(titleX, titleY, titleW, titleH);
    //视频图片
 
        CGFloat imageX = 20*PSDSCALE_X+0*(10*PSDSCALE_X+331*PSDSCALE_X);
        CGFloat imageY = 150*PSDSCALE_Y;
        CGFloat imageW = (SCREEN_WIDTH-3*margin)/3;
        CGFloat imageH = 187*PSDSCALE_Y;
  _oneimaViewFrame = CGRectMake(imageX, imageY, imageW ,imageH);
    //视频图片
    
    CGFloat twoImageX = 20*PSDSCALE_X+1*(10*PSDSCALE_X+331*PSDSCALE_X);
    CGFloat twoImageY = 150*PSDSCALE_Y;
    CGFloat twoImageW = (SCREEN_WIDTH-3*margin)/3;
    CGFloat twoImageH = 187*PSDSCALE_Y;
    _twoimaViewFrame = CGRectMake(twoImageX, twoImageY, twoImageW ,twoImageH);
    
    //视频图片
    
    CGFloat threeImageX = 20*PSDSCALE_X+2*(10*PSDSCALE_X+331*PSDSCALE_X);
    CGFloat threeImageY = 150*PSDSCALE_Y;
    CGFloat threeImageW = (SCREEN_WIDTH-3*margin)/3;
    CGFloat threeImageH = 187*PSDSCALE_Y;
    _threeimaViewFrame = CGRectMake(threeImageX, threeImageY, threeImageW ,threeImageH);
    
    //新闻来源
    CGFloat fromSourceLableW = 144*PSDSCALE_X;
    CGFloat fromSourceLableH = 79*PSDSCALE_Y;
    CGFloat fromSourceLableY = 720*PSDSCALE_Y;
    CGFloat fromSourceLableX = margin;
    _fromSourceLableFrame = CGRectMake(fromSourceLableX, fromSourceLableY, fromSourceLableW ,fromSourceLableH);
    //上传时间
    CGFloat createTimeLableW = 316*PSDSCALE_X;
    CGFloat createTimeLableH = 79*PSDSCALE_Y;
    CGFloat createTimeLableY = 720*PSDSCALE_Y;
    CGFloat createTimeLableX = 187*PSDSCALE_X;
    _createTimeLableFrame = CGRectMake(createTimeLableX, createTimeLableY, createTimeLableW ,createTimeLableH);
    
    // 收藏
    CGFloat collectLabelW = 98*PSDSCALE_X;
    CGFloat collectLabelH = 79*PSDSCALE_Y;
    CGFloat collectLabelY = 720*PSDSCALE_Y;
    CGFloat collectLabelX = 605*PSDSCALE_X;
    _collectLabelFrame = CGRectMake(collectLabelX, collectLabelY, collectLabelW ,collectLabelH);
    CGFloat collectBtnW = 65*PSDSCALE_X;
    CGFloat collectBtnH = 79*PSDSCALE_Y;
    CGFloat collectBtnY = 720*PSDSCALE_Y;
    CGFloat collectBtnX = 706*PSDSCALE_X;
    _collectBtnFrame = CGRectMake(collectBtnX, collectBtnY, collectBtnW ,collectBtnH);
    
    
    //分享
    CGFloat shareLabelW = 144*PSDSCALE_X;
    CGFloat shareLabelH = 79*PSDSCALE_Y;
    CGFloat shareLabelY = 720*PSDSCALE_Y;
    CGFloat shareLabelX = 778*PSDSCALE_X;
    _shareLableFrame = CGRectMake(shareLabelX, shareLabelY, shareLabelW ,shareLabelH);
    //微信
    CGFloat weChatBtnW = 70*PSDSCALE_X;
    CGFloat weChatBtnH = 79*PSDSCALE_Y;
    CGFloat weChatBtnY = 720*PSDSCALE_Y;
    CGFloat weChatBtnX = 922*PSDSCALE_X;
    _weChatBtnFrame = CGRectMake(weChatBtnX, weChatBtnY, weChatBtnW ,weChatBtnH);
    //朋友圈
    CGFloat shareBtnW = 70*PSDSCALE_X;
    CGFloat shareBtnH = 79*PSDSCALE_Y;
    CGFloat shareBtnY = 720*PSDSCALE_Y;
    CGFloat shareBtnX = 994*PSDSCALE_X;
    _friendsBtnFrame= CGRectMake(shareBtnX, shareBtnY, shareBtnW ,shareBtnH);
    _rowHeight = 778*PSDSCALE_Y;
}
@end
