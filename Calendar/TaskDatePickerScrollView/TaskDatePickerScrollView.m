//
//  TaskDatePickerScrollView.m
//  Calendar
//
//  Created by Alexander on 29.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "TaskDatePickerScrollView.h"

@implementation TaskDatePickerScrollView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.spacing = 0;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)addSubview:(UIView *)view {
    UIView *lastView = [self.subviews lastObject];
    if (lastView) {
        view.center = CGPointMake(lastView.center.x + view.frame.size.width + self.spacing, self.frame.size.height / 2);
    } else {
        view.center = CGPointMake(view.frame.size.width / 2 + self.spacing / 2, self.frame.size.height / 2);
    }
    CGFloat contentSizeWidth = self.contentSize.width;
    self.contentSize = CGSizeMake(contentSizeWidth + view.frame.size.width + self.spacing, self.contentSize.height);
    [super addSubview:view];
}


- (void)willRemoveSubview:(UIView *)subview {
    [super willRemoveSubview:subview];
    CGFloat contentSizeWidth = self.contentSize.width;
    self.contentSize = CGSizeMake(contentSizeWidth - subview.frame.size.width - self.spacing, self.contentSize.height);
}


@end
