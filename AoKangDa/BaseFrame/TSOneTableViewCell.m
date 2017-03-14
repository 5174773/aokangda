//
//  TSoneTableViewCell.m
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//
#import "Public.h"
#import "WXApi.h"
#import "TSOneTableViewCell.h"
#import "TSEHomeViewNews.h"
#import "UIImageView+WebCache.h"
@interface TSOneTableViewCell ()<WXApiDelegate>
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic, strong) UILabel  *fromSourceLable;
@property (nonatomic, strong) UILabel  *createTimeLable;
@property (nonatomic, strong) UILabel  *collectLabel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UILabel  *shareLable;
@property (nonatomic, strong) UIButton *weChatBtn;
@property (nonatomic, strong) UIButton *friendsBtn;
@end
@implementation TSOneTableViewCell

//1 创建可以重用的自定义cell的对象
+ (instancetype)OneTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"one";
    TSOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
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
        UIImageView *imaView = [[UIImageView alloc] init];
        [self.contentView addSubview:imaView];
        self.imaView = imaView;
        //新闻来源
        UILabel *fromSourceLable = [[UILabel alloc] init];
        [self.contentView addSubview:fromSourceLable];
        self.fromSourceLable = fromSourceLable;
        //新闻发表时间
        UILabel *createTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:createTimeLable];
        self.createTimeLable = createTimeLable;
        self.createTimeLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
        [self.contentView addSubview:createTimeLable];
        //收藏
        UILabel *collectLabel = [[UILabel alloc] init];
        [self.contentView addSubview:collectLabel];
        self.collectLabel = collectLabel;
        
        UIButton *collectBtn=[[UIButton alloc]init];
        [self.contentView addSubview:collectBtn];
        [collectBtn addTarget:self action:@selector(collectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [collectBtn setImage:GETNCIMAGE(@"collect_normal@2x") forState:UIControlStateNormal];
        self.collectBtn=collectBtn;
        
        //分享
        UILabel * sharelabel= [[UILabel alloc] init];
        [self.contentView addSubview:sharelabel];
        _shareLable=sharelabel;
       
        //微信
        UIButton *weChatBtn=[[UIButton alloc]init];
        [self.contentView addSubview:weChatBtn];
        [weChatBtn setImage:GETNCIMAGE(@"weChat@2x") forState:UIControlStateNormal];
        [weChatBtn addTarget:self action:@selector(weChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [weChatBtn setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        self.weChatBtn=weChatBtn;
        //朋友圈
        UIButton *friendsBtn=[[UIButton alloc]init];
        [self.contentView addSubview:friendsBtn];
        [friendsBtn setImage:GETNCIMAGE(@"friendShare@2x") forState:UIControlStateNormal];
        [friendsBtn addTarget:self action:@selector(friendsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
-(void)weChatBtnClicked
{
//    NSLog(@"微信分享按钮被点击了");
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = VALUEFORKEY(self.OneImageViewNews.Share,@"Title");
    
    message.description = VALUEFORKEY(self.OneImageViewNews.Share,@"Content");
    NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.OneImageViewNews.Share,@"Image")];
    UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [message setThumbImage:imag];
    //图片
    WXWebpageObject *ext = [WXWebpageObject object];
    
    ext.webpageUrl = VALUEFORKEY(self.OneImageViewNews.Share,@"Url");
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    
    req.message = message;
    
    req.scene = WXSceneSession;
    
    
    [WXApi sendReq:req];
    
}
-(void)friendsBtnClicked
{
    NSLog(@"朋友圈分享按钮被点击了");
        WXMediaMessage *message = [WXMediaMessage message];
    
        message.title = VALUEFORKEY(self.OneImageViewNews.Share,@"Title");
    
        message.description = VALUEFORKEY(self.OneImageViewNews.Share,@"Content");
        NSURL *imageUrl = [NSURL URLWithString:VALUEFORKEY(self.OneImageViewNews.Share,@"Image")];
        UIImage *imag = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [message setThumbImage:imag];
        //图片
        WXWebpageObject *ext = [WXWebpageObject object];
    
        ext.webpageUrl = VALUEFORKEY(self.OneImageViewNews.Share,@"Url");
    
        message.mediaObject = ext;
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    
        req.bText = NO;
    
        req.message = message;
    
        req.scene = WXSceneTimeline;
        
        
        [WXApi sendReq:req];
}

-(void)collectBtnDidClicked:(UIButton*)sender
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
//设置子控件显示的内容
- (void)setOneImageViewNews:(TSEHomeViewNews *)OneImageViewNews
{
    _OneImageViewNews=OneImageViewNews;

    self.titleView.text=[NSString stringWithFormat:@"%@",OneImageViewNews.Title];
    NSURL *imageURL=OneImageViewNews.Image[0];
    [self.imaView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"me"]];
    
    self.fromSourceLable.text=@"澳康达";
    self.fromSourceLable.textColor=TSEAColor(122, 122, 122, 1);
    self.fromSourceLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
    
    NSString *timeStr=[OneImageViewNews.AddTime substringToIndex:10];
    self.createTimeLable.text=timeStr;
    self.createTimeLable.textColor=TSEAColor(122, 122, 122, 1);
    self.createTimeLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
    
    self.collectLabel.text=@"收藏";
    self.collectLabel.textColor=TSEAColor(122, 122, 122, 1);
    self.collectLabel.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
    
    self.shareLable.text=@"分享至：";
    self.shareLable.textColor=TSEAColor(122, 122, 122, 1);
    self.shareLable.font=[UIFont systemFontOfSize:KWIDTHShiPei 12.0f];
}


//设置子控件的frame
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 20*PSDSCALE_X;
    //标题
    CGFloat titleW = SCREEN_WIDTH-2*margin;
    CGFloat titleH = 127*PSDSCALE_Y;
    CGFloat titleX = margin;
    CGFloat titleY = 0;
    _titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
    //视频图片
    CGFloat imageX = margin;
    CGFloat imageY = titleH;
    CGFloat imageW = SCREEN_WIDTH-2*margin;
    CGFloat imageH = 572*PSDSCALE_Y;
    
    _imaView.frame = CGRectMake(imageX, imageY, imageW ,imageH);
    //新闻来源
    CGFloat fromSourceLableW = 144*PSDSCALE_X;
    CGFloat fromSourceLableH = 82*PSDSCALE_Y;
    CGFloat fromSourceLableY = imageY+imageH;
    CGFloat fromSourceLableX = margin;
    _fromSourceLable.frame = CGRectMake(fromSourceLableX, fromSourceLableY, fromSourceLableW ,fromSourceLableH);
    //上传时间
    CGFloat createTimeLableW = 316*PSDSCALE_X;
    CGFloat createTimeLableH = 82*PSDSCALE_Y;
    CGFloat createTimeLableY = fromSourceLableY;
    CGFloat createTimeLableX = 187*PSDSCALE_X;
    _createTimeLable.frame = CGRectMake(createTimeLableX, createTimeLableY, createTimeLableW ,createTimeLableH);
    
    // 收藏
    CGFloat collectLabelW = 98*PSDSCALE_X;
    CGFloat collectLabelH = 82*PSDSCALE_Y;
    CGFloat collectLabelY = fromSourceLableY;
    CGFloat collectLabelX = 555*PSDSCALE_X;
    _collectLabel.frame= CGRectMake(collectLabelX, collectLabelY, collectLabelW ,collectLabelH);
    CGFloat collectBtnW = 65*PSDSCALE_X;
    CGFloat collectBtnH = 82*PSDSCALE_Y;
    CGFloat collectBtnY =fromSourceLableY;
    CGFloat collectBtnX = 626*PSDSCALE_X;
    _collectBtn.frame= CGRectMake(collectBtnX, collectBtnY, collectBtnW ,collectBtnH);
    
    
    //分享
    CGFloat shareLabelW = 144*PSDSCALE_X;
    CGFloat shareLabelH = 82*PSDSCALE_Y;
    CGFloat shareLabelY = fromSourceLableY;
    CGFloat shareLabelX = 711*PSDSCALE_X;
    _shareLable.frame = CGRectMake(shareLabelX, shareLabelY, shareLabelW ,shareLabelH);
    //微信
    CGFloat weChatBtnW = 102*PSDSCALE_X;
    CGFloat weChatBtnH = 82*PSDSCALE_Y;
    CGFloat weChatBtnY = fromSourceLableY;
    CGFloat weChatBtnX = 856*PSDSCALE_X;
    _weChatBtn.frame = CGRectMake(weChatBtnX, weChatBtnY, weChatBtnW ,weChatBtnH);
    //朋友圈
    CGFloat shareBtnW = 102*PSDSCALE_X;
    CGFloat shareBtnH = 82*PSDSCALE_Y;
    CGFloat shareBtnY = fromSourceLableY;
    CGFloat shareBtnX = 958*PSDSCALE_X;
    _friendsBtn.frame = CGRectMake(shareBtnX, shareBtnY, shareBtnW ,shareBtnH);
//    _rowHeight = 778*PSDSCALE_Y;
}
@end
