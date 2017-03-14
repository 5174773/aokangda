//
//  TSCarDetailViewController.m
//  AoKangDa
//
//  Created by showsoft on 15/12/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "TSCarDetailViewController.h"

#import "TSEXCARLoopView.h"
#import "UIImageView+WebCache.h"
#import "NSString+AutoHeight.h"

#import "MoreConfigViewController.h"

#import "ConcernOnSoldTableViewCell.h"
#import "Public.h"

@interface TSCarDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGRect segControl_frame;
    NSArray *section_name_array;
    
    BOOL isClickSegControl;
}

@property (nonatomic, strong) TSEXCARLoopView *alLoop_view;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segControl;

@property (nonatomic, strong) NSMutableArray *ADimagesArr;

@property (nonatomic, copy) NSString *summary; // 车辆概述

@property (nonatomic, assign) BOOL isShowConfig;  // 是否显示更多配置

@property (nonatomic, strong) NSMutableArray *bodyFirstImageArr;
@property (nonatomic, strong) NSMutableArray *bodyImagesArr; // 车身外观

@property (nonatomic, strong) NSMutableArray *interiorFirstArr;
@property (nonatomic, strong) NSMutableArray *interiorArr; // 车身外观

@property (nonatomic, strong) NSMutableArray *engineFirstArr;
@property (nonatomic, strong) NSMutableArray *engineArr; // 车身外观

@property (nonatomic, strong) NSMutableArray *samePriceCarsArr;  // 同价格车推荐
@property (nonatomic, strong) NSMutableArray *sameBrandCarsArr;  // 同品牌车推荐
@end

@implementation TSCarDetailViewController

- (NSMutableArray *)bodyFirstImageArr
{
    if (!_bodyFirstImageArr) {
        _bodyFirstImageArr = [NSMutableArray array];
    }
    
    return _bodyFirstImageArr;
}

- (NSMutableArray *)bodyImagesArr
{
    if (!_bodyImagesArr) {
        _bodyImagesArr = [NSMutableArray array];
    }
    
    return _bodyImagesArr;
}

- (NSMutableArray *)interiorArr
{
    if (!_interiorArr) {
        _interiorArr = [NSMutableArray array];
    }
    
    return _interiorArr;
}

- (NSMutableArray *)interiorFirstArr
{
    if (!_interiorFirstArr) {
        _interiorFirstArr = [NSMutableArray array];
    }
    
    return _interiorFirstArr;
}

- (NSMutableArray *)engineArr
{
    if (!_engineArr) {
        _engineArr = [NSMutableArray array];
    }
    
    return _engineArr;
}

- (NSMutableArray *)engineFirstArr
{
    if (!_engineFirstArr) {
        _engineFirstArr = [NSMutableArray array];
    }
    
    return _engineFirstArr;
}

- (NSMutableArray *)samePriceCarsArr
{
    if (!_samePriceCarsArr) {
        _samePriceCarsArr = [NSMutableArray array];
    }
    
    return _samePriceCarsArr;
}

- (NSMutableArray *)sameBrandCarsArr
{
    if (!_sameBrandCarsArr) {
        _sameBrandCarsArr = [NSMutableArray array];
    }
    
    return _sameBrandCarsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackButton:NO];
    [self addStatusBlackBackground];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Car_logo"]];
    
    section_name_array = @[@"车辆概述", @"车身外观", @"车身内饰", @"发动机", @"同价格车型推荐", @"同品牌车型推荐"];
    [self createTableView];
    
    [self getCardDetailInfo];
}

