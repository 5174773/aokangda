//
//  TSCarChannelTableViewCell.m
//  AoKangDa
//
//  Created by showsoft on 15/12/15.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSCarChannelTableViewCell.h"
#import "Public.h"
#import "Header.h"
#import "TSLatestNews.h"
#import "UIImageView+WebCache.h"
#import "TSCarsTableViewCellFrame.h"
@interface TSCarChannelTableViewCell()
@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic ,strong) UILabel* subTitleView;
@property (nonatomic, strong) UILabel  *priceLable;
@property (nonatomic, strong) UIView *separateView;
@end
@implementation TSCarChannelTableViewCell

+(instancetype)CarsTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"cars";
    TSCarChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        //汽车图片
        UIImageView *imaView = [[UIImageView alloc] init];
        [self.contentView addSubview:imaView];
        self.imaView = imaView;
        //主标题
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        self.titleView = titleView;
        self.titleView.numberOfLines = 0;
        self.titleView.textAlignment=NSTextAlignmentRight;
        self.titleView.font=[UIFont systemFontOfSize:KWIDTHShiPei 16.0f];
        
        //副标题
        UILabel *subTitleView = [[UILabel alloc] init];
        [self.contentView addSubview:subTitleView];
        subTitleView.textAlignment=NSTextAlignmentRight;
        subTitleView.textColor=[UIColor lightGrayColor];
        subTitleView.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        self.subTitleView = subTitleView;
        //价格
        UILabel *priceLable = [[UILabel alloc] init];
        [self.contentView addSubview:priceLable];
        self.priceLable = priceLable;
        self.priceLable.textAlignment=NSTextAlignmentRight;
        self.priceLable.textColor=MeDefine_Color;
        self.priceLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 17.0f];
        //分割线
        UIView *separateView = [[UIView alloc] init];
        [self.contentView addSubview:separateView];
        self.separateView = separateView;
        self.separateView.backgroundColor=MeGlobalBackgroundColor;
    }
    return self;
    
}
- (void)setCarsTableViewCellFrame:(TSCarsTableViewCellFrame *)CarsTableViewCellFrame
{
    _CarsTableViewCellFrame = CarsTableViewCellFrame;
    //设置子控件显示的内容
    [self setSubViewsContent];
    //设置子控件的frame
    [self setSubViewsFrame];
}


//设置子控件显示的内容
- (void)setSubViewsContent
{
    TSLatestNews *latestNews = self.CarsTableViewCellFrame.latestNews;
    [self.imaView sd_setImageWithURL:latestNews.Image placeholderImage:[UIImage imageNamed:@"me"]];
    self.titleView.text=latestNews.CarName;
    self.subTitleView.text=latestNews.Remark;
    self.priceLable.text=[NSString stringWithFormat:@"%@ ￥%@万",latestNews.SalePriceState,latestNews.SalePrice];
    
}
//设置子控件的frame
- (void)setSubViewsFrame
{
    self.imaView.frame = self.CarsTableViewCellFrame.imaViewFrame;
    self.titleView.frame = self.CarsTableViewCellFrame.titleViewFrame;
    self.subTitleView.frame = self.CarsTableViewCellFrame.subTitleViewFrame;
    self.priceLable.frame = self.CarsTableViewCellFrame.priceLableFrame;
    self.separateView.frame=self.CarsTableViewCellFrame.separateFrame;
    
}


@end
