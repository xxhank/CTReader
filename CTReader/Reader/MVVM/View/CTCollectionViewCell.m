//
// CTCollectionViewCell.m
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import "CTCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CTPageViewModel.h"

@implementation CTCollectionViewCell

- (void)bindViewModel:(CTPageViewModel*)viewModel
{
    [self.imageView sd_setImageWithURL:viewModel.imageURL];
}

@end