- (void)getCardDetailInfo
{
    [RequestManager getCarDetailWithCarId:self.CarID Succeed:^(NSData *data) {
        NSDictionary *result_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *data_dic = VALUEFORKEY(result_dic, @"Data");
        
        [self setUpTableHeaderViewWithDic:data_dic];
        [self setupTableHeaderViewWithFocusNews:VALUEFORKEY(data_dic, @"FirstImage")];
        
        self.summary = FORMATSTRING(VALUEFORKEY(data_dic, @"Summary"));
        
        _bodyFirstImageArr = VALUEFORKEY(data_dic, @"BodyFirst");
        _bodyImagesArr = VALUEFORKEY(data_dic, @"Body");
        
        _interiorFirstArr = VALUEFORKEY(data_dic, @"InteriorFirst");
        _interiorArr = VALUEFORKEY(data_dic, @"Interior");
        
        _engineFirstArr = VALUEFORKEY(data_dic, @"EngineFirst");
        _engineArr = VALUEFORKEY(data_dic, @"Engine");
        
        _samePriceCarsArr = VALUEFORKEY(data_dic, @"SamePriceCars");
        
        _sameBrandCarsArr = VALUEFORKEY(data_dic, @"SameBrandCars");
        
        _isShowConfig = [FORMATSTRING(VALUEFORKEY(data_dic, @"IsShowConfig")) boolValue];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - create tableView
- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATIONBARHEIGHT)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

#pragma mark -设置TableHeaderView
-(void)setUpTableHeaderViewWithDic:(NSDictionary *)dic
{
    UIView *tableHeaderView = [[UIView alloc] init];
    
    UIImageView *carBrand_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20*PSDSCALE_X, 28*PSDSCALE_Y, 86*PSDSCALE_X, 86*PSDSCALE_X)];
    [carBrand_imageView sd_setImageWithURL:[NSURL URLWithString:FORMATSTRING(VALUEFORKEY(dic, @"CarBrandLogo"))]];
    [tableHeaderView addSubview:carBrand_imageView];
    
    UILabel *carName_label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_W_X(carBrand_imageView) + 20*PSDSCALE_X, VIEW_Y(carBrand_imageView), SCREEN_WIDTH-(VIEW_W_X(carBrand_imageView) + 20*PSDSCALE_X), 48*PSDSCALE_Y)];
    carName_label.text = FORMATSTRING(VALUEFORKEY(dic, @"CarName"));
    carName_label.font = [UIFont systemFontOfSize:48*PSDSCALE_Y];
    carName_label.textColor = RGBACOLOR(50, 56, 68, 1);
    [tableHeaderView addSubview:carName_label];
    
    UILabel *carSubtitle_label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_X(carName_label), VIEW_H_Y(carName_label), VIEW_W(carName_label), VIEW_H(carName_label))];
    carSubtitle_label.textColor = [UIColor lightGrayColor];
    carSubtitle_label.text = [NSString stringWithFormat:@"%@上牌， %@", VALUEFORKEY(dic, @"EnterDate"), VALUEFORKEY(dic, @"KMNum")];
    carSubtitle_label.font = [UIFont systemFontOfSize:38*PSDSCALE_Y];
    [tableHeaderView addSubview:carSubtitle_label];
    
    TSEXCARLoopView *alLoop_view = [[TSEXCARLoopView alloc] initWithFrame:CGRectMake(0, VIEW_H_Y(carBrand_imageView)+22*PSDSCALE_Y, SCREEN_WIDTH, 400*PSDSCALE_Y)];
    alLoop_view.backgroundColor = [UIColor lightGrayColor];
    [tableHeaderView addSubview:alLoop_view];
    self.alLoop_view = alLoop_view;
    
    UILabel *price_label = [[UILabel alloc] initWithFrame:CGRectMake(20*PSDSCALE_X, VIEW_H_Y(alLoop_view)+25*PSDSCALE_Y, SCREEN_WIDTH-20*PSDSCALE_X, 38*PSDSCALE_Y)];
    price_label.font = [UIFont systemFontOfSize:38*PSDSCALE_Y];
    price_label.textColor = RGBACOLOR(63, 69, 79, 1);
    [tableHeaderView addSubview:price_label];
    
    BOOL IsWZBC = [VALUEFORKEY(dic, @"IsWZBC") boolValue];
    
    NSString *priceStr = @"";
    NSAttributedString *priceAttStr = nil;
    
    // 节省
    CGFloat saleCost = 0;
    if (IsWZBC) {
        priceStr = [NSString stringWithFormat:@"%@：￥%@万", FORMATSTRING(VALUEFORKEY(dic, @"SalePrice")), FORMATSTRING(VALUEFORKEY(dic, @"WZBCSpecialPrice"))];
        priceAttStr = [self attStringWithString:priceStr rangeOfString:[NSString stringWithFormat:@"%@万", FORMATSTRING(VALUEFORKEY(dic, @"WZBCSpecialPrice"))]];
        
        saleCost = ([FORMATSTRING(VALUEFORKEY(dic, @"ReferencePrice")) floatValue] - [FORMATSTRING(VALUEFORKEY(dic, @"WZBCSpecialPrice")) floatValue]);
        
    } else {
        priceStr = [NSString stringWithFormat:@"%@：￥%@万", FORMATSTRING(VALUEFORKEY(dic, @"SalePriceState")),  FORMATSTRING(VALUEFORKEY(dic, @"SalePrice"))];
        priceAttStr = [self attStringWithString:priceStr rangeOfString:[NSString stringWithFormat:@"%@万", FORMATSTRING(VALUEFORKEY(dic, @"SalePrice"))]];
        
        saleCost = ([FORMATSTRING(VALUEFORKEY(dic, @"ReferencePrice")) floatValue] - [FORMATSTRING(VALUEFORKEY(dic, @"SalePrice")) floatValue]);
    }
    price_label.attributedText = priceAttStr;
    
    
    
    
    UILabel *originalPrice_label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_X(price_label), VIEW_H_Y(price_label)+20*PSDSCALE_Y, VIEW_W(price_label), VIEW_H(price_label))];
    originalPrice_label.textColor = RGBACOLOR(63, 69, 79, 1);
    originalPrice_label.text = [NSString stringWithFormat:@"%@：￥%@万   为您节省了：￥%.2f万", FORMATSTRING(VALUEFORKEY(dic, @"ReferencePriceTitle")), FORMATSTRING(VALUEFORKEY(dic, @"ReferencePrice")), ([FORMATSTRING(VALUEFORKEY(dic, @"ReferencePrice")) floatValue] - [FORMATSTRING(VALUEFORKEY(dic, @"SalePrice")) floatValue])];
    originalPrice_label.font = [UIFont systemFontOfSize:38*PSDSCALE_Y];
    [tableHeaderView addSubview:originalPrice_label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 5*GETSCALE_Y+VIEW_H_Y(originalPrice_label), SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [tableHeaderView addSubview:line];
    
    
    UIButton *flower_button = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_X(originalPrice_label), VIEW_H_Y(line), 209*PSDSCALE_X, 83*PSDSCALE_Y)];
    [flower_button setTitle:@"关注" forState:UIControlStateNormal];
    [flower_button setTitle:@"取消关注" forState:UIControlStateSelected];
    flower_button.titleLabel.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
    [flower_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [flower_button setImage:[UIImage imageNamed:@"cancelCare.png"] forState:UIControlStateNormal];
    [flower_button setImage:[UIImage imageNamed:@"care.png"] forState:UIControlStateSelected];
    flower_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [flower_button addTarget:self action:@selector(flower_button_action:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:flower_button];
    
    UILabel *share_label = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_W_X(flower_button)+98*PSDSCALE_X, VIEW_Y(flower_button), 185*PSDSCALE_X, 83*PSDSCALE_Y)];
    share_label.text = @"分享至：";
    share_label.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
    share_label.textColor = [UIColor lightGrayColor];
    share_label.textAlignment = NSTextAlignmentRight;
    [tableHeaderView addSubview:share_label];
    
    NSArray *share_images = @[[UIImage imageNamed:@"shareWechat.png"], [UIImage imageNamed:@"shareFriends.png"]];
    for (NSInteger i = 0; i < share_images.count; i++) {
        UIButton *share_btn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_W_X(share_label) + i*(10+80*PSDSCALE_X), VIEW_Y(share_label), 80*PSDSCALE_X, VIEW_H(share_label))];
        [share_btn setImage:share_images[i] forState:UIControlStateNormal];
        [tableHeaderView addSubview:share_btn];
    }
    
    UIButton *compare_button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-259*PSDSCALE_X, VIEW_H_Y(line), 259*PSDSCALE_X, 83*PSDSCALE_Y)];
    [compare_button setTitle:@" 加入对比" forState:UIControlStateNormal];
    compare_button.titleLabel.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
    [compare_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [compare_button setImage:[UIImage imageNamed:@"addCompare.png"] forState:UIControlStateNormal];
    [compare_button addTarget:self action:@selector(compare_button_action:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:compare_button];
    
    NSArray *items = @[@"车辆参数", @"车辆照片", @"同价位推荐", @"同品牌推荐"];
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:items];
    segControl.frame = CGRectMake(0, VIEW_H_Y(flower_button), SCREEN_WIDTH, 84*PSDSCALE_Y);
    [segControl setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(228, 103, 19, 1)} forState:UIControlStateNormal];
    [segControl setTintColor:RGBACOLOR(228, 103, 19, 1)];
    [segControl addTarget:self action:@selector(segControl_valueChange:) forControlEvents:UIControlEventValueChanged];
    segControl.backgroundColor = [UIColor whiteColor];
    [tableHeaderView addSubview:segControl];
    
    segControl_frame = segControl.frame;
    
    self.segControl = segControl;
    
    tableHeaderView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_H_Y(segControl));
    self.tableView.tableHeaderView = tableHeaderView;
    
}

