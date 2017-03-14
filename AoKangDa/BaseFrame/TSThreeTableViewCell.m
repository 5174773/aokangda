//
//  TSThreeTableViewCell.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//
#import "Public.h"
#import "WXApi.h"
#import "TSEHomeViewNews.h"
#import "UIImageView+WebCache.h"
#import "TSThreeTableViewCell.h"
@interface TSThreeTableViewCell ()<WXApiDelegate>
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIImageView *oneimaView;
@property (nonatomic, strong) UIImageView *twoimaView;
@property (nonatomic, strong) UIImageView *threeimaView;
@property (nonatomic, strong) UILabel  *fromSourceLable;
@property (nonatomic, strong) UILabel  *createTimeLable;
@property (nonatomic, strong) UILabel  *collectLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UILabel  *shareLable;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *friendsBtn;
@end
@implementation TSThreeTableViewCell

//1 创建可以重用的自定义cell的对象
+ (instancetype)ThreeTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"three";
    TSThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//2 创建自定义cell内部的子控件）
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        //标题
        UILabel *titleView = [[UILabel alloc] init];
        [self.contentView addSubview:titleView];
        self.titleView = titleView;
        self.titleView.numberOfLines = 0;
        self.titleView.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
        //图片
        UIImageView *oneimaView = [[UIImageView alloc] init];
        [self.contentView addSubview:oneimaView];
        self.oneimaView = oneimaView;
        UIImageView *twoimaView = [[UIImageView alloc] init];
        [self.contentView addSubview:twoimaView];
        self.twoimaView = twoimaView;
        UIImageView *threeimaView = [[UIImageView alloc] init];
        [self.contentView addSubview:threeimaView];
        self.threeimaView = threeimaView;
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
        createTimeLable.font=[UIFont systemFontOfSize:12.0f];
        self.createTimeLable = createTimeLable;

        
        //收藏
        UILabel *collectLabel = [[UILabel alloc] init];
        [self.contentView addSubview:collectLabel];
        collectLabel.textColor=TSEAColor(122, 122, 122, 1);
        collectLabel.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        self.collectLabel = collectLabel;
        
        UIButton *collectBtn=[[UIButton alloc]init];
        [self.contentView addSubview:collectBtn];
        [collectBtn addTarget:self action:@selector(collectBtnDidClicks:) forControlEvents:UIControlEventTouchUpInside];
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
        sharelabel.textColor=TSEAColor(122, 122, 122, 1);
        sharelabel.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
        [self.contentView addSubview:sharelabel];
        self.shareLable=sharelabel;

        //微信
        UIButton *weChatBtn=[[UIButton alloc]init];
        [self.contentView addSubview:weChatBtn];
        [weChatBtn setImage:GETNCIMAGE(@"weChat@2x") forState:UIControlStateNormal];
        [weChatBtn addTarget:self action:@selector(weChatBtnisClicked) forControlEvents:UIControlEventTouchUpInside];
        [weChatBtn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.weChatBtn=weChatBtn;
        //朋友圈
        UIButton *friendsBtn=[[UIButton alloc]init];
        [self.contentView addSubview:friendsBtn];
        [friendsBtn addTarget:self action:@selector(friendsBtnisClicked) forControlEvents:UIControlEventTouchUpInside];
        [friendsBtn setImage:GETNCIMAGE(@"friendShare@2x") forState:UIControlStateNormal];
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
-(void)weChatBtnisClicked
{
    NSLog(@"微信分享按钮被点击了");
        WXMediaMessage *message = [WXMediaMessage message];
    
        message.title = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Title");
    
        message.description = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Content");
        NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.ThreeImageViewNews.Share,@"Image")];
        UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [message setThumbImage:imag];
        //图片
        WXWebpageObject *ext = [WXWebpageObject object];
    
        ext.webpageUrl = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Url");
    
        message.mediaObject = ext;
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
        req.bText = NO;
    
        req.message = message;
    
        req.scene = WXSceneSession;
    
    
        [WXApi sendReq:req];
    
}
-(void)friendsBtnisClicked
{
    NSLog(@"朋友圈分享按钮被点击了");
        WXMediaMessage *message = [WXMediaMessage message];
    
        message.title = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Title");
    
        message.description = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Content");
        NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.ThreeImageViewNews.Share,@"Image")];
        UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [message setThumbImage:imag];
        //图片
        WXWebpageObject *ext = [WXWebpageObject object];
    
        ext.webpageUrl = VALUEFORKEY(self.ThreeImageViewNews.Share,@"Url");
    
        message.mediaObject = ext;
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
        req.bText = NO;
    
        req.message = message;
    
        req.scene = WXSceneTimeline;
    
    
        [WXApi sendReq:req];
}
-(void)collectBtnDidClicks:(UIButton*)sender
{
    self.collectBtn.selected=!self.collectBtn.selected;
    
    if (self.collectBtn.selected) {
        [self.collectBtn setImage:GETNCIMAGE(@"collect_click@2x") forState:UIControlStateSelected];
        NSLog(@"收藏按钮被点击了");
    }
    else
    {
        [self.collectBtn setImage:GETNCIMAGE(@"collect_normal@2x") forState:UIControlStateNormal];
        NSLog(@"取消收藏");
    }
    
}

