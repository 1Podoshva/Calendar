//
//  TaskCollectionViewLayout.m
//  Calendar
//
//  Created by Alexander on 18.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "TaskCollectionViewLayout.h"
#import "TaskCollectionViewCell.h"

@implementation TaskCollectionViewLayout {
    CGSize currentContentSize;
    NSArray *layoutAttributes;
}

- (void)prepareLayout {
    [super prepareLayout];
    layoutAttributes = [self generateLayoutAttributes];
}


- (CGSize)collectionViewContentSize {
    return currentContentSize;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return layoutAttributes;
}


- (NSArray *)generateLayoutAttributes {
    NSInteger sectionCount = 1;
    if ([self.collectionView.delegate respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    CGSize cellSize = self.cellSize;
    float collectionHight = self.collectionView.bounds.size.height;
    float xOffset = 0;
    float yOffset = 0;
    for (NSInteger section = 0; section < sectionCount; ++section) {
        NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        for (int item = 0; item < itemsCount; ++item) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            TaskCollectionViewCell *cell = (UICollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
            //CGSize buttonSize = cell.quickDateButton.bounds.size;

            UICollectionViewLayoutAttributes *collectionViewLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            collectionViewLayoutAttributes.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height);
            yOffset += cellSize.height + 5;
            if (yOffset + cellSize.height > collectionHight) {
                yOffset = 0;
                xOffset += cellSize.width + 5;
            }
            [array addObject:collectionViewLayoutAttributes];
        }
    }

    currentContentSize = CGSizeMake(xOffset, yOffset);
    return array;
}

@end
