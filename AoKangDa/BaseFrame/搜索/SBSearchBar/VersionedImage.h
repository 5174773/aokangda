//
//  VersionedImage.h
//  myself - tabbar
//
//  Created by xshhanjuan on 15/10/14.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionedImage : UIImage
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name;

@end
