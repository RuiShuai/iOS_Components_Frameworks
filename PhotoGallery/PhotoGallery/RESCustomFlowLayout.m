//
//  RESCustomFlowLayout.m
//  PhotoGallery
//
//  Created by taotao on 15/1/8.
//  Copyright (c) 2015年 RuiShuai Co., Ltd. All rights reserved.
//

#import "RESCustomFlowLayout.h"
#import "RESRowDecorationView.h"

#define kDecorationYAdjustment 13.0
#define kDecorationHeight  25.0

@interface RESCustomFlowLayout()
@property (nonatomic,strong) NSDictionary *rowDecorationRects;
@end

@implementation RESCustomFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.itemSize = CGSizeMake(60, 60);
        self.sectionInset = UIEdgeInsetsMake(10, 26, 10, 26);
        self.headerReferenceSize = CGSizeMake(300, 50);
        self.minimumLineSpacing = 20;
        self.minimumInteritemSpacing = 40;//临时
        
        [self registerClass:[RESRowDecorationView class] forDecorationViewOfKind:[RESRowDecorationView kind]];
    }
    return self;
}

-(void)prepareLayout
{

    [super prepareLayout];
    
    NSInteger sections = [self.collectionView numberOfSections];
    
    CGFloat availableWidth = self.collectionViewContentSize.width - (self.sectionInset.left + self.sectionInset.right);
    
    NSInteger cellsPerRow = floorf((availableWidth + self.minimumInteritemSpacing)/(self.itemSize.width + self.minimumInteritemSpacing));
    
    NSMutableDictionary *rowDecorationWork = [[NSMutableDictionary alloc]init];
    CGFloat yPosition = 0;
    
    for (NSInteger sectionIndex = 0; sectionIndex < sections; sectionIndex++)
    {
        yPosition += self.headerReferenceSize.height;
        yPosition += self.sectionInset.top;
        
        NSInteger cellCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        NSInteger rows = ceilf(cellCount/(CGFloat)cellsPerRow);
        
        for (int row=0; row < rows; row++) {
            yPosition += self.itemSize.height;
            CGRect decorationFrame = CGRectMake(0, yPosition-kDecorationYAdjustment, self.collectionViewContentSize.width, kDecorationHeight);
            
            NSIndexPath *decIndexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
            
            rowDecorationWork[decIndexPath] = [NSValue valueWithCGRect:decorationFrame];
            
            if (row < rows - 1) {
                yPosition += self.minimumLineSpacing;
            }
            
        }
        
        yPosition += self.sectionInset.bottom;
        yPosition += self.footerReferenceSize.height;
    }
    
    self.rowDecorationRects = [NSDictionary dictionaryWithDictionary:rowDecorationWork];
    
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
        attributes.zIndex = 1;
    }
    
    NSMutableArray *newLayoutAttributes = [layoutAttributes mutableCopy];
    
    [self.rowDecorationRects enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, NSValue *rowRectValue, BOOL *stop) {
        
        if (CGRectIntersectsRect([rowRectValue CGRectValue], rect)) {
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:[RESRowDecorationView kind] withIndexPath:indexPath];
            attributes.frame = [rowRectValue CGRectValue];
            attributes.zIndex = 0;
            [newLayoutAttributes addObject:attributes];
        }
    }];
    
    layoutAttributes = [NSArray arrayWithArray:newLayoutAttributes];
    
    return layoutAttributes;
}


@end
