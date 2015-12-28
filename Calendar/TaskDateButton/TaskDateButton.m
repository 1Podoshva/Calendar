//
//  TaskDateButton.m
//  Calendar
//
//  Created by Alexander on 17.12.15.
//  Copyright © 2015 Alexander. All rights reserved.
//

#import "TaskDateButton.h"

@implementation TaskDateButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withType:(TaskButtonType)type withSelectColor:(UIColor *)color withTextColor:(UIColor *)textColor {
    if (self = [super initWithFrame:frame]) {
        _type = type;
        self.textColor = textColor;
        self.selectColor = color;
        [self setTitleColor:textColor forState:UIControlStateNormal];
        [self addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)selectButton:(TaskDateButton *)sender {
    if (self.select) {
        _select = NO;
        [self setDeselectButton];

    } else {
        _select = YES;
        [self setSelectButton];
    }
}

- (void)setSelectButton {
    if (_type == TaskButtonType_Day) {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.backgroundColor = self.selectColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (_type == TaskButtonType_Month) {
        [self setTitleColor:self.selectColor forState:UIControlStateNormal];
    }
    if (_type == TaskButtonType_Year) {
        [self setTitleColor:self.selectColor forState:UIControlStateNormal];
    }
    if (_type == TaskButtonType_FastDay) {
        [self setTitleColor:self.selectColor forState:UIControlStateNormal];
    }
}

- (void)setSelect:(BOOL)select {
    _select = select;
    if (select) {
        [self setSelectButton];
    } else {
        [self setDeselectButton];
    }

}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    if (self.select) {
        [self setSelectButton];
    }
}

- (void)setDeselectButton {
    if (_type == TaskButtonType_Day) {
        self.layer.cornerRadius = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:self.textColor forState:UIControlStateNormal];
    } else {
        [self setTitleColor:self.textColor forState:UIControlStateNormal];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    if (self.select) {
        [self setSelectButton];
    } else {
        [self setTitleColor:self.textColor forState:UIControlStateNormal];
    }

}


@end
