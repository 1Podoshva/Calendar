//
//  TaskCalendarCollectionView.m
//  Calendar
//
//  Created by Alexander on 18.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "TaskCalendarCollectionView.h"
#import "TaskCollectionViewCell.h"
#import "TaskCollectionViewLayout.h"

@implementation TaskCalendarCollectionView {
    TaskCollectionViewLayout *collectionViewLayout;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {


    }
    return self;
}

@end
