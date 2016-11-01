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
    NSMutableArray * _tagsArr;
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
    _tagsArr = [NSMutableArray array];
    [self removeTags];
    [self sizeBtn:arr];
    [view addSubview:self];
}

- (void)removeTags {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
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
    
    if (!_tagSelectedColor) {
        _tagSelectedColor = [UIColor cyanColor];
    }
    
    if (!_tagUnSelectedColor) {
        _tagUnSelectedColor = [UIColor whiteColor];
    }
    
    if (_maxWidth<=0) {
        _maxWidth = kScreenW;
    }
    
    //    循环创建数组
    CGFloat validitySpace = _maxWidth-leftSpace-rightSpace;      // 可用的宽度
    UIButton * lastBtn = nil;          // 上一个宽度
    
    for (int i = 0; i < arr.count; i++) {
        UIButton * sizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sizeBtn.userInteractionEnabled = _tagShouldClick;
        [sizeBtn setBackgroundColor:_tagUnSelectedColor];
        sizeBtn.layer.borderWidth = 1;
        sizeBtn.layer.borderColor = kColorLine1.CGColor;
        sizeBtn.layer.cornerRadius = height/2;
        sizeBtn.layer.masksToBounds = YES;
        [sizeBtn setTitleColor:kColorGray1 forState:UIControlStateNormal];
        sizeBtn.titleLabel.font = [UIFont defaultFontWithSize:14.0];
        sizeBtn.tag = kTagBase+i;
        sizeBtn.selected = NO;
        
        for (NSString * value in self.tagsStartStatusArr) {
            if ([value isEqual:arr[i]]) {
                sizeBtn.selected = YES;
                sizeBtn.backgroundColor = _tagSelectedColor;
                sizeBtn.layer.borderWidth = 0;
                [sizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_tagsArr addObject:@(i)];
            }
        }
        
        [sizeBtn setTitle:arr[i] forState:UIControlStateNormal];
        [self addSubview:sizeBtn];
        
        [sizeBtn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [arr[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont defaultFontWithSize:12.0]} context:nil].size;
        size = CGSizeMake(size.width+12, size.height);
        CGRect frame = CGRectZero;
        
        
        if (_shouldEqualItemWitdh) {
            size = CGSizeMake(_width?:30, size.height);
        }
        
        validitySpace = _maxWidth-CGRectGetMaxX(lastBtn.frame)-rightSpace-itemSpaceH;
        
        if (!lastBtn) {
            // 第一行 第一个
            if (size.width >= _maxWidth-leftSpace-rightSpace) {
                size.width = _maxWidth-leftSpace-rightSpace;
            }
            frame = (CGRect){leftSpace, topSpace, size.width, height};
        }else {
            if (size.width >= validitySpace) {
                if (size.width >= (_maxWidth-leftSpace-rightSpace) ) {
                    size.width = _maxWidth-leftSpace-rightSpace;
                }
                frame = (CGRect){leftSpace, CGRectGetMaxY(lastBtn.frame)+itemSpaceV, size.width, height};
            }else {
                frame = (CGRect){CGRectGetMaxX(lastBtn.frame)+itemSpaceH, CGRectGetMinY(lastBtn.frame), size.width, height};
            }
        }
        
        lastBtn = sizeBtn;
        sizeBtn.frame = frame;
    }
    
    self.frame = (CGRect){0, 0, _maxWidth, CGRectGetMaxY(lastBtn.frame)+bottomSpace};
    _totalHeight = CGRectGetMaxY(lastBtn.frame)+bottomSpace;
    _totalLine = (_totalHeight-topSpace-bottomSpace+itemSpaceV)/(itemSpaceV+height);
}

#pragma mark action
- (void)chooseTag:(UIButton *)sender {
    if (_resetAllTagWhenSingleClick) {
        // 重置
        for (int i = 0; i<_dataArr.count; i++) {
            UIButton * btn = [self viewWithTag:kTagBase+i];
            if (sender == btn) {
                [self setBtnSelectedStatus:btn];
                [_tagsArr removeAllObjects];
                [_tagsArr addObject:@(i)];
            }else {
                [self setBtnUnSelectedStatus:btn];
            }
        }
    }else {
        if (sender.selected) {
            [self setBtnUnSelectedStatus:sender];
        }else {
            [self setBtnSelectedStatus:sender];
        }
        
        if ([_tagsArr containsObject:@(sender.tag-kTagBase)]) {
            [_tagsArr removeObject:@(sender.tag-kTagBase)];
        }else {
            [_tagsArr addObject:@(sender.tag-kTagBase)];
        }
    }
    if (self.tagClick) {
        self.tagClick(sender,sender.tag-kTagBase);
    }
    if (self.tagsArrClick) {
        self.tagsArrClick(_tagsArr);
    }
}

- (NSArray *)tagsIndexArr {
    return _tagsArr;
}

- (void)setBtnSelectedStatus:(UIButton *)btn {
    btn.selected = YES;
    btn.backgroundColor = _tagSelectedColor;
    btn.layer.borderWidth = 0;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setBtnUnSelectedStatus:(UIButton *)btn {
    btn.selected = NO;
    btn.backgroundColor = _tagUnSelectedColor;
    btn.layer.borderWidth = 1;
    [btn setTitleColor:kColorGray1 forState:UIControlStateNormal];
}

@end
