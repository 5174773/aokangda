//
//  TSCarsTableViewCellFrame.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSCarsTableViewCellFrame.h"
#import "Public.h"
@implementation TSCarsTableViewCellFrame
-(void)setLatestNews:(TSLatestNews *)latestNews
{
    _latestNews = latestNews;
    CGFloat cellH   = 317*PSDSCALE_Y;
    CGFloat margin  = 29*PSDSCALE_X;
    //视频图片
    CGFloat imageX = margin;
    CGFloat imageW = 461*PSDSCALE_X;
    CGFloat imageH = cellH-2*margin;
    CGFloat imageY = margin;
    _imaViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
    //标题
    CGFloat titleW = SCREEN_WIDTH-3*margin-imageW;
    CGFloat titleH = 130*PSDSCALE_Y;
    CGFloat titleX = 461*PSDSCALE_X+2*margin;
    CGFloat titleY = imageY;
    _titleViewFrame = CGRectMake(titleX, titleY, titleW, titleH);
    
    //副标题
    CGFloat subTitleViewW = titleW;
    CGFloat subTitleViewH = 65*PSDSCALE_Y;
    CGFloat subTitleViewX = titleX;
    CGFloat subTitleViewY = titleY+titleH;
    _subTitleViewFrame = CGRectMake(subTitleViewX, subTitleViewY, subTitleViewW, subTitleViewH);
    
    //价格
    CGFloat priceLableW = titleW;
    CGFloat priceLableH = 65*PSDSCALE_Y;
    CGFloat priceLableX = titleX;
    CGFloat priceLableY = subTitleViewY+subTitleViewH;
    _priceLableFrame = CGRectMake(priceLableX, priceLableY, priceLableW, priceLableH);
    _rowHeight = cellH;
}

@end
