//
//  TSCarTableViewCell.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSEHomeViewNews;
@interface TSCarsTableViewCell : UITableViewCell
@property (nonatomic,strong)TSEHomeViewNews *CarsViewNews ;
+(instancetype)CarsTableViewCellWithTableView:(UITableView *)tableView;
@end
