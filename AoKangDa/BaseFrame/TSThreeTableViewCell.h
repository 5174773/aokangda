//
//  TSThreeTableViewCell.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSEHomeViewNews;
@interface TSThreeTableViewCell : UITableViewCell
@property (nonatomic,strong) TSEHomeViewNews *ThreeImageViewNews;
+ (instancetype)ThreeTableViewCellWithTableView:(UITableView *)tableView;

@end
