//
//  SAutoLayoutTagsView.h
//  Test
//
//  Created by du on 16/9/24.
//  Copyright © 2016年 dufei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAutoLayoutTagsView : UIView

/*
 *  每个标签高   (默认 30.)
 */
@property (nonatomic, assign) NSInteger height;
/*
 *  左边距     (默认 12.)
 */
@property (nonatomic, assign) NSInteger leftSpace;
/*
 *  右边距     (默认 12.)
 */
@property (nonatomic, assign) NSInteger rightSpace;
/*
 *  上边距     (默认 5.)
 */
@property (nonatomic, assign) NSInteger topSpace;
/*
 *  下边距     (默认 5.)
 */
@property (nonatomic, assign) NSInteger bottomSpace;
/*
 *  水平边距    (默认 10.)
 */
@property (nonatomic, assign) NSInteger itemSpaceH;
/*
 *  竖直边距    (默认 5.)
 */
@property (nonatomic, assign) NSInteger itemSpaceV;

/*
 *  当一个标签被点击时，其他标签都设置为未选择       (默认 YES)
 */
@property (nonatomic, assign) BOOL resetAllTagWhenSingleClick;

/*
 *  标签初始状态
 */
@property (nonatomic, copy) NSArray * tagsStartStatusArr;

/*
 *  总行数
 */
@property (nonatomic, assign, readonly) NSInteger totalLine;
/*
 *  总高度
 */
@property (nonatomic, assign, readonly) CGFloat totalHeight;

@property (nonatomic, assign) BOOL tagShouldClick;

@property (nonatomic, strong) UIColor * tagSelectedColor;

@property (nonatomic, strong) UIColor * tagUnSelectedColor;
/*
 *  控件宽度
 */
@property (nonatomic, assign) CGFloat maxWidth;


@property (nonatomic, copy) void(^tagClick)(UIButton *tagBtn, NSInteger index);

- (void)showTagsWithDataArr:(NSArray *)arr onView:(UIView *)view;
@end
