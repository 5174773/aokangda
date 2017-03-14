//
//  NSString+AutoHeight.m
//  FreeCash
//
//  Created by 深圳市 秀软科技有限公司 on 15/10/26.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "NSString+AutoHeight.h"

@implementation NSString (AutoHeight)

- (CGFloat)heightWithSize:(CGSize)size font:(UIFont *)font
{
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}
@end
