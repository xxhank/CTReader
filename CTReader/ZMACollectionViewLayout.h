//
// STDataColumnsCollectionViewLayout.h
// SpikeCollectionView
//
// Created by Benjohn Barnes on 31/12/2013.
// Copyright (c) 2013 splendid-things. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMACollectionViewLayoutDelegate <UICollectionViewDelegate>
- (CGSize)  collectionView:(UICollectionView*)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath*)indexPath;
@end

@interface ZMACollectionViewLayout : UICollectionViewLayout
@property (nonatomic, assign) CGFloat scale;
@end
