//
//  SearchHistoryTableViewCell.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchHistoryTableViewCellDelegate <NSObject>

- (void)SearchHistoryTableViewCellSelect:(NSString*)selectString;

@end

@interface SearchHistoryTableViewCell : UITableViewCell

@property (nonatomic,weak)id<SearchHistoryTableViewCellDelegate>delegate;
@property (nonatomic,copy) NSString *title;

@end
