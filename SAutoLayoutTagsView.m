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

@implementation TagItem
- (CGFloat)itemWidth {
    return _itemWidth?:60.;
}
- (CGFloat)itemHeight {
    return _itemHeight?:30.;
}
- (CGFloat)itemInnerLeftSpace {
    return _itemInnerLeftSpace<0?0:_itemInnerLeftSpace;
}
- (CGFloat)itemInnerRightSpace {
    return _itemInnerRightSpace<0?0:_itemInnerRightSpace;
}
- (UIColor *)tagSelectedBGColor {
    return _tagSelectedBGColor?:[UIColor magentaColor];
}
- (UIColor *)tagUnSelectedBGColor {
    return _tagUnSelectedBGColor?:[UIColor whiteColor];
}
- (UIColor *)tagSelectedTitleColor {
    return _tagSelectedTitleColor?:[UIColor blackColor];
}
- (UIColor *)tagUnSelectedTitleColor {
    return _tagUnSelectedTitleColor?:[UIColor lightGrayColor];
}
- (CGFloat)tagSelectedCornerRadius {
    return _tagSelectedCornerRadius<0?0:_tagSelectedCornerRadius;
}
- (CGFloat)tagUnSelectedCornerRadius {
    return _tagUnSelectedCornerRadius<0?0:_tagUnSelectedCornerRadius;
}
- (CGFloat)tagSelectedBorderWidth {
    return _tagSelectedBorderWidth<0?0:_tagSelectedBorderWidth;
}
- (CGFloat)tagUnSelectedBorderWidth {
    return _tagUnSelectedBorderWidth<0?0:_tagUnSelectedBorderWidth;
}
- (UIColor *)tagSelectedBorderColor {
    return _tagSelectedBorderColor?:[UIColor whiteColor];
}
- (UIColor *)tagUnSelectedBorderColor {
    return _tagUnSelectedBorderColor?:[UIColor lightGrayColor];
}
- (UIFont *)tagSelectedFont {
    return _tagSelectedFont?:[UIFont systemFontOfSize:14.];
}
- (UIFont *)tagUnSelectedFont {
    return _tagUnSelectedFont?:[UIFont systemFontOfSize:14.];
}
- (UIColor *)tagHilightTitleColor {
    return _tagHilightTitleColor?:[UIColor whiteColor];
}
@end

