//
//  SBShowTableView.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBShowTableView;

@protocol SBShowTableViewDelegate <NSObject>

@optional
- (void)SBShowTableViewSelect:(SBShowTableView*)sbShowTableView :(NSDictionary*)dictionary;
- (void)SBShowTableViewSelectString:(SBShowTableView*)sbShowTableView :(NSString*)string;

@end


@interface SBShowTableView : UIButton

@property (nonatomic,assign) NSInteger flag;    // 3：搜索

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,weak)id<SBShowTableViewDelegate>delegate;


-(instancetype)initwithStartFrame:(CGRect)frame;
- (void)show;


@end
