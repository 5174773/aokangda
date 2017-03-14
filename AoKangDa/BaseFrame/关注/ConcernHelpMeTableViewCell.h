//
//  ConcernHelpMeTableViewCell.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConcernHelpMeTableViewCellDelegate <NSObject>

- (void)concernHelpMeTableViewCellDidselect:(NSIndexPath*)indexPath;

@end

@interface ConcernHelpMeTableViewCell : UITableViewCell


@property (nonatomic,weak) id<ConcernHelpMeTableViewCellDelegate>delegate;
@property (nonatomic,strong) NSDictionary *infoDict;

@property (nonatomic,strong) NSArray *dataArray;


@end
