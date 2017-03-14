//
//  SelectLogoScrollView.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectLogoScrollViewDelegate <NSObject>

@optional
- (void)selectLogoScrollViewWith:(NSDictionary*)dictonary;

@end

@interface SelectLogoScrollView : UIView

@property (nonatomic,weak)id<SelectLogoScrollViewDelegate>delegate;
@property (nonatomic,strong) NSArray *dataArray;

@end
