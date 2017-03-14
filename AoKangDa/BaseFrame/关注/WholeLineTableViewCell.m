//
//  WholeLineTableViewCell.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "WholeLineTableViewCell.h"

@implementation WholeLineTableViewCell
{
    UIView *_lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _lineView = lineView;
        [self addSubview:lineView];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _lineView.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
}

@end
