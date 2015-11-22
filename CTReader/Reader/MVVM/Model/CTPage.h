//
// CTPage.h
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

@import UIKit;

@interface CTPage : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, assign) CGFloat   width;

+ ( instancetype )infoWithDictionary:(NSDictionary*)dictionary;

@end
