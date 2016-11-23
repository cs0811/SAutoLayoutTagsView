//
//  SAutoLayoutTagsView.h
//  Test
//
//  Created by du on 16/9/24.
//  Copyright © 2016年 dufei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagItem : UIButton
/**
 每个标签高   (默认 30.)
 */
@property (nonatomic, assign) CGFloat itemHeight;
/**
 每个标签宽 （适用于等宽标签）   (默认 60.)
 */
@property (nonatomic, assign) CGFloat itemWidth;
/**
 标签内左边距   (默认 6.)
 */
@property (nonatomic, assign) CGFloat itemInnerLeftSpace;
/**
 标签内右边距   (默认 6.)
 */
@property (nonatomic, assign) CGFloat itemInnerRightSpace;
/**
 标签选中背景颜色
 */
@property (nonatomic, strong) UIColor * tagSelectedBGColor;
/**
 标签未选中背景颜色
 */
@property (nonatomic, strong) UIColor * tagUnSelectedBGColor;
/**
 标签选中标签颜色
 */
@property (nonatomic, strong) UIColor * tagSelectedTitleColor;
/**
 标签未选中标签颜色
 */
@property (nonatomic, strong) UIColor * tagUnSelectedTitleColor;
/**
 标签选中圆角
 */
@property (nonatomic, assign) CGFloat tagSelectedCornerRadius;
/**
 标签未选中圆角
 */
@property (nonatomic, assign) CGFloat tagUnSelectedCornerRadius;
/**
 标签选中边框宽
 */
@property (nonatomic, assign) CGFloat tagSelectedBorderWidth;
/**
 标签未选中边框宽
 */
@property (nonatomic, assign) CGFloat tagUnSelectedBorderWidth;
/**
 标签选中边框颜色
 */
@property (nonatomic, strong) UIColor * tagSelectedBorderColor;
/**
 标签未选中边框颜色
 */
@property (nonatomic, strong) UIColor * tagUnSelectedBorderColor;
@property (nonatomic, strong) UIFont * tagSelectedFont;
@property (nonatomic, strong) UIFont * tagUnSelectedFont;
@property (nonatomic, strong) UIColor * tagHilightTitleColor;
@end


@interface LightLuxuryTagsView : UIView
/*
 *  左边距     (默认 12.)
 */
@property (nonatomic, assign) CGFloat leftSpace;
/*
 *  右边距     (默认 12.)
 */
@property (nonatomic, assign) CGFloat rightSpace;
/*
 *  上边距     (默认 5.)
 */
@property (nonatomic, assign) CGFloat topSpace;
/*
 *  下边距     (默认 5.)
 */
@property (nonatomic, assign) CGFloat bottomSpace;
/*
 *  水平边距    (默认 10.)
 */
@property (nonatomic, assign) CGFloat itemSpaceH;
/*
 *  竖直边距    (默认 5.)
 */
@property (nonatomic, assign) CGFloat itemSpaceV;

/*
 *  当一个标签被点击时，其他标签都设置为未选择       (默认 YES)
 */
@property (nonatomic, assign) BOOL resetAllTagWhenSingleClick;

/*
 *  已选中的标签,初始时传入
 */
@property (nonatomic, copy) NSArray * selectedTagsArr;

/*
 *  总行数
 */
@property (nonatomic, assign, readonly) NSInteger totalLine;
/*
 *  总高度
 */
@property (nonatomic, assign, readonly) CGFloat totalHeight;

/**
 标签能否被点击
 */
@property (nonatomic, assign) BOOL tagShouldClick;

/**
 标签是否等宽
 */
@property (nonatomic, assign) BOOL shouldEqualItemWitdh;

/*
 *  控件宽度
 */
@property (nonatomic, assign) CGFloat maxWidth;

/*
 *  最后选择的tag下标
 */
@property (nonatomic, strong, readonly) NSArray * tagsIndexArr;

@property (nonatomic, strong) TagItem * item;

@property (nonatomic, copy) NSString * tagHilightTitle;

/**
 限制每个标签字数
 */
@property (nonatomic, assign) NSInteger maxTagTextlength;

@property (nonatomic, copy) void(^tagClick)(UIButton *tagBtn, NSInteger index);
@property (nonatomic, copy) void(^tagsArrClick)(NSArray * indexArr);


- (void)showTagsWithDataArr:(NSArray *)arr onView:(UIView *)view;

@end
