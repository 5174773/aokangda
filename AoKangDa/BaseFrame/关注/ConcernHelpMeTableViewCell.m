//
//  ConcernHelpMeTableViewCell.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "ConcernHelpMeTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "Public.h"
#import "ConcernOnSoldTableViewCell.h"

#define BothGap  10
#define CarImageViewRation   0.4

#define SBCellHeight   ConcernTableViewHeight



@interface ConcernHelpMeTableViewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UIImageView *lineImageView;
@property (nonatomic,strong)UILabel *carLabel;
@property (nonatomic,strong)UILabel *carDecrLabel;
@property (nonatomic,strong)UIButton *newsImageView;
@property (nonatomic,strong)  UIButton *actionButton;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) NSArray *tableArray;

@end

@implementation ConcernHelpMeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    ///
    UIImageView *logoImageView = [[UIImageView alloc]init];
    _logoImageView = logoImageView;
    [self addSubview:logoImageView];
    
    ///
    UIImageView *lineImageView = [[UIImageView alloc]init];
    lineImageView.image = [UIImage imageNamed:@"Concern_Line"];
    _lineImageView = lineImageView;
    [self addSubview:lineImageView];
    
    ///
    UILabel *carLabel = [[UILabel alloc]init];
    carLabel.textAlignment = NSTextAlignmentLeft;
    carLabel.font = [UIFont systemFontOfSize:15];
    _carLabel = carLabel;
    [self addSubview:carLabel];
    
    ///
    UILabel *carDecrLabel = [[UILabel alloc]init];
    carDecrLabel.textAlignment = NSTextAlignmentLeft;
    carDecrLabel.font = [UIFont systemFontOfSize:15];
    _carDecrLabel = carDecrLabel;
    [self addSubview:carDecrLabel];
    
    ///
    UIButton *newsImageView = [[UIButton alloc]init];
    [newsImageView setBackgroundImage:[UIImage imageNamed:@"Concern_Row"] forState:UIControlStateNormal];
    [newsImageView setTitle:@"NEW 5" forState:UIControlStateNormal];
    newsImageView.titleLabel.font = [UIFont systemFontOfSize:12];
    [newsImageView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newsImageView.userInteractionEnabled = NO;
    _newsImageView = newsImageView;
    [self addSubview:newsImageView];
    
    
    UIButton *actionButton = [[UIButton alloc]init];
    [actionButton addTarget:self action:@selector(updownAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionButton];
    _actionButton = actionButton;
    
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    _tableView = tableView;
    [self addSubview:tableView];
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    [_logoImageView sd_setImageWithURL:VALUEFORKEY(infoDict, @"Image") placeholderImage:[UIImage imageNamed:@"temp_logo"]];
    _carLabel.text = VALUEFORKEY(infoDict, @"Name");
    
    _carDecrLabel.text = [NSString stringWithFormat:@"%@系 %@",VALUEFORKEY(infoDict,@"Letter"),VALUEFORKEY(infoDict, @"SeriesName")];
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    _tableArray = _dataArray;
    
    [self setNeedsLayout];
    
    
    MMLog(@"111");
    
    [_tableView reloadData];
 
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    float lineBothGap = 8;
    float newsGap = 25;
    float newsWidth = 117 * 0.5;
    float newsHeight = 35 * 0.5;
    
    
    _logoImageView.frame = CGRectMake(BothGap, HelpMeTableViewTopHeight * 0.15,HelpMeTableViewTopHeight * 0.7,HelpMeTableViewTopHeight * 0.7);
    _newsImageView.frame = CGRectMake(VIEW_W(self) - newsGap - newsWidth, (HelpMeTableViewTopHeight - newsHeight) * 0.5, newsWidth, newsHeight);
    _lineImageView.frame = CGRectMake(VIEW_W_X(_logoImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.25, 1, HelpMeTableViewTopHeight * 0.5);
    _actionButton.frame = CGRectMake(0, 0, VIEW_W(self), HelpMeTableViewTopHeight);
    
    ///
    float carLabelWidth = VIEW_W(self) - VIEW_W_X(_lineImageView) - VIEW_W(_newsImageView) - newsGap - lineBothGap;
    _carLabel.frame = CGRectMake(VIEW_W_X(_lineImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.1, carLabelWidth, HelpMeTableViewTopHeight * 0.4);
    
    _carDecrLabel.frame = CGRectMake(VIEW_W_X(_lineImageView) + lineBothGap, HelpMeTableViewTopHeight * 0.5, carLabelWidth, HelpMeTableViewTopHeight * 0.4);

    if (_tableArray) {
        _tableView.frame = CGRectMake(0, HelpMeTableViewTopHeight, VIEW_W(self), _tableArray.count * SBCellHeight);
         MMLog(@"1$$  %@  %@  %@\n%@",_carLabel.text,NSStringFromCGRect(CGRectMake(0, HelpMeTableViewTopHeight, VIEW_W(self), _tableArray.count * SBCellHeight)),NSStringFromCGRect(_tableView.frame),_tableArray);
        
    }else
    {
        _tableView.frame = CGRectMake(0, HelpMeTableViewTopHeight, VIEW_W(self), 0);
         MMLog(@"2$$  %@  %@  %@\n%@",_carLabel.text,NSStringFromCGRect( CGRectMake(0, HelpMeTableViewTopHeight, VIEW_W(self), 0)),NSStringFromCGRect(_tableView.frame),_tableArray);
    }
}


- (void)updownAction
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(concernHelpMeTableViewCellDidselect:)]) {
       
        if ([self.superview.superview isKindOfClass:[UITableView class]]) {
            UITableView *helpmeTableview = (UITableView*)self.superview.superview;
            NSIndexPath *index = [helpmeTableview indexPathForCell:self];
            
            [_delegate concernHelpMeTableViewCellDidselect:index];
            

    
        }
    }
}

#pragma mark -- tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MMLog(@"22222 %d",_tableArray.count);
    return _tableArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MMLog(@"%@  %d",_carLabel.text,_tableArray[indexPath.row]);
    cell.carInfo = _tableArray[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SBCellHeight;
}



@end
