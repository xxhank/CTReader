//
// CTCollectionViewCell.h
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTPageViewModel;
@interface CTCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
- (void)bindViewModel:(id)viewModel;
@end
