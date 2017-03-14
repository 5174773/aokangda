//
//  CarBrandTableViewCell.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/9.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CarBrandTableViewCell.h"

#import "RightImage_Button.h"
#import "Public.h"
#import "UIImageView+WebCache.h"
#import "CarSeriesViewController.h"
#import "AppDelegate.h"


#define BothGap 10
#define CarImageViewRation   0.4

@interface CarBrandTableViewCell ()

@property (nonatomic,strong) UIImageView *carImageView;
@property (nonatomic,strong) RightImage_Button *nameButton;

@end

@implementation CarBrandTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIImageView *carImageView = [[UIImageView alloc]init];
    _carImageView = carImageView;
    [self addSubview:carImageView];
    
    RightImage_Button *nameButton = [[RightImage_Button alloc]init];
    [nameButton setImage:[UIImage imageNamed:@"Concernt_rightRow"] forState:UIControlStateNormal];
    [nameButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    _nameButton = nameButton;
    [self addSubview:nameButton];
}


- (void)buttonAction
{
    
    CarSeriesViewController *carSeriesVC = [[CarSeriesViewController alloc]init];
    carSeriesVC.ID = VALUEFORKEY(_infoDict, @"ID");
    carSeriesVC.title = VALUEFORKEY(_infoDict, @"Name");
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)app.window.rootViewController;
    [nav pushViewController:carSeriesVC animated:YES];
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    [_carImageView sd_setImageWithURL:VALUEFORKEY(_infoDict, @"Image")];
    [_nameButton setTitle:VALUEFORKEY(_infoDict, @"Name") forState:UIControlStateNormal];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _carImageView.frame = CGRectMake(BothGap, BothGap, VIEW_W(self) * CarImageViewRation, VIEW_H(self) - 2 * BothGap);
    _nameButton.frame = CGRectMake(VIEW_W_X(_carImageView) + 15, 0.5 * (VIEW_H(self) - ButtonGlobalHeight ), VIEW_W(self) - VIEW_W_X(_carImageView) - 15 - BothGap, ButtonGlobalHeight);
    
}

@end
