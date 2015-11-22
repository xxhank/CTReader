//
// STDataColumnsCollectionViewLayout.m
// SpikeCollectionView
//
// Created by Benjohn Barnes on 31/12/2013.
// Copyright (c) 2013 splendid-things. All rights reserved.
//

#import "ZMACollectionViewLayout.h"

const CGFloat verticalSize = 20;

@interface ZMACollectionViewLayout ()
@property (nonatomic, assign) CGSize        contentSize;
@property (nonatomic, strong) NSDictionary *cellInformation;///< CGRect
@end

@implementation ZMACollectionViewLayout

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super init])
    {
        _scale = 1;
    }
    return self;
}

- (void)prepareLayout
{
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];


    UICollectionView *collectionView = self.collectionView;
    id                layoutDelegate = nil;//

    if ([collectionView.delegate conformsToProtocol:@protocol(ZMACollectionViewLayoutDelegate)])
    {
        layoutDelegate = collectionView.delegate;
    }

    NSInteger    numSections = [collectionView numberOfSections];
    NSIndexPath *indexPath   = nil;

    CGRect  frame         = collectionView.bounds;
    CGFloat contentHeight = 0;
    CGFloat contentWidth  = frame.size.width;
    CGFloat top           = 0;
    CGFloat left          = 0;

    for(NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [collectionView numberOfItemsInSection:section];

        for(NSInteger item = 0; item < numItems; item++)
        {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            CGSize size = [layoutDelegate collectionView:collectionView layout:self sizeForItemAtIndexPath:indexPath];
            contentHeight    += size.height;
            frame.origin.x    = (contentWidth - size.width) / 2;
            frame.origin.y    = top;
            frame.size.height = size.height;


            NSValue *value = [NSValue valueWithCGRect:frame];
            [cellInformation setObject:value forKey:indexPath];

            top += size.height;
            left = 0;
        }
    }

    self.contentSize     = CGSizeMake(contentWidth, contentHeight);
    self.cellInformation = cellInformation;

    CGFloat scale   = self.scale;
    CGPoint offset  = self.collectionView.contentOffset;
    CGFloat offsetX = scale < 1 ? 0 : ( (scale - 1) * contentWidth / 2 );
    self.collectionView.contentOffset = CGPointMake(offsetX, offset.y);
    // end of first section
} /* prepareLayout */

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray*const elements = [NSMutableArray array];

    CGFloat scale  = self.scale;
    CGFloat top    = CGRectGetMinY(rect);
    CGFloat bottom = CGRectGetMaxY(rect);

    // CGPoint topCenter                = CGPointMake(self.contentSize.width / 2, top);
    // CGPoint bottomCenter             = CGPointMake(self.contentSize.width / 2, bottom);

    NSDictionary     *cellInfos      = self.cellInformation;
    UICollectionView *collectionView = self.collectionView;
    NSInteger         numSections    = [collectionView numberOfSections];
    BOOL              finished       = NO;

    for(NSInteger section = 0; section < numSections; section++)
    {
        NSInteger numItems = [collectionView numberOfItemsInSection:section];

        for(NSInteger item = 0; item < numItems; item++)
        {
            NSIndexPath  *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            NSValue*const info      = [cellInfos objectForKey:indexPath];
            CGRect        frame     = [info CGRectValue];

            frame.origin.y    *= scale;
            frame.origin.x     = scale > 1 ? 0 : frame.size.width * (1 - scale) / 2;
            frame.size.width  *= scale;
            frame.size.height *= scale;

            if ( (CGRectGetMaxY(frame) < top) )
            {
                continue;
            }
            else if (CGRectGetMinY(frame) > bottom)
            {
                finished = YES;
                break;
            }
            else
            {
                UICollectionViewLayoutAttributes*const attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = frame;
                [elements addObject:attributes];
            }
        }

        if (finished)
        {
            break;
        }
    }
    return [elements copy];
} /* layoutAttributesForElementsInRect */

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSValue *cellAttributes = [self.cellInformation objectForKey:indexPath];
    CGRect   frame          = [cellAttributes CGRectValue];
    CGFloat  scale          = self.scale;

    frame.origin.y    *= scale;
    frame.origin.x     = scale > 1 ? 0 : frame.size.width * (1 - scale) / 2;
    frame.size.width  *= scale;
    frame.size.height *= scale;

    UICollectionViewLayoutAttributes*const attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
} /* layoutAttributesForItemAtIndexPath */

- (CGSize)collectionViewContentSize
{
    CGSize  contentSize = self.contentSize;
    CGFloat scale       = self.scale;

    contentSize.width  *= scale;
    contentSize.height *= scale;

    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (CGFloat)scale
{
    if (_scale > 2)
    {
        return 2;
    }

    if (_scale < .5)
    {
        return 0.5;
    }

    return _scale;
} /* scale */

@end
