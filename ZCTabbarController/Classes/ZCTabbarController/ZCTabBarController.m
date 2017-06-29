//
//  ZCTabBarController.m
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import "ZCTabBarController.h"
#import <objc/runtime.h>
#define TAB_BAR_HEIGHT 49
//-------------------------------------------------//
//-----自定义UIScrollView，在需要时可以拦截其滑动手势-----//
//-------------------------------------------------//
@class ZCTabContentScrollView;

@protocol ZCTabContentScrollViewDelegate <NSObject>

@optional

- (BOOL)scrollView:(ZCTabContentScrollView *)scrollView shouldScrollToPageIndex:(NSUInteger)index;

@end

@interface ZCTabContentScrollView : UIScrollView

@property (nonatomic, weak) id<ZCTabContentScrollViewDelegate> zc_delegate;

@property (nonatomic, assign) BOOL interceptLeftSlideGuetureInLastPage;
@property (nonatomic, assign) BOOL interceptRightSlideGuetureInFirstPage;
@end

@implementation ZCTabContentScrollView

/**
 *  重写此方法，在需要的时候，拦截UIPanGestureRecognizer
 */
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
//    if (![gestureRecognizer respondsToSelector:@selector(translationInView:)]) {
//        return YES;
//    }
//    // 计算可能切换到的index
//    NSInteger currentIndex = self.contentOffset.x / self.frame.size.width;
//    NSInteger targetIndex = currentIndex;
//
//    CGPoint translation = [gestureRecognizer translationInView:self];
//    if (translation.x > 0) {
//        targetIndex = currentIndex - 1;
//    } else {
//        targetIndex = currentIndex + 1;
//    }
//
//    // 第一页往右滑动
//    if (self.interceptRightSlideGuetureInFirstPage && targetIndex < 0) {
//        return NO;
//    }
//
//    // 最后一页往左滑动
//    if (self.interceptLeftSlideGuetureInLastPage) {
//        NSUInteger numberOfPage = self.contentSize.width / self.frame.size.width;
//        if (targetIndex >= numberOfPage) {
//            return NO;
//        }
//    }
//
//    // 其他情况
//    if (self.yp_delegate && [self.yp_delegate respondsToSelector:@selector(scrollView:shouldScrollToPageIndex:)]) {
//        return [self.yp_delegate scrollView:self shouldScrollToPageIndex:targetIndex];
//    }
//
//    return YES;
//}
@end
#pragma mark - UIViewController (ZCTabBarController)

//-------------------------------------------------//
//--------------UIViewController分类----------------//
//-------------------------------------------------//
@implementation UIViewController (ZCTabBarController)

- (NSString *)zc_tabItemTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZc_tabItemTitle:(NSString *)zc_tabItemTitle {
    self.zc_tabItem.title = zc_tabItemTitle;
    objc_setAssociatedObject(self, @selector(zc_tabItemTitle), zc_tabItemTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (ZCTabBarItem *)zc_tabItem {
    ZCTabBar *tabBar = self.zc_tabBarController.tabBar;
    if (!tabBar) {
        return nil;
    }
    if (![self.zc_tabBarController.viewControllers containsObject:self]) {
        return nil;
    }
    
    NSUInteger index = [self.zc_tabBarController.viewControllers indexOfObject:self];
    return tabBar.items[index];
}

- (ZCTabBarController *)zc_tabBarController {
    return (ZCTabBarController *)self.parentViewController;
}

- (void)zc_tabItemDidSelected:(BOOL)isFirstTime {}

- (void)tabItemDidSelected {}

- (void)zc_tabItemDidDeselected {}

- (void)tabItemDidDeselected {}

- (BOOL)zc_isTabItemSelectedFirstTime {
    id selected = objc_getAssociatedObject(self, _cmd);
    if (!selected) {
        return YES;
    }
    return [selected boolValue];
}

@end

//-------------------------------------------------//
//--------------ZCTabBarController-----------------//
//-------------------------------------------------//

@interface ZCTabBarController ()<UIScrollViewDelegate, ZCTabContentScrollViewDelegate>{
    BOOL _didViewAppeared;//用于第一次viewWillAppear时
    CGFloat _lastContentScrollViewOffsetX;
}
@property (nonatomic, strong) ZCTabContentScrollView *contentScrollView;
@end
@implementation ZCTabBarController
//-(void)dealloc{
    //移除监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
//}
-(instancetype)init{
    self = [super init];
    if (self) {
        //监听StatusBarFrame
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self setup];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    //监听StatusBarFrame
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [self setup];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听StatusBarFrame
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidBecomeActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self setup];
    }
    return self;
}

//- (void)applicationDidChangeStatusBarFrame{
//    if([UIApplication sharedApplication].statusBarFrame.size.height == 40){
////        self.contentScrollView.y = - 20;
////        self.contentViewFrame
//        [self setTabBarFrame:CGRectMake(0, 64, ScreenWidth, 44) contentViewFrame:CGRectMake(0, 64 + 44, ScreenWidth, ScreenHeight - 64 - 44 - 20)];
//    }else{
//        [self setTabBarFrame:CGRectMake(0, 64, ScreenWidth, 44) contentViewFrame:CGRectMake(0, 64 + 44, ScreenWidth, ScreenHeight - 64 - 44)];
////        self.contentScrollView.y = 0;
//    }
//    HAJLog(@"%@",NSStringFromCGRect(self.tabBar.frame));
//}