- (NSAttributedString *)attStringWithString:(NSString *)string rangeOfString:(NSString *)rangeString
{
    NSMutableAttributedString *sttrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [sttrStr setAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(228, 103, 19, 1), NSFontAttributeName:[UIFont systemFontOfSize:45*PSDSCALE_Y]} range:[string rangeOfString:rangeString]];
    
    return sttrStr;
}

- (void)setupTableHeaderViewWithFocusNews:(NSArray *)ADNews {
    
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.ADimagesArr = [NSMutableArray array];
        for (NSString *urlStr in ADNews) {
            
            NSURL *imageUrl = [NSURL URLWithString:urlStr];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            if (image) {
                [self.ADimagesArr addObject:image];
            }
            
        }
        
        // 当图片下载完成后，在主线程设置tableHeaderView的数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.alLoop_view setLoopViewImages:self.ADimagesArr autoPlay:YES delay:3.0];
        });
    });
}

#pragma mark -设置TableFooterView
-(void)setUpTableFooterView
{
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    } else if (section == 1 || section == 2 || section == 3) {
        return 1;
    } else if (section == 4) {
        return _samePriceCarsArr.count;
    } else if (section == 5) {
        return _sameBrandCarsArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *section_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 243*PSDSCALE_Y, SCREEN_WIDTH, 104*PSDSCALE_Y)];
        section_headerView.backgroundColor = RGBACOLOR(243, 244, 246, 1);
        [cell.contentView addSubview:section_headerView];
        
        UILabel *name_label = [[UILabel alloc] initWithFrame:CGRectMake(41*PSDSCALE_X, 0, SCREEN_WIDTH/2-41*PSDSCALE_X, VIEW_H(section_headerView))];
        name_label.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
        name_label.text = [section_name_array firstObject];
        [section_headerView addSubview:name_label];
        
        if (self.isShowConfig) {
            UIButton *showMoreConfig_btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-200*PSDSCALE_X, 0, 200*PSDSCALE_X, VIEW_H(section_headerView))];
            [showMoreConfig_btn setTitle:@"更多配置" forState:UIControlStateNormal];
            [showMoreConfig_btn setTitleColor:RGBACOLOR(233, 162, 127, 1) forState:UIControlStateNormal];
            showMoreConfig_btn.titleLabel.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
            [showMoreConfig_btn addTarget:self action:@selector(showMoreConfig_btn_action:) forControlEvents:UIControlEventTouchUpInside];
            [section_headerView addSubview:showMoreConfig_btn];
        }
        
        CGFloat summary_height = [self.summary heightWithSize:CGSizeMake(SCREEN_WIDTH - 100*PSDSCALE_X, 0) font:[UIFont systemFontOfSize:45*PSDSCALE_Y]];
        UILabel *summary_label = [[UILabel alloc] initWithFrame:CGRectMake(50*PSDSCALE_X, VIEW_H_Y(section_headerView)+50*PSDSCALE_Y, SCREEN_WIDTH - 100*PSDSCALE_X, summary_height)];
        summary_label.font = [UIFont systemFontOfSize:45*PSDSCALE_Y];
        summary_label.numberOfLines = 0;
        summary_label.textColor = [UIColor lightGrayColor];
        summary_label.text = self.summary;
        [cell.contentView addSubview:summary_label];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, VIEW_H_Y(summary_label)+25*PSDSCALE_Y, SCREEN_WIDTH, 304*PSDSCALE_Y)];
        scrollView.backgroundColor = RGBACOLOR(215, 216, 217, 1);
        
        UIImage *image = [UIImage imageNamed:@"carDescride.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40*PSDSCALE_X, 0, image.size.width, VIEW_H(scrollView))];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [scrollView addSubview:imageView];
        scrollView.contentSize = CGSizeMake(imageView.frame.size.width + 2*40*PSDSCALE_X, 0);
        [cell.contentView addSubview:scrollView];
        
        
        return cell;
    }  else if (indexPath.section == 1) {
        
        static NSString *identifier = @"CarImageCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self carImagesViewWithSuperView:cell.contentView firstImageArr:self.bodyFirstImageArr bodyImageArr:self.bodyImagesArr];
        
        return cell;
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self carImagesViewWithSuperView:cell.contentView firstImageArr:self.interiorFirstArr bodyImageArr:self.interiorArr];
        
        return cell;
    }  else if (indexPath.section == 3) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self carImagesViewWithSuperView:cell.contentView firstImageArr:self.engineFirstArr bodyImageArr:self.engineArr];
        
        return cell;
    } else if (indexPath.section == 4) {
        static NSString *identifier = @"samePriceCarCell";
        
        ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ConcernOnSoldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.carInfo = _samePriceCarsArr[indexPath.row];

        return cell;
    } else if (indexPath.section == 5) {
        static NSString *identifier = @"sameBrandCarCell";
        
        ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!cell) {
            cell = [[ConcernOnSoldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.carInfo = _sameBrandCarsArr[indexPath.row];
        
        return cell;

    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 680*PSDSCALE_Y + [self.summary heightWithSize:CGSizeMake(SCREEN_WIDTH - 100*PSDSCALE_X, 0) font:[UIFont systemFontOfSize:45*PSDSCALE_Y]];
    } else if (indexPath.section == 1) {
        return 269*PSDSCALE_Y+[self getImageHeightWithImageArray:_bodyImagesArr];
    } else if (indexPath.section == 2) {
        return 269*PSDSCALE_Y+[self getImageHeightWithImageArray:_interiorArr];
    } else if (indexPath.section == 3) {
        return 269*PSDSCALE_Y+[self getImageHeightWithImageArray:_engineArr];
    }
    else {
        return ConcernTableViewHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *section_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104*PSDSCALE_Y)];
        section_headerView.backgroundColor = RGBACOLOR(243, 244, 246, 1);
        
        UILabel *name_label = [[UILabel alloc] initWithFrame:CGRectMake(41*PSDSCALE_X, 0, SCREEN_WIDTH/2-41*PSDSCALE_X, VIEW_H(section_headerView))];
        name_label.font = [UIFont systemFontOfSize:40*PSDSCALE_Y];
        name_label.text = section_name_array[section];
        [section_headerView addSubview:name_label];
        
        return section_headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 104*PSDSCALE_Y;
    }
    
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isClickSegControl) {
        isClickSegControl = NO;
        return;
    }
    
    if (scrollView.contentOffset.y > segControl_frame.origin.y) {
        
        if (self.segControl.superview != self.view) {
            self.segControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84*PSDSCALE_Y);
            [self.view addSubview:self.segControl];
        }
        
                CGFloat offset_y = scrollView.contentOffset.y + segControl_frame.size.height;
        
