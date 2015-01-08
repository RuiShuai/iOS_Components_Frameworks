//
//  RESCustomLayout.m
//  PhotoGallery
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomLayout.h"

#define kCellSize     50.0 //assumes square cell
#define kHorizontalInset    10.0 // on the left and right
#define kPi 3.141592653
#define kVerticalSpace 10.0  // vertical space between cells
#define kSectionHeight 20.0
#define kCenterXPosition 160.0
#define kMaxAmplitude 125.0

@interface RESCustomLayout()
@property (nonatomic,strong) NSMutableDictionary *centerPointsForCells;
@property (nonatomic,strong) NSMutableArray *rectsForSectionHeaders;
@property (nonatomic,assign) CGSize contentSize;
@end

@implementation RESCustomLayout

-(id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(CGFloat)calculateSineXPositionForY:(CGFloat)yPosition
{
    CGFloat currentTime = (yPosition / self.collectionView.bounds.size.height);
    CGFloat sineCalc = kMaxAmplitude * sinf(2*kPi*currentTime);
    CGFloat adjustedXPosition = sineCalc + kCenterXPosition;
    return adjustedXPosition;
}

-(void)prepareLayout
{
    NSInteger numSections = [self.collectionView numberOfSections];
    
    CGFloat currentYPoistion = 0.0;
    self.centerPointsForCells = [[NSMutableDictionary alloc]init];
    self.rectsForSectionHeaders = [[NSMutableArray alloc]init];
    
    for (NSInteger sectionIndex = 0; sectionIndex < numSections; sectionIndex++) {
        CGRect rectForNextSection = CGRectMake(0, currentYPoistion, self.collectionView.bounds.size.width, kSectionHeight);
        self.rectsForSectionHeaders[sectionIndex] = [NSValue valueWithCGRect:rectForNextSection];
        currentYPoistion += kSectionHeight + kVerticalSpace + kCellSize/2;
        
        NSInteger numCellsForSection = [self.collectionView numberOfItemsInSection:sectionIndex];
        
        for (NSInteger cellIndex = 0; cellIndex < numCellsForSection; cellIndex++) {
            CGFloat xPosition = [self calculateSineXPositionForY:currentYPoistion];
            CGPoint cellCenterPoint = CGPointMake(xPosition, currentYPoistion);
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:cellIndex inSection:sectionIndex];
            self.centerPointsForCells[cellIndexPath] = [NSValue valueWithCGPoint:cellCenterPoint];
            currentYPoistion += kCellSize + kVerticalSpace;
        }
        
    }
    
    self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, currentYPoistion+kVerticalSpace);
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(kCellSize, kCellSize);
    NSValue *centerPointValue = self.centerPointsForCells[indexPath];
    attributes.center = [centerPointValue CGPointValue];
    return attributes;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    CGRect sectionRect = [self.rectsForSectionHeaders[indexPath.section] CGRectValue];
    attributes.size = CGSizeMake(sectionRect.size.width, sectionRect.size.height);
    attributes.center = CGPointMake(CGRectGetMidX(sectionRect), CGRectGetMidY(sectionRect));
    return attributes;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSValue *sectionRect in self.rectsForSectionHeaders) {
        if (CGRectIntersectsRect(rect, sectionRect.CGRectValue)) {
            NSInteger sectionIndex = [self.rectsForSectionHeaders indexOfObject:sectionRect];
            NSIndexPath *secIndexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:secIndexPath]];
        }
    }
    
    //
    [self.centerPointsForCells enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *centerPoint, BOOL *stop) {
        CGPoint center = [centerPoint CGPointValue];
        CGRect cellRect = CGRectMake(center.x-kCellSize/2, center.y-kCellSize/2, kCellSize, kCellSize);
        if (CGRectIntersectsRect(rect, cellRect)) {
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }];
    
    return [NSArray arrayWithArray:attributes];
}

-(CGSize)collectionViewContentSize
{
    return self.contentSize;
}

@end
