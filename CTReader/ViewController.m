//
// ViewController.m
// CTReader
//
// Created by wangchaojs02 on 15/11/22.
// Copyright © 2015年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "ZMACollectionViewLayout.h"
#import "CTPage.h"
#import "CTCollectionViewCell.h"
#import "CTPageViewModel.h"

@interface ViewController ()<UICollectionViewDataSource
                             , ZMACollectionViewLayoutDelegate
                             , UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView  *collectionView;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchRecogniser;
@property (nonatomic, assign) CGFloat                   pinchStartVerticalPeriod;
@property (nonatomic, assign) CGFloat                   pinchNormalisedVerticalPosition;
@property (nonatomic, assign) NSInteger                 pinchTouchCount;

@property (nonatomic, strong) NSArray<CTPageViewModel*> *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _pinchRecogniser          = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    _pinchRecogniser.scale    = 1;
    _pinchRecogniser.delegate = self;

    [_pinchRecogniser setCancelsTouchesInView:YES];
    [self.collectionView addGestureRecognizer:_pinchRecogniser];

    UICollectionView*const collectionView = [self collectionView];
    collectionView.delegate   = self;
    collectionView.dataSource = self;

    [collectionView setAllowsSelection:NO];
    [collectionView setAlwaysBounceVertical:YES];
    [collectionView setMinimumZoomScale:1];
    [collectionView setMaximumZoomScale:2];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"json"];
    NSData   *data = [NSData dataWithContentsOfFile:path];

    NSError      *error             = nil;
    NSDictionary *dictionary        = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray      *imageDictionaries = dictionary[@"images"];

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageDictionaries.count];

    for (NSDictionary *dictionary in imageDictionaries)
    {
        CTPage *page = [CTPage infoWithDictionary:dictionary];
        [images addObject:[CTPageViewModel viewModelWithModel:page]];
    }


    self.images = [images subarrayWithRange:NSMakeRange(0, 10)];
} /* viewDidLoad */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    static NSArray        *colors = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        colors = @[[UIColor redColor]
                   , [UIColor greenColor]
                   , [UIColor blueColor]
                   , [UIColor cyanColor]];
    });

    CTCollectionViewCell*const cell = (CTCollectionViewCell*) [[self collectionView] dequeueReusableCellWithReuseIdentifier:@"CTCollectionViewCell" forIndexPath:indexPath];

    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [colors[indexPath.row % 4] CGColor];

    CTPageViewModel *viewModel = [self.images objectAtIndex:indexPath.row];
    [cell bindViewModel:viewModel];
    return cell;
} /* collectionView */

- (CGSize)  collectionView:(UICollectionView*)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CTPage *pageInfo = [[self.images objectAtIndex:indexPath.row] page];

    CGFloat containerWidth = collectionView.bounds.size.width;
    CGFloat width          = pageInfo.width;
    CGFloat height         = pageInfo.height;

    return CGSizeMake(containerWidth, containerWidth / width * height );
}

#pragma mark -

- (BOOL)                             gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return YES;
}

#pragma mark -

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    UICollectionView*const        collectionView = [self collectionView];
    ZMACollectionViewLayout*const layout         = (ZMACollectionViewLayout*) [self.collectionView collectionViewLayout];

    if( ([recognizer state] == UIGestureRecognizerStateBegan)
        || ([recognizer numberOfTouches] != _pinchTouchCount) )
    {
        const CGFloat normalisedY = [recognizer locationInView:collectionView].y / [layout collectionViewContentSize].height;
        _pinchNormalisedVerticalPosition = normalisedY;
        _pinchTouchCount                 = [recognizer numberOfTouches];
    }

    switch ([recognizer state])
    {
        case UIGestureRecognizerStateBegan:
        {
            _pinchStartVerticalPeriod = [layout scale];
            break;
        }

        case UIGestureRecognizerStateChanged:
        {
            ZMACollectionViewLayout*const layout            = (ZMACollectionViewLayout*) [self.collectionView collectionViewLayout];
            const CGFloat                 newVerticalPeriod = _pinchStartVerticalPeriod* [recognizer scale];
            [layout setScale:newVerticalPeriod];
            [layout invalidateLayout];

            const CGPoint dragCenter = [recognizer locationInView:[collectionView superview]];
            const CGFloat currentY   = _pinchNormalisedVerticalPosition* [layout collectionViewContentSize].height;
            [collectionView setContentOffset:CGPointMake(0, currentY - dragCenter.y)
                                    animated:NO];
            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            for(UIView*const view in [collectionView subviews])
            {
                [view setNeedsDisplay];
            }
        }

        default:
        {
        }
        break;
    } /* switch */
}     /* handlePinch */

@end