@implementation LightLuxuryTagsView
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
        if ([view isKindOfClass:[TagItem class]]) {
            [view removeFromSuperview];
        }
    }
}
- (void)sizeBtn:(NSArray *)arr{
    if (!_item) {
        NSLog(@"tagsView -- item is nil");
        return;
    }
    
    CGFloat width = _item.itemWidth;
    CGFloat height = _item.itemHeight;
    CGFloat leftSpace = _leftSpace>=0?_leftSpace:12;             // 左边距
    CGFloat rightSpace = _rightSpace>=0?_rightSpace:12;           // 右边距
    CGFloat topSpace = _topSpace>=0?_topSpace:5;                // 上边距
    CGFloat bottomSpace = _bottomSpace>=0?_bottomSpace:5;          // 下边距
    CGFloat itemSpaceH = _itemSpaceH>=0?_itemSpaceH:10;           // 水平间距
    CGFloat itemSpaceV = _itemSpaceV>=0?_itemSpaceV:5;            // 竖直间距
    CGFloat itemInnerLeftSpac = _item.itemInnerLeftSpace;
    CGFloat itemInnerRightSpace = _item.itemInnerRightSpace;
    NSString * hilightTitle = _tagHilightTitle?:@"";
    
    if (_maxWidth<=0) {
        _maxWidth = kScreenW;
    }
    
    //    循环创建数组
    CGFloat validitySpace = _maxWidth-leftSpace-rightSpace;      // 可用的宽度
    TagItem * lastBtn = nil;          // 上一个宽度
    
    for (int i = 0; i < arr.count; i++) {
        TagItem * sizeBtn = [TagItem buttonWithType:UIButtonTypeCustom];
        sizeBtn.userInteractionEnabled = _tagShouldClick;
        [sizeBtn setBackgroundColor:_item.tagUnSelectedBGColor];
        sizeBtn.layer.borderWidth = _item.tagUnSelectedBorderWidth;
        sizeBtn.layer.borderColor = _item.tagUnSelectedBorderColor.CGColor;
        sizeBtn.layer.cornerRadius = _item.tagUnSelectedCornerRadius;
        sizeBtn.layer.masksToBounds = YES;
        [sizeBtn setTitleColor:_item.tagUnSelectedTitleColor forState:UIControlStateNormal];
        sizeBtn.titleLabel.font = _item.tagUnSelectedFont;
        sizeBtn.tag = kTagBase+i;
        sizeBtn.selected = NO;
        NSString * title = arr[i];
        // 限制字数
        if (self.maxTagTextlength > 0) {
            if (title.length > self.maxTagTextlength) {
                title = [title substringToIndex:self.maxTagTextlength];
            }
        }
        [sizeBtn setTitle:title forState:UIControlStateNormal];
        [self addSubview:sizeBtn];
        
        for (NSString * value in self.selectedTagsArr) {
            if ([value isEqual:title]) {
                sizeBtn.selected = YES;
                sizeBtn.backgroundColor = _item.tagSelectedBGColor;
                sizeBtn.layer.borderWidth = _item.tagSelectedBorderWidth;
                sizeBtn.layer.cornerRadius = _item.tagSelectedCornerRadius;
                sizeBtn.layer.borderColor = _item.tagSelectedBorderColor.CGColor;
                [sizeBtn setTitleColor:_item.tagSelectedTitleColor forState:UIControlStateNormal];
                sizeBtn.titleLabel.font = _item.tagSelectedFont;
                [_tagsArr addObject:@(i)];
            }
        }
        
        // 高亮处理
        NSRange hilightRange = [title rangeOfString:hilightTitle];
        if (self.tagHilightTitle && self.tagHilightTitle.length>0 && hilightRange.location != NSNotFound) {
            NSMutableAttributedString * hilightAttribute = [[NSMutableAttributedString alloc] initWithString:title];
            [hilightAttribute addAttribute:NSForegroundColorAttributeName value:sizeBtn.titleLabel.textColor range:NSMakeRange(0, title.length)];
            [hilightAttribute addAttribute:NSForegroundColorAttributeName value:_item.tagHilightTitleColor range:hilightRange];
            [sizeBtn setAttributedTitle:hilightAttribute forState:UIControlStateNormal];
        }
        
        [sizeBtn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:_item.tagUnSelectedFont} context:nil].size;
        if (self.shouldEqualItemWitdh) {
            // 等宽
            size = CGSizeMake(width+itemInnerLeftSpac+itemInnerRightSpace, size.height);
        }else {
            size = CGSizeMake(size.width+itemInnerLeftSpac+itemInnerRightSpace, size.height);
        }
        CGRect frame = CGRectZero;
        
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
- (void)chooseTag:(TagItem *)sender {
    if (_resetAllTagWhenSingleClick) {
        // 重置
        for (int i = 0; i<_dataArr.count; i++) {
            TagItem * btn = [self viewWithTag:kTagBase+i];
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

- (void)setBtnSelectedStatus:(TagItem *)btn {
    btn.selected = YES;
    btn.layer.cornerRadius = _item.tagSelectedCornerRadius;
    btn.layer.borderColor = _item.tagSelectedBorderColor.CGColor;
    btn.titleLabel.font = _item.tagSelectedFont;
    btn.backgroundColor = _item.tagSelectedBGColor;
    btn.layer.borderWidth = _item.tagSelectedBorderWidth;
    [btn setTitleColor:_item.tagSelectedTitleColor forState:UIControlStateNormal];
}

- (void)setBtnUnSelectedStatus:(TagItem *)btn {
    btn.selected = NO;
    btn.layer.cornerRadius = _item.tagUnSelectedCornerRadius;
    btn.layer.borderColor = _item.tagUnSelectedBorderColor.CGColor;
    btn.titleLabel.font = _item.tagUnSelectedFont;
    btn.backgroundColor = _item.tagUnSelectedBGColor;
    btn.layer.borderWidth = _item.tagUnSelectedBorderWidth;
    [btn setTitleColor:_item.tagUnSelectedTitleColor forState:UIControlStateNormal];
}

@end
