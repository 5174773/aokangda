//
//  BrandSelectViewController.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BrandSelectViewControllerDelegate <NSObject>

- (void)BrandSelectViewSelect:(NSDictionary*)dictionary;

@end


@interface BrandSelectViewController : BaseViewController

@property (nonatomic,weak) id<BrandSelectViewControllerDelegate>delegate;

@end
