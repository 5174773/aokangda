//
//  LeftIamge_Button.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/8.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "LeftIamge_Button.h"


@interface LeftIamge_Button ()



@end

@implementation LeftIamge_Button

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:RGBACOLOR(141, 141, 141, 1) forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Search_Down"] forState:UIControlStateNormal];
    }
    return self;
}



-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageTitleGap = 8;
    CGFloat titleWidth = self.frame.size.width - self.frame.size.height * 0.5 - imageTitleGap;
    CGFloat imageX = self.frame.size.height * 0.5 + imageTitleGap;
    
    
    return CGRectMake(imageX, 0, titleWidth, self.frame.size.height);
    
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return CGRectMake(0, self.frame.size.height * 0.25, self.frame.size.height * 0.5, self.frame.size.height * 0.5);
}


- (void)chooseUpImage
{
    [self setImage:[UIImage imageNamed:@"Search_Up"] forState:UIControlStateSelected];
}

- (void)chooseDownImage
{
    [self setImage:[UIImage imageNamed:@"Search_Down_Color"] forState:UIControlStateSelected];
}

@end
