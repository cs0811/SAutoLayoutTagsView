//
//  SAutoLayoutTagsView.m
//  Test
//
//  Created by du on 16/9/24.
//  Copyright © 2016年 dufei. All rights reserved.
//

#import "SAutoLayoutTagsView.h"

#define kScreenW        [UIScreen mainScreen].bounds.size.width
#define kTagBase        1024

@implementation SAutoLayoutTagsView
{
    NSArray * _dataArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _resetAllTagWhenSingleClick = YES;
    }
    return self;
}

- (void)showTagsWithDataArr:(NSArray *)arr onView:(UIView *)view {
    _dataArr = arr;
    [self sizeBtn:arr];
    [view addSubview:self];
}

- (void)sizeBtn:(NSArray *)arr{
    
    //    CGFloat width = 60.;
    CGFloat height = _height?:30.;
    CGFloat leftSpace = _leftSpace?:12;             // 左边距
    CGFloat rightSpace = _rightSpace?:12;           // 右边距
    CGFloat topSpace = _topSpace?:5;                // 上边距
    CGFloat bottomSpace = _bottomSpace?:5;          // 下边距
    CGFloat itemSpaceH = _itemSpaceH?:10;           // 水平间距
    CGFloat itemSpaceV = _itemSpaceV?:5;            // 竖直间距
    
    //    循环创建数组
    CGFloat validitySpace = kScreenW-leftSpace-rightSpace;      // 可用的宽度
    UIButton * lastBtn = nil;          // 上一个宽度
    BOOL shouldBreakLine = NO;          // 是否需要换行
    
    for (int i = 0; i < arr.count; i++) {
        UIButton * sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sizeBtn setBackgroundColor:[UIColor whiteColor]];
        sizeBtn.layer.borderWidth = 0.5;
        sizeBtn.layer.borderColor = [UIColor grayColor].CGColor;
        sizeBtn.layer.cornerRadius = 5;
        sizeBtn.layer.masksToBounds = YES;
        [sizeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        sizeBtn.tag = kTagBase+i;
        sizeBtn.selected = NO;
        
        for (NSString * value in self.tagsStartStatusArr) {
            if ([value isEqual:arr[i]]) {
                sizeBtn.selected = YES;
                sizeBtn.backgroundColor = kYellowColor;
            }
        }
        
        [sizeBtn setTitle:arr[i] forState:UIControlStateNormal];
        [self addSubview:sizeBtn];
        
        [sizeBtn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [arr[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.]} context:nil].size;
        size = CGSizeMake(size.width+20, size.height);
        CGRect frame = CGRectZero;
        
        if (!lastBtn) {
            // 第一行 第一个
            if (size.width >= kScreenW-leftSpace-rightSpace) {
                size.width = kScreenW-leftSpace-rightSpace;
                shouldBreakLine = YES;
            }
            shouldBreakLine = NO;
            frame = (CGRect){leftSpace, topSpace, size.width, height};
        }else {
            if (shouldBreakLine) {
                if (size.width >= (kScreenW-leftSpace-rightSpace) ) {
                    size.width = kScreenW-leftSpace-rightSpace;
                    shouldBreakLine = YES;
                }
                shouldBreakLine = NO;
                frame = (CGRect){leftSpace, CGRectGetMaxY(lastBtn.frame)+itemSpaceV, size.width, height};
            }else {
                if (size.width >= validitySpace) {
                    if (size.width >= (kScreenW-leftSpace-rightSpace) ) {
                        size.width = kScreenW-leftSpace-rightSpace;
                    }
                    shouldBreakLine = YES;
                    frame = (CGRect){leftSpace, CGRectGetMaxY(lastBtn.frame)+itemSpaceV, size.width, height};
                }else {
                    shouldBreakLine = NO;
                    frame = (CGRect){CGRectGetMaxX(lastBtn.frame)+itemSpaceH, CGRectGetMinY(lastBtn.frame), size.width, height};
                }
            }
        }
        
        validitySpace = validitySpace - size.width - itemSpaceH;
        if (validitySpace <= 0.) {
            validitySpace = kScreenW-leftSpace-rightSpace;
        }
        
        lastBtn = sizeBtn;
        sizeBtn.frame = frame;
    }
    
    self.frame = (CGRect){0, 0, kScreenW, CGRectGetMaxY(lastBtn.frame)+bottomSpace};
    _totalHeight = self.frame.size.height;
    _totalLine = (_totalHeight-topSpace-bottomSpace+itemSpaceV)/(itemSpaceV+height);
}

#pragma mark action
- (void)chooseTag:(UIButton *)sender {
    if (self.tagClick) {
        self.tagClick(sender,sender.tag-1024);
    }
    
    if (_resetAllTagWhenSingleClick) {
        // 重置
        for (int i = 0; i<_dataArr.count; i++) {
            UIButton * btn = [self viewWithTag:kTagBase+i];
            if (sender == btn) {
                btn.selected = YES;
                btn.backgroundColor = kYellowColor;
                btn.layer.borderWidth = 0;
            }else {
                btn.selected = NO;
                btn.backgroundColor = [UIColor whiteColor];
                btn.layer.borderWidth = 0.5;
            }
        }
    }else {
        
    }
}

@end
