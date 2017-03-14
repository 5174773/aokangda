//
//  SBPickerView.m
//  MyTool
//
//  Created by xshhanjuan on 15/11/20.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import "SBPickerView.h"

#define AnimateTime 0.25f
#define ScreenBounds [UIScreen mainScreen].bounds


@interface SBPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>



@end



@implementation SBPickerView
{
    UIView *_pickBackgroundView;
    UITapGestureRecognizer *_tapG;
    UIDatePicker *_datePicker;
    UIPickerView *_pickerView;
    BOOL _isDayPicker;
}




-(instancetype)initWIthIsDayPicker:(BOOL)isDayPicker
{
    if (self = [super init]) {
        
        
        _isDayPicker = isDayPicker;
        [self initPickView];
    }
    return self;
}


- (void)initPickView
{
    //
    [self setFrame:SCREEN_BOUNDS];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.userInteractionEnabled = YES;
    
    
    CGFloat StartY = SCREEN_BOUNDS.size.height - 216 - 50 *GETSCALE_Y;
    
    
    //
    UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, StartY)];
    [self addSubview:tapView];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tapG.enabled = NO;
    _tapG = tapG;
    [tapView addGestureRecognizer:tapG];
    
    
    //
    UIView *pickBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_BOUNDS.size.height, SCREEN_BOUNDS.size.width, 216 + 40 * GETSCALE_Y)];
    pickBackgroundView.backgroundColor = [UIColor whiteColor];
    _pickBackgroundView = pickBackgroundView;
    
    [self addSubview:pickBackgroundView];
    
    
    CGFloat buttonWidth = 50 * GETSCALE_X;
    CGFloat buttonHeight = 40 * GETSCALE_Y;
    //
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:RGBACOLOR(50, 130, 233, 1) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [pickBackgroundView addSubview:cancelButton];
    
    
    //
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width - buttonWidth, 0, buttonWidth, buttonHeight)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:RGBACOLOR(50, 130, 233, 1) forState:UIControlStateNormal];
    [pickBackgroundView addSubview:sureButton];
    
  
    //
    [self createPickerViewWith:pickBackgroundView startY:40 * GETSCALE_Y];
}


- (void)createPickerViewWith:(UIView *)parentView startY:(CGFloat)startY
{
    
    if (_isDayPicker) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, startY, SCREEN_BOUNDS.size.width, 216)];
        _datePicker = datePicker;
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        [parentView addSubview:datePicker];
        
    }else{
        
        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, startY, SCREEN_BOUNDS.size.width, 216)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        _pickerView = pickerView;
        [parentView addSubview:pickerView];
    }
    
    
}


- (void)sureAction
{

    NSString *resultStr = nil;
    
    if (_datePicker) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
        resultStr = [dateFormatter stringFromDate:_datePicker.date];
    }
    else{
        NSInteger row = [_pickerView selectedRowInComponent:0];
        resultStr = _dataArray[row];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectSureAciton:)]) {
        [_delegate selectSureAciton:resultStr];
    }
    
    [self tapAction];
}


- (void)tapAction
{
    
    _tapG.enabled = NO;
    
    [UIView animateWithDuration:AnimateTime animations:^{
        CGRect frame = _pickBackgroundView.frame;
        frame.origin.y = SCREEN_BOUNDS.size.height;
        [_pickBackgroundView setFrame:frame];
    
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


- (void)showPickerView
{
    
    _tapG.enabled = YES;

    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        CGRect frame = _pickBackgroundView.frame;
        frame.origin.y = SCREEN_BOUNDS.size.height - frame.size.height;
        [_pickBackgroundView setFrame:frame];
        
    } completion:^(BOOL finished) {

    }];
    
}


#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
    return _dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dict = _dataArray[row];
    
    return VALUEFORKEY(dict, @"Name");
}

@end