//set
- (void)setContentViewFrame:(CGRect)contentViewFrame {
    _contentViewFrame = contentViewFrame;
    [self updateContentViewsFrame];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    //移除之前创建的所有controller
    for (UIViewController *controller in _viewControllers) {
        [controller removeFromParentViewController];
        if (controller.isViewLoaded) {//判断控制器的view是否加载
            [controller.view removeFromSuperview];//如果已经加载那么就移除view
        }
    }
    
    _viewControllers = [viewControllers copy];
    
    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *controller in _viewControllers) {
        [self addChildViewController:controller];
        //创建标签
        ZCTabBarItem *item = [ZCTabBarItem buttonWithType:UIButtonTypeCustom];
        //标签的标题
        item.title = controller.zc_tabItemTitle;
        [items addObject:item];
    }
    self.tabBar.fixedSize = _fixedSize;
    self.tabBar.items = items;//标签栏所有的标签
    if (_didViewAppeared) {
        _selectedControllerIndex = NSNotFound;
        self.tabBar.selectedItemIndex = 1;
    }
    
    // 更新scrollView的content size
    if (self.contentScrollView) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * _viewControllers.count,self.contentViewFrame.size.height);
    }
}
- (void)setSelectedControllerIndex:(NSUInteger)selectedControllerIndex {
    self.tabBar.selectedItemIndex = selectedControllerIndex;
}

- (UIViewController *)selectedController {
    if (self.selectedControllerIndex != NSNotFound) {
        return self.viewControllers[self.selectedControllerIndex];
    }
    return nil;
}
- (void)setContentScrollEnabledAndTapSwitchAnimated:(BOOL)switchAnimated contentViewBackgroundColor:(UIColor *)contentViewBackgroundColor{
    if (!self.contentScrollView) {
        self.contentScrollView = [[ZCTabContentScrollView alloc] initWithFrame:self.contentViewFrame];
        self.contentScrollView.pagingEnabled = YES;
        self.contentScrollView.backgroundColor = contentViewBackgroundColor;
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.showsVerticalScrollIndicator = NO;
        self.contentScrollView.scrollsToTop = NO;
        self.contentScrollView.delegate = self;
        self.contentScrollView.zc_delegate = self;
        [self.view insertSubview:self.contentScrollView belowSubview:self.tabBar];
        self.contentScrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * self.viewControllers.count, self.contentViewFrame.size.height);
    }
    [self updateContentViewsFrame];
//    self.contentSwitchAnimated = switchAnimated;
}

- (void)setTabBarNormalItemColor:(UIColor *)normalColor SelectedItemColor:(UIColor *)selectedColor{
    self.tabBar.selectedItemColor = selectedColor;
    self.tabBar.normalItemColor = normalColor;
    self.tabBar.selectedBgView.backgroundColor = selectedColor;
}

- (void)setSelectBgSize:(CGSize)size{
    self.tabBar.selectedBgViewSize = size;
}

- (void)setTabBarLeftAndRightPadding:(double)tabBarPadding ItemLeftAndRightPadding:(double)itemPadding{
    self.tabBar.itemLeftAndRightPadding = itemPadding;
    self.tabBar.tabBarLeftAndRightPadding = tabBarPadding;
}

- (void)setItemFont:(UIFont *)font NormalItemScaleSize:(double)normalItemScaleSize SelectedItemScaleSize:(double)selectedItemScaleSize{
    self.tabBar.itemFont = font;
    self.tabBar.normalItemScaleSize = normalItemScaleSize;
    self.tabBar.selectedItemScaleSize = selectedItemScaleSize;
}




/*
 初始化
 */
- (void)setup{
    //选中的控制器下标默认为没有
    _selectedControllerIndex = NSNotFound;
    _tabBar = [[ZCTabBar alloc] init];
    _tabBar.delegate = self;
    //默认选中的控制器下标
    _defaultSelectedControllerIndex = 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 在第一次调用viewWillAppear方法时，初始化选中的item
    if (!_didViewAppeared) {
        self.tabBar.didViewAppeared = _didViewAppeared;
        self.tabBar.selectedItemIndex = self.defaultSelectedControllerIndex;
        _didViewAppeared = YES;
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupFrameOfTabBarAndContentView];
    [self.view addSubview:self.tabBar];
}
/*
 设置默认标签栏和内容视图的frame
 */
- (void)setupFrameOfTabBarAndContentView{
    // 设置默认的tabBar的frame和contentViewFrame
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat contentViewY = 0;
    CGFloat tabBarY = screenSize.height - TAB_BAR_HEIGHT;
    CGFloat contentViewHeight = tabBarY;
    [self setTabBarFrame:CGRectMake(0, tabBarY, screenSize.width, TAB_BAR_HEIGHT)
        contentViewFrame:CGRectMake(0, contentViewY, screenSize.width, contentViewHeight)];
}
/*
 设置标签栏和内容视图的frame
 */
- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame{
    self.tabBar.frame = tabBarFrame;
    self.contentViewFrame = contentViewFrame;
}

// 更新内容视图frame
- (void)updateContentViewsFrame {
    if (self.contentScrollView) {
        self.contentScrollView.frame = self.contentViewFrame;
        self.contentScrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * self.viewControllers.count,
                                                        self.contentViewFrame.size.height);
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller,
                                                           NSUInteger idx, BOOL * _Nonnull stop) {
            if (controller.isViewLoaded) {
                controller.view.frame = [self frameForControllerAtIndex:idx];
            }
        }];
        [self.contentScrollView scrollRectToVisible:self.selectedController.view.frame animated:NO];
    } else {
        self.selectedController.view.frame = self.contentViewFrame;
    }
}

- (CGRect)frameForControllerAtIndex:(NSUInteger)index {
    return CGRectMake(index * self.contentViewFrame.size.width,
                      0,
                      self.contentViewFrame.size.width,
                      self.contentViewFrame.size.height);
}
#pragma mark - ZCTabBarDelegate
//item选中
- (void)zc_tabBar:(ZCTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index {
    if (index == self.selectedControllerIndex) {
        return;
    }
    UIViewController *oldController = nil;
    if (self.selectedControllerIndex != NSNotFound) {
        oldController = self.viewControllers[self.selectedControllerIndex];
        [oldController zc_tabItemDidDeselected];
    }
    UIViewController *curController = self.viewControllers[index];
    if (self.contentScrollView) {
        // contentView支持滚动
//        if (!curController.isViewLoaded) {
//            curController.view.frame = [self frameForControllerAtIndex:index];
//        }
        curController.view.frame = [self frameForControllerAtIndex:index];
        if (self.contentScrollView.contentOffset.x == curController.view.frame.origin.x && self.contentScrollView.contentOffset.x == 0) {
            [self.contentScrollView addSubview:curController.view];
        }
        // 切换到curController
        [self.contentScrollView scrollRectToVisible:curController.view.frame animated:YES];
    } else {
        // contentView不支持滚动
        [self.view insertSubview:curController.view belowSubview:self.tabBar];
        // 设置curController.view的frame
        if (!CGRectEqualToRect(curController.view.frame, self.contentViewFrame)) {
            curController.view.frame = self.contentViewFrame;
        }
    }
    
    BOOL isSelectedFirstTime = [curController zc_isTabItemSelectedFirstTime];
    if (isSelectedFirstTime) {
        objc_setAssociatedObject(curController, @selector(zc_isTabItemSelectedFirstTime), @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [curController zc_tabItemDidSelected:isSelectedFirstTime];
    
    // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
    if (oldController && [oldController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)oldController.view setScrollsToTop:NO];
    }
    if ([curController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)curController.view setScrollsToTop:YES];
    }
    
    _selectedControllerIndex = index;
    
    [self didSelectViewControllerAtIndex:_selectedControllerIndex];
}

- (void)didSelectViewControllerAtIndex:(NSUInteger)index {}

#pragma mark - ZCTabContentScrollViewDelegate

- (BOOL)scrollView:(ZCTabContentScrollView *)scrollView shouldScrollToPageIndex:(NSUInteger)index {
    if ([self respondsToSelector:@selector(zc_tabBar:shouldSelectItemAtIndex:)]) {
        return [self zc_tabBar:self.tabBar shouldSelectItemAtIndex:index];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIViewController *curController = self.viewControllers[page];
    [self.contentScrollView addSubview:curController.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.tabBar.selectedItemIndex = page;
    UIViewController *curController = self.viewControllers[page];
    [self.contentScrollView addSubview:curController.view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果不是手势拖动导致的此方法被调用，不处理
    if (!(scrollView.isDragging || scrollView.isDecelerating)) {
        return;
    }
    
    // 滑动越界不处理
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    if (offsetX < 0) {
        if (offsetX < -40) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }

    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    // 这里处理shouldSelectItemAtIndex方法
    if ([self respondsToSelector:@selector(zc_tabBar:shouldSelectItemAtIndex:)] && !scrollView.isDecelerating) {
        NSUInteger targetIndex;
        if (_lastContentScrollViewOffsetX < (CGFloat)offsetX) {
            // 向左
            targetIndex = rightIndex;
        } else {
            // 向右
            targetIndex = leftIndex;
        }
        if (targetIndex != self.selectedControllerIndex) {
            if (![self zc_tabBar:self.tabBar shouldSelectItemAtIndex:targetIndex]) {
                [scrollView setContentOffset:CGPointMake(self.selectedControllerIndex * scrollViewWidth, 0) animated:NO];
            }
        }
    }
    _lastContentScrollViewOffsetX = offsetX;
    // 同步修改tarBar的子视图状态
    [self.tabBar updateSubViewsWhenParentScrollViewScroll:self.contentScrollView];
}

- (void)setLineView:(CGRect)rect backgroundColor:(UIColor *)color{
    self.tabBar.lineView.frame = rect;
    self.tabBar.lineView.backgroundColor = color;
}

@end
