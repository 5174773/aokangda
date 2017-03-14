//
//  SBPickerView.h
//  MyTool
//
//  Created by xshhanjuan on 15/11/20.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBPickerViewDelegate <NSObject>

- (void)selectSureAciton:(NSString *)result;


@end


@interface SBPickerView : UIView

@property (nonatomic,weak) id<SBPickerViewDelegate>delegate;

@property (nonatomic,strong)NSArray *dataArray;

-(instancetype)initWIthIsDayPicker:(BOOL)isDayPicker;
- (void)showPickerView;

@end
