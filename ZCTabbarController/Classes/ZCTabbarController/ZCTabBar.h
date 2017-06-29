//
//  ZCTabBar.h
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTabBarItem.h"
@class ZCTabBar;
@protocol ZCTabBarDelegate <NSObject>
@optional
/**
 *  是否能切换到指定index
 */
- (BOOL)zc_tabBar:(ZCTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index;

/**
 *  将要切换到指定index
 */
- (void)zc_tabBar:(ZCTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index;

/**
 *  已经切换到指定index
 */
- (void)zc_tabBar:(ZCTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index;
@end
@interface ZCTabBar : UIView
@property (nonatomic, assign) BOOL didViewAppeared;
/**
 *  TabItems，提供给ZCTabBarController使用，一般不手动设置此属性
 */
@property (nonatomic, copy) NSArray <ZCTabBarItem *> *items;
/**
 *  标签栏的scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
// 选中某一个item
@property (nonatomic, assign) NSUInteger selectedItemIndex;
// item的选中颜色
@property (nonatomic, strong) UIColor *selectedItemColor;
// item的正常颜色
@property (nonatomic, strong) UIColor *normalItemColor;
// 选中背景
@property (nonatomic, strong) UIView *selectedBgView;
@property (nonatomic, assign) CGSize selectedBgViewSize;
// item内边距
@property (nonatomic, assign) CGFloat itemLeftAndRightPadding;
// item字体大小
@property (nonatomic, strong) UIFont *itemFont;
// tabBar内边距
@property (nonatomic, assign) CGFloat tabBarLeftAndRightPadding;
// 普通状态下item的比例
@property (nonatomic, assign) CGFloat normalItemScaleSize;
// 选中状态下item的比例
@property (nonatomic, assign) CGFloat selectedItemScaleSize;
//等分
@property (nonatomic, assign) BOOL fixedSize;
//分割线
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic,weak)id<ZCTabBarDelegate>delegate;

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;

@end
