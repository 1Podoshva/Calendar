//
//  TaskDateButton.h
//  Calendar
//
//  Created by Alexander on 17.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TaskButtonType_Day,
    TaskButtonType_Month,
    TaskButtonType_Year,
    TaskButtonType_FastDay
} TaskButtonType;

@interface TaskDateButton : UIButton
@property(nonatomic, strong) UIColor *selectColor;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, assign) BOOL select;
@property(nonatomic, assign) TaskButtonType type;

- (instancetype)initWithFrame:(CGRect)frame withType:(TaskButtonType)type withSelectColor:(UIColor *)color withTextColor:(UIColor *)textColor;

@end
