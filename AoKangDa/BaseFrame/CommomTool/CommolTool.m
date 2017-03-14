//
//  CommolTool.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/15.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CommolTool.h"

@implementation CommolTool


+ (NSArray*)getMainChannelS
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mainChannel" ofType:@"plist"];
    
    NSArray *getArray = [NSArray arrayWithContentsOfFile:path];
    
    return getArray;
}

@end
