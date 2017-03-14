//
//  TSLatestNews.h
//  AoKangDa
//
//  Created by showsoft on 15/12/8.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSLatestNews : NSObject

/**ID*/
@property (nonatomic,strong) NSString *ID;

/**图片 */
@property (nonatomic,strong) NSURL *Image;

/**汽车款式 */
@property (nonatomic,strong) NSString *CarName;

/**里程 */
@property (nonatomic,strong) NSString *Remark;

/**是否特价 */
@property (nonatomic,assign ) BOOL IsTejia;

/**特价价格 */
@property (nonatomic,strong) NSString *TejiaPrice;

/**一口价 */
@property (nonatomic,strong) NSString *SalePriceState;

/**一口价价格 */
@property (nonatomic,strong) NSString *SalePrice;
/**分享链接 */
@property (nonatomic,strong) NSArray *Share;


@end
