//
// CTPageViewModel.h
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTPage;
@interface CTPageViewModel : NSObject
@property (nonatomic, readonly) CTPage *page;
@property (nonatomic, readonly) NSURL  *imageURL;
+ (instancetype)viewModelWithModel:(CTPage*)page;
@end
