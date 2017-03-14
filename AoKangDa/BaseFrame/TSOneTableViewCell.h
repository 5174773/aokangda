//
//  TSoneTableViewCell.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSOneTableViewCell,TSEHomeViewNews;
@protocol TSOneTableViewCellDelegate <NSObject>

-(void)CollectBtnclick:(UIButton*)sender;
@end
@interface TSOneTableViewCell : UITableViewCell
@property (nonatomic,strong) TSEHomeViewNews *OneImageViewNews ;

@property (retain,nonatomic) id <TSOneTableViewCellDelegate> delegate;
+ (instancetype)OneTableViewCellWithTableView:(UITableView *)tableView;
@end