- (void)setThreeImageViewNews:(TSEHomeViewNews *)ThreeImageViewNews
{
    _ThreeImageViewNews =ThreeImageViewNews ;
    //设置子控件显示的内容

    self.titleView.text=ThreeImageViewNews.Title;
    NSURL *oneimageURL=ThreeImageViewNews.Image[0];
    NSURL *twoimageURL=ThreeImageViewNews.Image[1];
    NSURL *threeimageURL=ThreeImageViewNews.Image[2];
    
    [self.oneimaView sd_setImageWithURL:oneimageURL placeholderImage:[UIImage imageNamed:@"me"]];
    [self.twoimaView sd_setImageWithURL:twoimageURL placeholderImage:[UIImage imageNamed:@"me"]];
    [self.threeimaView sd_setImageWithURL:threeimageURL placeholderImage:[UIImage imageNamed:@"me"]];
    //作者
    self.fromSourceLable.text=ThreeImageViewNews.Author;
    //时间
    NSString *timeStr=[ThreeImageViewNews.AddTime substringToIndex:10];
    self.createTimeLable.text=timeStr;
    //收藏
    self.collectLabel.text=@"收藏";
    //分享
    self.shareLable.text=@"分享至：";

}
//设置子控件的frame
- (void)layoutSubviews
{
    
    CGFloat margin = 20*PSDSCALE_X;
    //标题
    CGFloat titleW = SCREEN_WIDTH-2*margin;
    CGFloat titleH = 115*PSDSCALE_Y;
    CGFloat titleX = margin;
    CGFloat titleY = margin;
    _titleView.frame= CGRectMake(titleX, titleY, titleW, titleH);
    //视频图片
    
    CGFloat imageW = (SCREEN_WIDTH-4*margin)/3;
    CGFloat imageX = 20*PSDSCALE_X+0*(20*PSDSCALE_X+imageW);
    CGFloat imageY = titleH+margin;
    CGFloat imageH = 187*PSDSCALE_Y;
    _oneimaView.frame = CGRectMake(imageX, imageY, imageW ,imageH);
    //视频图片
    
    CGFloat twoImageX = 20*PSDSCALE_X+1*(20*PSDSCALE_X+imageW);
    CGFloat twoImageY = imageY;
    CGFloat twoImageW = (SCREEN_WIDTH-4*margin)/3;
    CGFloat twoImageH = 187*PSDSCALE_Y;
    _twoimaView.frame = CGRectMake(twoImageX, twoImageY, twoImageW ,twoImageH);
    
    //视频图片
    
    CGFloat threeImageX = 20*PSDSCALE_X+2*(20*PSDSCALE_X+imageW);
    CGFloat threeImageY = imageY;
    CGFloat threeImageW = (SCREEN_WIDTH-4*margin)/3;
    CGFloat threeImageH = 187*PSDSCALE_Y;
    _threeimaView.frame= CGRectMake(threeImageX, threeImageY, threeImageW ,threeImageH);
    
    //新闻来源
    CGFloat fromSourceLableW = 144*PSDSCALE_X;
    CGFloat fromSourceLableH = 87*PSDSCALE_Y;
    CGFloat fromSourceLableY = imageY+imageH;
    CGFloat fromSourceLableX = margin;
    _fromSourceLable.frame = CGRectMake(fromSourceLableX, fromSourceLableY, fromSourceLableW ,fromSourceLableH);
    //上传时间
    CGFloat createTimeLableW = 316*PSDSCALE_X;
    CGFloat createTimeLableH = fromSourceLableH;
    CGFloat createTimeLableY = fromSourceLableY;
    CGFloat createTimeLableX = 187*PSDSCALE_X;
    _createTimeLable.frame = CGRectMake(createTimeLableX, createTimeLableY, createTimeLableW ,createTimeLableH);
    
    // 收藏
    CGFloat collectLabelW = 98*PSDSCALE_X;
    CGFloat collectLabelH = fromSourceLableH;
    CGFloat collectLabelY = fromSourceLableY;
    CGFloat collectLabelX = 555*PSDSCALE_X;
    _collectLabel.frame = CGRectMake(collectLabelX, collectLabelY, collectLabelW ,collectLabelH);
    
    CGFloat collectBtnW = 65*PSDSCALE_X;
    CGFloat collectBtnH = fromSourceLableH;
    CGFloat collectBtnY = fromSourceLableY;
    CGFloat collectBtnX = 626*PSDSCALE_X;
    _collectBtn.frame = CGRectMake(collectBtnX, collectBtnY, collectBtnW ,collectBtnH);
    
    
    //分享
    CGFloat shareLabelW = 144*PSDSCALE_X;
    CGFloat shareLabelH =fromSourceLableH;
    CGFloat shareLabelY =fromSourceLableY;
    CGFloat shareLabelX = 711*PSDSCALE_X;
    _shareLable.frame = CGRectMake(shareLabelX, shareLabelY, shareLabelW ,shareLabelH);
    //微信
    CGFloat weChatBtnW = 102*PSDSCALE_X;
    CGFloat weChatBtnH = fromSourceLableH;
    CGFloat weChatBtnY = fromSourceLableY;
    CGFloat weChatBtnX = 856*PSDSCALE_X;
    _weChatBtn.frame = CGRectMake(weChatBtnX, weChatBtnY, weChatBtnW ,weChatBtnH);
    //朋友圈
    CGFloat shareBtnW = 102*PSDSCALE_X;
    CGFloat shareBtnH = fromSourceLableH;
    CGFloat shareBtnY = fromSourceLableY;
    CGFloat shareBtnX = 958*PSDSCALE_X;
    _friendsBtn.frame= CGRectMake(shareBtnX, shareBtnY, shareBtnW ,shareBtnH);

}

@end
