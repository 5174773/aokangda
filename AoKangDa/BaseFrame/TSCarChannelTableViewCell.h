//
//  TSCarChannelTableViewCell.h
//  AoKangDa
//
//  Created by showsoft on 15/12/15.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSCarsTableViewCellFrame;
@interface TSCarChannelTableViewCell : UITableViewCell
@property (nonatomic,strong)TSCarsTableViewCellFrame *CarsTableViewCellFrame;
+(instancetype)CarsTableViewCellWithTableView:(UITableView *)tableView;
@end
