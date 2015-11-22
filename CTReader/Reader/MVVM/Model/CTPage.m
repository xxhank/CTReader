//
// CTPage.m
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import "CTPage.h"

@implementation CTPage
+ ( instancetype )infoWithDictionary:(NSDictionary*)dictionary
{
    CTPage *info = [CTPage new];

    info.path   = dictionary[@"name"];
    info.width  = [dictionary[@"width"] floatValue];
    info.height = [dictionary[@"height"] floatValue];
    info.url    = dictionary[@"url"];
    return info;
}

@end
