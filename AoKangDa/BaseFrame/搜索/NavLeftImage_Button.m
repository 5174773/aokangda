//
//  NavLeftImage_Button.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/15.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "NavLeftImage_Button.h"

@implementation NavLeftImage_Button


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:19];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        //        [self setImage:[UIImage imageNamed:@"Search_Up"] forState:UIControlStateSelected];
        //        [self setImage:[UIImage imageNamed:@"Search_Up"] forState:UIControlStateHighlighted];
    }
    return self;
}



-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    float heigth = self.frame.size.height * 0.4;
    float width = (30.0f / 47.0f) * heigth;
    
    CGFloat imageTitleGap = 8;
    CGFloat titleWidth = self.frame.size.width - self.frame.size.height * 0.5 - imageTitleGap;
    CGFloat imageX = 10 + width + imageTitleGap;
    
    
    return CGRectMake(imageX, 0, titleWidth, self.frame.size.height);
    
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
 
    float heigth = self.frame.size.height * 0.4;
    float width = (30.0f / 47.0f) * heigth;
    return CGRectMake(10, self.frame.size.height * 0.3, width, heigth);
}


@end
