//
//  Right_Button.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/9.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "RightImage_Button.h"

@implementation RightImage_Button

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:21];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Concernt_rightRow"] forState:UIControlStateNormal];
    }
    return self;
}



-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat imageTitleGap = 10;
    float imageWidth = self.frame.size.height * 0.5 * (16.0f / 28.0f);

    return CGRectMake(0, 0, self.frame.size.width - imageWidth - imageTitleGap, self.frame.size.height);
    
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    float imageWidth = self.frame.size.height * 0.5 * (16.0f / 28.0f);
    
    return CGRectMake(self.frame.size.width - imageWidth, self.frame.size.height * 0.25, imageWidth, self.frame.size.height * 0.5);
}


@end
