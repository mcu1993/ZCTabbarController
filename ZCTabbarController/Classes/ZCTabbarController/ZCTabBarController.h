//
//  ZCTabBarController.h
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTabBar.h"
#import "ZCTabBarItem.h"

@interface ZCTabBarController : UIViewController<ZCTabBarDelegate>
@property (nonatomic, assign) BOOL fixedSize;

/**
 *  标签栏
 */
@property (nonatomic, strong) ZCTabBar *tabBar;
/**
 *  子控制器
 */
@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;
/**
 *  设置被选中的ViewController的Index，界面会自动切换
 */
@property (nonatomic, assign) NSUInteger selectedControllerIndex;

/**
 *  第一次显示时，默认被选中的ViewController的Index，在viewWillAppear方法被调用前设置有效
 */
@property (nonatomic, assign) NSUInteger defaultSelectedControllerIndex;
/*
    内容视图frame
 */
@property (nonatomic, assign) CGRect contentViewFrame;
/**
 *  获取被选中的ViewController
 */
- (UIViewController *)selectedController;

@property (nonatomic, copy) NSString *zc_tabItemTitle;

- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame;

- (void)setSelectBgSize:(CGSize)size;

- (void)setContentScrollEnabledAndTapSwitchAnimated:(BOOL)switchAnimated contentViewBackgroundColor:(UIColor *)contentViewBackgroundColor;

- (void)setTabBarNormalItemColor:(UIColor *)normalColor SelectedItemColor:(UIColor *)selectedColor;

- (void)setTabBarLeftAndRightPadding:(double)tabBarPadding ItemLeftAndRightPadding:(double)itemPadding;

- (void)setItemFont:(UIFont *)font NormalItemScaleSize:(double)normalItemScaleSize SelectedItemScaleSize:(double)selectedItemScaleSize;

- (void)setLineView:(CGRect)rect backgroundColor:(UIColor *)color;

@end

@interface UIViewController (ZCTabBarController)

@property (nonatomic, copy) NSString *zc_tabItemTitle; // tabItem的标题

- (ZCTabBarItem *)zc_tabItem;
- (ZCTabBarController *)zc_tabBarController;

/**
 *  ViewController对应的Tab被Select后，执行此方法，此方法为回调方法
 *
 *  @param isFirstTime  是否为第一次被选中
 */
- (void)zc_tabItemDidSelected:(BOOL)isFirstTime;

/**
 *  ViewController对应的Tab被Deselect后，执行此方法，此方法为回调方法
 */
- (void)zc_tabItemDidDeselected;



@end
