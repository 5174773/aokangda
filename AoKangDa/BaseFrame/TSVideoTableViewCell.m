//
//  TSVideoTableViewCell.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//
#import "Public.h"
#import "TSCarNews.h"
#import "TSEHomeViewNews.h"
#import "UIImageView+WebCache.h"
#import "TSVideoTableViewCell.h"
#import "TSCarTableViewCellFrame.h"
@interface TSVideoTableViewCell() 
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic, strong) UIImageView *playBtn;
@property (nonatomic ,strong) UILabel* totalTimeLable;
@property (nonatomic, strong) UILabel  *fromSourceLable;
@property (nonatomic, strong) UILabel  *createTimeLable;
@property (nonatomic, strong) UILabel  *collectLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UILabel  *shareLable;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *friendsBtn;


@property (nonatomic,assign) int *collectNum;
@end

@implementation TSVideoTableViewCell
+(instancetype)CarTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"shipin";
    TSVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
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
        //标题
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        titleView.font=[UIFont systemFontOfSize:KWIDTHShiPei 16.0f];
        self.titleView = titleView;
        //图片
        UIImageView *imaView = [[UIImageView alloc] init];
        [self.contentView addSubview:imaView];
        self.imaView = imaView;
        //播放按钮
        UIImageView *playBtn=[[UIImageView alloc]init];
        [self.contentView addSubview:playBtn];
        playBtn.image=GETNCIMAGE(@"playMovie");
        self.playBtn=playBtn;
        
        //视频时长
        UILabel *totalTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:totalTimeLable];
        totalTimeLable.textColor=[UIColor whiteColor];
        totalTimeLable.layer.masksToBounds=YES;
        totalTimeLable.layer.cornerRadius=7.5f;
        totalTimeLable.textAlignment=NSTextAlignmentCenter;
        totalTimeLable.backgroundColor=TSEColor(107, 110, 118);
        totalTimeLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        self.totalTimeLable = totalTimeLable;
        //新闻来源
        UILabel *fromSourceLable = [[UILabel alloc] init];
        [self.contentView addSubview:fromSourceLable];
        fromSourceLable.textColor=TSEAColor(122, 122, 122, 1);
        fromSourceLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        self.fromSourceLable = fromSourceLable;
       
        //新闻发表时间
        UILabel *createTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:createTimeLable];
        createTimeLable.textColor=TSEAColor(122, 122, 122, 1);
        self.createTimeLable = createTimeLable;
        createTimeLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        
        //收藏
        UILabel *collectLabel = [[UILabel alloc] init];
        [self.contentView addSubview:collectLabel];
        self.collectLabel = collectLabel;
        collectLabel.textColor=TSEAColor(122, 122, 122, 1);
        collectLabel.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        
        UIButton *collectBtn=[[UIButton alloc]init];
        [self.contentView addSubview:collectBtn];
        [collectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50*PSDSCALE_X, 0, 0)];
        [collectBtn addTarget:self action:@selector(collectBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        if (collectBtn.selected) {
             [collectBtn setImage:GETNCIMAGE(@"collect_click@2x") forState:UIControlStateSelected];
        }
        else
        {
           [collectBtn setImage:GETNCIMAGE(@"collect_normal@2x") forState:UIControlStateNormal];
        }
        self.collectBtn=collectBtn;
        //分享
        UILabel * sharelabel= [[UILabel alloc] init];
        [self.contentView addSubview:sharelabel];
        sharelabel.textColor=TSEAColor(122, 122, 122, 1);
        sharelabel.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        self.shareLable=sharelabel;
        //微信
        UIButton *weChatBtn=[[UIButton alloc]init];
        [self.contentView addSubview:weChatBtn];
        [weChatBtn setImage:GETNCIMAGE(@"weChat@2x") forState:UIControlStateNormal];
        [weChatBtn addTarget:self action:@selector(weChatBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [weChatBtn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.weChatBtn=weChatBtn;
        //朋友圈
        UIButton *friendsBtn=[[UIButton alloc]init];
        [self.contentView addSubview:friendsBtn];
        [friendsBtn setImage:GETNCIMAGE(@"friendShare@2x") forState:UIControlStateNormal];
        [friendsBtn addTarget:self action:@selector(friendsBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [friendsBtn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.friendsBtn=friendsBtn;
    }
    return self;
    
}
//  button1高亮状态下的背景色
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)collectBtnDidClick:(UIButton*)sender
{
    self.collectBtn.selected=!self.collectBtn.selected;
//    self.collectNum +=1;
//    NSString *Comparestr=[NSString stringWithFormat:@"%@",self.collectNum%2];
    if (self.collectBtn.selected) {
//        self.collectBtn.selected=YES;
        [self.collectBtn setImage:GETNCIMAGE(@"collect_click@2x") forState:UIControlStateSelected];
        NSLog(@"收藏按钮被点击了");
    }
    else
    {
        [self.collectBtn setImage:GETNCIMAGE(@"collect_normal@2x") forState:UIControlStateSelected];
        NSLog(@"取消收藏");
    }
  
}
-(void)weChatBtnDidClick
{
     NSLog(@"微信分享按钮被点击了");
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"564c1dc5e0f55a4ee0000859"
//                                      shareText:@"你要分享的文字"
//                                     shareImage:[UIImage imageNamed:@"icon"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
//                                       delegate:self];
}
-(void)friendsBtnDidClick
{
    NSLog(@"朋友圈分享按钮被点击了");
}
- (void)setCarTableViewCellFrame:(TSCarTableViewCellFrame *)CarTableViewCellFrame
{
    _CarTableViewCellFrame = CarTableViewCellFrame;
    //设置子控件显示的内容
    [self setSubViewsContent];
    //设置子控件的frame
    [self setSubViewsFrame];
}


//设置子控件显示的内容
- (void)setSubViewsContent
{
    TSCarNews *carNews = self.CarTableViewCellFrame.carNews;
    self.titleView.text=carNews.Title;
    [self.imaView sd_setImageWithURL:carNews.Image placeholderImage:[UIImage imageNamed:@"me"]];
    //self.createTimeLable.text=homeViewNews.AddTime;
    self.totalTimeLable.text=carNews.ShipinShichang;
    self.fromSourceLable.text=carNews.Author;
    NSString *TimeStr=[carNews.AddTime substringToIndex:10];
    self.createTimeLable.text=TimeStr;
    self.collectLabel.text=@"收藏";
    self.shareLable.text=@"分享至：";

}
//设置子控件的frame
- (void)setSubViewsFrame
{
    self.titleView.frame = self.CarTableViewCellFrame.titleLabelFrame;
    self.imaView.frame = self.CarTableViewCellFrame.imageViewFrame;
    self.playBtn.frame=self.CarTableViewCellFrame.playBtnFrame;
    self.totalTimeLable.frame=self.CarTableViewCellFrame.totaltimeFrame;
    self.fromSourceLable.frame = self.CarTableViewCellFrame.fromSourceLableFrame;
    self.createTimeLable.frame = self.CarTableViewCellFrame.createTimeLableFrame;
    self.collectLabel.frame = self.CarTableViewCellFrame.collectLabelFrame;
    self.collectBtn.frame=self.CarTableViewCellFrame.collectBtnFrame;
    self.shareLable.frame=self.CarTableViewCellFrame.shareLabelFrame;
    self.weChatBtn.frame=self.CarTableViewCellFrame.weChatBtnFrame;
    self.friendsBtn.frame=self.CarTableViewCellFrame.friendsBtnFrame;
    
}
@end
