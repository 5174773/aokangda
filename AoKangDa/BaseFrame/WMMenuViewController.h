//
//  WMMenuViewController.h
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WMMenuViewControllerDelegate <NSObject>
@optional
- (void)didSelectItem:(NSString *)title Tag:(NSInteger)tag;

@end

@interface WMMenuViewController : BaseViewController
@property (weak, nonatomic) id<WMMenuViewControllerDelegate> delegate;

@end