//                CGRect rect1 = [self.tableView rectForSection:0];
                CGRect rect2 = [self.tableView rectForSection:1];
//                CGRect rect3 = [self.tableView rectForSection:2];
//                CGRect rect4 = [self.tableView rectForSection:3];
                CGRect rect5 = [self.tableView rectForSection:4];
                CGRect rect6 = [self.tableView rectForSection:5];
        
        
                if (offset_y >= rect6.origin.y) {
                    [self.segControl setSelectedSegmentIndex:3];
                } else if (offset_y >= rect5.origin.y) {
                    [self.segControl setSelectedSegmentIndex:2];
                } else if (offset_y >= rect2.origin.y) {
                    [self.segControl setSelectedSegmentIndex:1];
                } else {
                    [self.segControl setSelectedSegmentIndex:0];
                }
        
    } else {
        if (self.segControl.superview != self.tableView.tableHeaderView) {
            self.segControl.frame = segControl_frame;
            [self.tableView.tableHeaderView addSubview:self.segControl];
        }
        
                CGFloat offset_y = scrollView.contentOffset.y;
        
                CGRect rect1 = [self.tableView rectForSection:0];
                CGRect rect2 = [self.tableView rectForSection:1];
//                CGRect rect3 = [self.tableView rectForSection:2];
//                CGRect rect4 = [self.tableView rectForSection:3];
                CGRect rect5 = [self.tableView rectForSection:4];
//                CGRect rect6 = [self.tableView rectForSection:5];
        
        
                if (offset_y <= rect1.origin.y) {
                    [self.segControl setSelectedSegmentIndex:0];
                } else if (offset_y <= rect2.origin.y) {
                    [self.segControl setSelectedSegmentIndex:1];
                } else if (offset_y <= rect5.origin.y) {
                    [self.segControl setSelectedSegmentIndex:2];
                } else {
                    [self.segControl setSelectedSegmentIndex:3];
                }
        
    }
}

