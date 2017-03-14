//
//  TSCarTableViewCell.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSCarsTableViewCell.h"
#import "Public.h"
#import "Header.h"
#import "TSEHomeViewNews.h"
#import "TSLatestNews.h"
#import "UIImageView+WebCache.h"
@interface TSCarsTableViewCell()
@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic ,strong) UILabel* subTitleView;
@property (nonatomic, strong) UILabel  *priceLable;
@property (nonatomic, strong) UIView *separateView;
@end
@implementation TSCarsTableViewCell
+(instancetype)CarsTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"cars";
    TSCarsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        //汽车图片
        UIImageView *imaView = [[UIImageView alloc] init];
        [self.contentView addSubview:imaView];
        imaView.clipsToBounds = YES;
        imaView.contentMode=UIViewContentModeScaleAspectFill;
        self.imaView = imaView;
  
        //分割线
        UIView *separateView = [[UIView alloc] init];
        [self.contentView addSubview:separateView];
        self.separateView = separateView;
        self.separateView.backgroundColor=MeGlobalBackgroundColor;
    }
      return self;

}
- (void)setCarsViewNews:(TSEHomeViewNews *)CarsViewNews
{
   _CarsViewNews = CarsViewNews;
    //设置子控件显示的内容
    NSURL *imageUrl=[NSURL URLWithString:CarsViewNews.Image[0]];
    [self.imaView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"me"]];
   
}

//设置子控件的frame
- (void)layoutSubviews
{
    CGFloat cellH   = 317*PSDSCALE_Y;
    CGFloat margin  = 20*PSDSCALE_X;
    //视频图片
    CGFloat imageX = margin;
    CGFloat imageY = margin;
    CGFloat imageW = SCREEN_WIDTH-2*margin;
    CGFloat imageH = cellH-2*margin;
    _imaView.frame= CGRectMake(imageX, imageY, imageW, imageH);
    
}

@end
