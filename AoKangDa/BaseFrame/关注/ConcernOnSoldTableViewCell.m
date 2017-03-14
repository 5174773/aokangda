//
//  ConcernOnSoldTableViewCell.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "ConcernOnSoldTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "Public.h"

#define BothGap  10
#define CarImageViewRation   0.4

@interface ConcernOnSoldTableViewCell ()

@property (nonatomic,strong)UIImageView *tipImageView;
@property (nonatomic,strong)UIImageView *carImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *remark;
@property (nonatomic,strong)UILabel *priceLabel;

@end

@implementation ConcernOnSoldTableViewCell

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
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = MeNorMalFontColor;
    nameLabel.text = @"";
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    UILabel *remark = [[UILabel alloc]init];
    remark.textAlignment = NSTextAlignmentRight;
    remark.text = @"";
    remark.font = [UIFont systemFontOfSize:11];
    remark.textColor = [UIColor lightGrayColor];
    _remark = remark;
    [self addSubview:remark];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = @"";
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textColor = MeDefine_Color;
    
    _priceLabel = priceLabel;
    [self addSubview:priceLabel];
    
    
    UIImageView *tipImageView = [[UIImageView alloc]init];
    tipImageView.image = [UIImage imageNamed:@"Concern_Tip"];
    tipImageView.hidden = YES;
    _tipImageView = tipImageView;
    [self addSubview:tipImageView];
    
}


-(void)setCarInfo:(NSDictionary *)carInfo
{
    [_carImageView sd_setImageWithURL:VALUEFORKEY(carInfo, @"Image")];
    _nameLabel.text = VALUEFORKEY(carInfo, @"CarName");
    _remark.text = VALUEFORKEY(carInfo, @"Remark");
    _priceLabel.text = [NSString stringWithFormat:@"%@ ￥%@万",VALUEFORKEY(carInfo, @"SalePriceState"),VALUEFORKEY(carInfo, @"SalePrice")];
    if ([[NSString stringWithFormat:@"%@",VALUEFORKEY(carInfo, @"IsTejia")]  isEqualToString:@"1"]) {
        _tipImageView.hidden = NO;
    }else{
        _tipImageView.hidden = YES;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //
    _tipImageView.frame = CGRectMake(BothGap * 0.5, BothGap * 0.5, BothGap * 1.5, BothGap * 1.5);
    
    
    //
    _carImageView.frame = CGRectMake(BothGap, BothGap,VIEW_W(self) * CarImageViewRation, VIEW_H(self) - BothGap * 2);

    
    
    //
    float lableUsedHeight = VIEW_H(self) - BothGap * 2;
    
    _nameLabel.frame = CGRectMake(VIEW_W(self) * CarImageViewRation + BothGap + 4, BothGap,VIEW_W(self) * (1 - CarImageViewRation) - BothGap * 2 - 4, lableUsedHeight * 3.0 / 10.0f);
    
    _remark.frame = CGRectMake(VIEW_W(self) * CarImageViewRation + BothGap + 4, BothGap + lableUsedHeight * (3 / 10.0f),VIEW_W(self) * (1 - CarImageViewRation) - BothGap * 2 - 4, lableUsedHeight  * 2.0 /10.0f);

    _priceLabel.frame = CGRectMake(VIEW_W(self) * CarImageViewRation + BothGap + 4, BothGap + lableUsedHeight * (7 / 10.0f),VIEW_W(self) * (1 - CarImageViewRation) - BothGap * 2 - 4, lableUsedHeight  * 3.0 / 10.0f);
}

@end