- (void)segControl_valueChange:(UISegmentedControl *)seg
{
    isClickSegControl = YES;
    if (self.segControl.superview != self.view) {
        self.segControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84*PSDSCALE_Y);
        [self.view addSubview:self.segControl];
    }
    
    CGRect rect1 = [self.tableView rectForSection:0];
    CGRect rect2 = [self.tableView rectForSection:1];
//    CGRect rect3 = [self.tableView rectForSection:2];
//    CGRect rect4 = [self.tableView rectForSection:3];
    CGRect rect5 = [self.tableView rectForSection:4];
    CGRect rect6 = [self.tableView rectForSection:5];
    
    if (seg.selectedSegmentIndex == 0) {
        
        self.tableView.contentOffset = CGPointMake(0, rect1.origin.y-segControl_frame.size.height);
        
//        [self.tableView scrollRectToVisible:[self.tableView rectForSection:0] animated:YES];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else if (seg.selectedSegmentIndex == 1) {
        self.tableView.contentOffset = CGPointMake(0, rect2.origin.y-segControl_frame.size.height);
    } else if (seg.selectedSegmentIndex == 2) {
        self.tableView.contentOffset = CGPointMake(0, rect5.origin.y-segControl_frame.size.height);
    } else {
        self.tableView.contentOffset = CGPointMake(0, rect6.origin.y-segControl_frame.size.height);
    }
}

