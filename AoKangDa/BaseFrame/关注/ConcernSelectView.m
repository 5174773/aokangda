//
//  ConcernSelectView.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/9.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "ConcernSelectView.h"
#import "Public.h"

#define SelectView_Color    RGBACOLOR(237, 243, 244, 1)



@interface ConcernSelectView ()

@property (nonatomic,strong) UIImageView *backView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *lineView;
@property (nonatomic,strong) UIImageView *selectView;

@property (nonatomic,strong) UIButton *actionButton;

@end
@implementation ConcernSelectView


-(instancetype)init
{
    if (self == [super init]) {
        
        [self initUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{

    self.userInteractionEnabled = YES;
    
    self.backgroundColor = SelectView_Color;
    //
    UIImageView *backView = [[UIImageView alloc]init];
    backView.userInteractionEnabled = YES;
    backView.image = [UIImage imageNamed:@"Concern_SelectBackground"];
    _backView = backView;
    [self addSubview:backView];
    
    //
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.userInteractionEnabled = YES;
    [backView addSubview:nameLabel];
    nameLabel.textColor = MeNorMalFontColor;
    nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel = nameLabel;
    ///
    UIImageView *lineView = [[UIImageView alloc]init];
    lineView.userInteractionEnabled = YES;
    lineView.image = [UIImage imageNamed:@"Concern_Line"];
    [backView addSubview:lineView];
    lineView.alpha = 0.3;
    _lineView = lineView;
    
    
    ///
    UIView *selectBackView = [[UIView alloc]init];
    selectBackView.userInteractionEnabled = YES;
//    selectBackView.backgroundColor = [UIColor greenColor];.
    [backView addSubview:selectBackView];
    

    UIImageView *selectView = [[UIImageView alloc]init];
    selectView.userInteractionEnabled = YES;
    selectView.image = [UIImage imageNamed:@"Concernt_rightRow"];
    [selectBackView addSubview:selectView];
    _selectView = selectView;
    
    
    UIButton *actionButton = [[UIButton alloc]init];
    actionButton.userInteractionEnabled = YES;
    [actionButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    _actionButton = actionButton;
    [backView addSubview:actionButton];
    
    
    

}

-(void)setName:(NSString *)name
{
    _name = name;
    
    _nameLabel.text = _name;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    float bothGap = 25;
    
    _backView.frame = CGRectMake(bothGap, (VIEW_H(self) - ButtonGlobalHeight) * 0.6, VIEW_W(self) - bothGap * 2, ButtonGlobalHeight);
    _nameLabel.frame = CGRectMake(25, 0, 270, VIEW_H(_backView));
    _selectView.superview.frame = CGRectMake(VIEW_W(_backView) - ButtonGlobalHeight - 10, 0,ButtonGlobalHeight, ButtonGlobalHeight);
    
    _actionButton.frame = CGRectMake(0, 0, VIEW_W(_backView), VIEW_H(_backView));
    
    float rotation = VIEW_H(_backView) * 0.5 / 28.0f;
    
    _selectView.frame = CGRectMake((VIEW_W(_selectView.superview) - 16 * rotation)* 0.5, (VIEW_H(_selectView.superview) - VIEW_H(_backView) * 0.5) * 0.5, 16 * rotation, VIEW_H(_backView) * 0.5);
    _lineView.frame = CGRectMake(VIEW_X(_selectView.superview) - 1, VIEW_H(_backView) * 0.25, 1, VIEW_H(_backView) * 0.5);
    
}


- (void)tapAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(ConcernSelectViewtapAction:)]) {
        [_delegate ConcernSelectViewtapAction:self];
    }
}


@end
