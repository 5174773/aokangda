//
//  ConcernSelectView.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/9.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ConcernSelectView;

@protocol ConcernSelectViewDelegate <NSObject>

- (void)ConcernSelectViewtapAction:(ConcernSelectView*)concernSelectView;

@end


@interface ConcernSelectView : UIView

@property (nonatomic,weak) id<ConcernSelectViewDelegate>delegate;

@property (nonatomic,copy) NSString *name;

@end
