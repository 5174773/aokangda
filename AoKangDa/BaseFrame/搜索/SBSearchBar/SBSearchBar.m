//
//  SBSearchBar.m
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import "SBSearchBar.h"

#import "VersionedImage.h"

#define placeStartX  35

@implementation SBSearchBar
{
    UIImageView *_iconView;
}


+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景
        
        self.background = [VersionedImage resizedImageWithName:@"Search_InputBackgorund"];
        
        // 左边的放大镜图标
        UIView *iconBackView = [[UIView alloc]init];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[VersionedImage imageWithName:@"Search_Loupe"]];
        _iconView = iconView;
        [iconBackView addSubview:iconView];
        
        iconBackView.contentMode = UIViewContentModeCenter;
        self.leftView = iconBackView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        

        
        
        // 字体
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = [UIColor whiteColor];
        
        // 右边的清除按钮
//        self.clearButtonMode = UITextFieldViewModeAlways;
        
        // 设置提醒文字
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索车辆" attributes:attrs];
        
        // 设置键盘右下角按钮的样式
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 设置左边图标的frame
    self.leftView.frame = CGRectMake(0, 0, placeStartX, self.frame.size.height);
    if (_iconView) {
        _iconView.frame = CGRectMake(8, self.frame.size.height * 0.25, self.frame.size.height * 0.5, self.frame.size.height * 0.5);
    }
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat placeholderX = placeStartX ;
    return CGRectMake(placeholderX, 0, bounds.size.width - placeholderX, bounds.size.height);
}

@end
