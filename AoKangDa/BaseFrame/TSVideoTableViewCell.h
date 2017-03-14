//
//  TSVideoTableViewCell.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCarTableViewCellFrame.h"
@interface TSVideoTableViewCell : UITableViewCell
@property (nonatomic,strong)TSCarTableViewCellFrame *CarTableViewCellFrame;
+ (instancetype)CarTableViewCellWithTableView:(UITableView *)tableView;
@end