- (void)carImagesViewWithSuperView:(UIView *)superView firstImageArr:(NSArray *)firstImageArr bodyImageArr:(NSMutableArray *)bodyImageArr
{
    for (UIView *subview in superView.subviews) {
        [subview removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < firstImageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if (i == 0) {
            imageView.frame = CGRectMake(17*PSDSCALE_X, 30*PSDSCALE_Y, SCREEN_WIDTH/2-17*PSDSCALE_X, 209*PSDSCALE_Y);
        } else if (i == 1) {
            imageView.frame = CGRectMake(SCREEN_WIDTH/2+34*PSDSCALE_X, 30*PSDSCALE_Y, SCREEN_WIDTH/2-3*17*PSDSCALE_X, 209*PSDSCALE_Y);
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:FORMATSTRING(firstImageArr[i])]];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [superView addSubview:imageView];
    }
    
    CGFloat bodyImageWidth = (SCREEN_WIDTH-4*17*PSDSCALE_X)/3;
    for (NSInteger i = 0; i < bodyImageArr.count; i++) {
        
        NSInteger mod = i%3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17*PSDSCALE_X*(mod+1) + bodyImageWidth*mod, 269*PSDSCALE_Y + (150*PSDSCALE_Y + 44*PSDSCALE_Y)*(i/3), bodyImageWidth, 170*PSDSCALE_Y)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:FORMATSTRING(bodyImageArr[i])]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [superView addSubview:imageView];
    }
}

- (CGFloat)getImageHeightWithImageArray:(NSArray *)imageArr
{
    NSInteger count = imageArr.count/3;
    
    if (imageArr.count%3 != 0) {
        count++;
    }
    
    return 170*PSDSCALE_Y*count+(count-1)*44*PSDSCALE_Y;
}

#pragma mark - button action
- (void)flower_button_action:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)compare_button_action:(UIButton *)sender
{
    
}

- (void)showMoreConfig_btn_action:(UIButton *)sender
{
    MoreConfigViewController *moreConfigVC = [[MoreConfigViewController alloc] init];
    
    moreConfigVC.CarID = self.CarID;
    [self.navigationController pushViewController:moreConfigVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
