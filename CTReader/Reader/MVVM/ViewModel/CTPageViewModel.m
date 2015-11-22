//
// CTPageViewModel.m
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import "CTPageViewModel.h"
#import "CTPage.h"

@interface CTPageViewModel ()
@property (nonatomic, strong) CTPage *page;
@property (nonatomic, strong) NSURL  *imageURL;

@end

@implementation CTPageViewModel
+ (instancetype)viewModelWithModel:(CTPage*)page
{
    CTPageViewModel *viewModel = [CTPageViewModel new];

    viewModel.page     = page;
    viewModel.imageURL = [NSURL URLWithString:page.url];
    return viewModel;
}

@end
