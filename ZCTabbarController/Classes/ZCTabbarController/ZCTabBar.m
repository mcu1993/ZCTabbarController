//
//  ZCTabBar.m
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import "ZCTabBar.h"

@implementation ZCTabBar
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //初始化
    self.backgroundColor = [UIColor whiteColor];
    _selectedItemIndex = NSNotFound;
    _normalItemScaleSize = 1.0;
    _selectedItemScaleSize = 1.0;
    _itemFont = [UIFont systemFontOfSize:15];
    _selectedItemColor = [UIColor redColor];
    _normalItemColor = [UIColor blackColor];
    _selectedBgView.backgroundColor = [UIColor redColor];
    _itemLeftAndRightPadding = 20;
    _tabBarLeftAndRightPadding = 10;
}
- (void)setItems:(NSArray<ZCTabBarItem *> *)items{
    //将item从superview上移除
    [self.items enumerateObjectsUsingBlock:^(ZCTabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.selectedBgView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBgView.backgroundColor = _selectedItemColor;
        [self.scrollView addSubview:self.selectedBgView];
        [self addSubview:self.scrollView];
    }
    // 初始化每一个item
    for (ZCTabBarItem *item in items) {
        [item setTitleColor:self.normalItemColor forState:UIControlStateNormal];
        [item setTitleColor:self.selectedItemColor forState:UIControlStateSelected];
        item.titleLabel.font = self.itemFont;
        [item addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    _items = items;
    // 更新每个item的位置
    [self updateItemsFrame];
    
    // 更新item的大小缩放
    [self updateDefaultItemsScaleIfNeeded];
}
- (void)tabItemClicked:(ZCTabBarItem *)item{
    self.selectedItemIndex = item.index;
}
#pragma mark --- 更新每个item的位置
- (void)updateItemsFrame{
    if (self.items.count == 0) {
        return;
    }
    if(self.scrollView){
        
        //itemx轴的初始值
        CGFloat x = self.tabBarLeftAndRightPadding;
        for (int i = 0; i < self.items.count; i++) {
            //item的宽度
            CGFloat width = 0;
            //这里可以做是否匹配item的文字长度
            ZCTabBarItem *item = self.items[i];
            CGSize size = CGSizeZero;
            if (_fixedSize) {
                size = CGSizeMake([UIScreen mainScreen].bounds.size.width / self.items.count - (self.items.count + 1) * self.itemLeftAndRightPadding / self.items.count, self.frame.size.height);
            }else{
                size = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName : self.itemFont}
                                                context:nil].size;
            }
            width = size.width + self.itemLeftAndRightPadding;//item的宽度 + 左右间隔
            
            item.index = i;
            item.frame = CGRectMake(x, 0, width, self.frame.size.height);
            x += width;
            [self.scrollView addSubview:item];
        }
        self.scrollView.contentSize = CGSizeMake(MAX(x + self.tabBarLeftAndRightPadding, self.scrollView.frame.size.width),self.scrollView.frame.size.height);
    }
}
- (void)updateDefaultItemsScaleIfNeeded{
    ZCTabBarItem *defaultSelectedItem = self.items[_selectedItemIndex == NSNotFound ? 0 : _selectedItemIndex];
    defaultSelectedItem.transform = CGAffineTransformMakeScale(self.selectedItemScaleSize, self.selectedItemScaleSize);
    [self updateSelectedBgFrameWithIndex:_selectedItemIndex == NSNotFound ? 0 : _selectedItemIndex];
}
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    if (selectedItemIndex == _selectedItemIndex ||
        selectedItemIndex >= self.items.count ||
        self.items.count == 0) {
        return;
    }
    if (!_didViewAppeared) {
        if (_selectedItemIndex != NSNotFound) {
            ZCTabBarItem *oldSelectedItem = self.items[_selectedItemIndex];
            oldSelectedItem.selected = NO;
            
            oldSelectedItem.transform = CGAffineTransformMakeScale(self.normalItemScaleSize,self.normalItemScaleSize);
        }
        
        ZCTabBarItem *newSelectedItem = self.items[selectedItemIndex];
        newSelectedItem.selected = YES;
        
        newSelectedItem.transform = CGAffineTransformMakeScale(self.selectedItemScaleSize, self.selectedItemScaleSize);
        
        _selectedItemIndex = selectedItemIndex;
        
        [self updateSelectedBgFrameWithIndex:selectedItemIndex];
        
        // 如果tabbar支持滚动，将选中的item放到tabbar的中央
        [self setSelectedItemCenter];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(zc_tabBar:didSelectedItemAtIndex:)]) {
            [self.delegate zc_tabBar:self didSelectedItemAtIndex:selectedItemIndex];
        }
        
        _didViewAppeared = YES;
    }else{
        if (_selectedItemIndex != NSNotFound) {
            ZCTabBarItem *oldSelectedItem = self.items[_selectedItemIndex];
            oldSelectedItem.selected = NO;
            
            [UIView animateWithDuration:0.25f animations:^{
                oldSelectedItem.transform = CGAffineTransformMakeScale(self.normalItemScaleSize,self.normalItemScaleSize);
            }];
        }
        
        ZCTabBarItem *newSelectedItem = self.items[selectedItemIndex];
        newSelectedItem.selected = YES;
        
        [UIView animateWithDuration:0.25f animations:^{
            newSelectedItem.transform = CGAffineTransformMakeScale(self.selectedItemScaleSize, self.selectedItemScaleSize);
        }];
        
        _selectedItemIndex = selectedItemIndex;
        
        [UIView animateWithDuration:0.25f animations:^{
            [self updateSelectedBgFrameWithIndex:selectedItemIndex];
        }];
        
        // 如果tabbar支持滚动，将选中的item放到tabbar的中央
        [self setSelectedItemCenter];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(zc_tabBar:didSelectedItemAtIndex:)]) {
            [self.delegate zc_tabBar:self didSelectedItemAtIndex:selectedItemIndex];
        }
    }
    
}
- (void)setSelectedItemCenter{
    CGFloat centerX = CGRectGetMaxX(self.selectedBgView.frame) - self.selectedBgView.frame.size.width / 2;
    ZCTabBarItem *selectedItem = self.items[_selectedItemIndex];
    if (self.scrollView.contentOffset.x > selectedItem.frame.origin.x) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:_didViewAppeared];
    }
    if(centerX > self.scrollView.frame.size.width / 2){
        if ((centerX - self.scrollView.frame.size.width / 2) > (self.scrollView.contentSize.width - self.scrollView.frame.size.width)) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0) animated:_didViewAppeared];
            return;
        }
        [self.scrollView setContentOffset:CGPointMake(centerX - self.scrollView.frame.size.width / 2, 0) animated:_didViewAppeared];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:_didViewAppeared];
    }
}
- (void)updateSelectedBgFrameWithIndex:(NSUInteger)seletedItemIndex{
    if (seletedItemIndex != NSNotFound) {
        ZCTabBarItem *item = self.items[seletedItemIndex];
        if (self.selectedBgViewSize.width > 0) {
            self.selectedBgView.frame = CGRectMake(CGRectGetMinX(item.frame) + (item.frame.size.width / 2 - self.selectedBgViewSize.width / 2), self.frame.size.height - self.selectedBgViewSize.height, self.selectedBgViewSize.width, self.selectedBgViewSize.height);
        }else{
            self.selectedBgView.frame = CGRectMake(CGRectGetMinX(item.frame), self.frame.size.height - 1, item.frame.size.width, 1);
        }
        
    }
}
#pragma mark - Others
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    ZCTabBarItem *leftItem = self.items[leftIndex];
    ZCTabBarItem *rightItem = nil;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    //选中的字体比例
    CGFloat selectedFontSize = self.selectedItemScaleSize;
    //未选中的字体比例
    CGFloat normalFontSize = self.normalItemScaleSize;
    //字体比例差值
    CGFloat fontSizeDiff = selectedFontSize - normalFontSize;
    leftItem.transform = CGAffineTransformMakeScale(normalFontSize + fontSizeDiff * leftScale,normalFontSize + fontSizeDiff * leftScale);
    rightItem.transform = CGAffineTransformMakeScale(normalFontSize + fontSizeDiff * rightScale,normalFontSize + fontSizeDiff * rightScale);
    
    CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
    CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
    
    [self.normalItemColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
    [self.selectedItemColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
    // 获取选中和未选中状态的颜色差值
    CGFloat redDiff = selectedRed - normalRed;
    CGFloat greenDiff = selectedGreen - normalGreen;
    CGFloat blueDiff = selectedBlue - normalBlue;
    CGFloat alphaDiff = selectedAlpha - normalAlpha;
    
    // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
    leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                    green:leftScale * greenDiff + normalGreen
                                                     blue:leftScale * blueDiff + normalBlue
                                                    alpha:leftScale * alphaDiff + normalAlpha];
    rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed
                                                     green:rightScale * greenDiff + normalGreen
                                                      blue:rightScale * blueDiff + normalBlue
                                                     alpha:rightScale * alphaDiff + normalAlpha];
    // 计算背景的frame
    CGRect frame = self.selectedBgView.frame;
    
    if (self.selectedBgViewSize.width > 0) {
        CGFloat xDiff = (CGRectGetMinX(rightItem.frame) + (rightItem.frame.size.width / 2 - self.selectedBgViewSize.width / 2)) - (CGRectGetMinX(leftItem.frame) + (leftItem.frame.size.width / 2 - self.selectedBgViewSize.width / 2));
        
        frame.origin.x = rightScale * xDiff + (CGRectGetMinX(leftItem.frame) + (leftItem.frame.size.width / 2 - self.selectedBgViewSize.width / 2));
        CGFloat widthDiff = rightItem.frame.size.width - leftItem.frame.size.width;
        if (widthDiff != 0 && self.fixedSize == NO) {
            CGFloat leftSelectedBgWidth = leftItem.frame.size.width;
            frame.size.width = rightScale * widthDiff + leftSelectedBgWidth;
        }
    }else{
        CGFloat xDiff = rightItem.frame.origin.x - leftItem.frame.origin.x;
        frame.origin.x = rightScale * xDiff + leftItem.frame.origin.x;
        CGFloat widthDiff = rightItem.frame.size.width - leftItem.frame.size.width;
        if (widthDiff != 0) {
            CGFloat leftSelectedBgWidth = leftItem.frame.size.width;
            frame.size.width = rightScale * widthDiff + leftSelectedBgWidth;
        }
    }
    
    self.selectedBgView.frame = frame;
    
    CGFloat centerX = CGRectGetMaxX(self.selectedBgView.frame) - self.selectedBgView.frame.size.width / 2;
    
    
    if(centerX > self.scrollView.frame.size.width / 2){
        if ((centerX - self.scrollView.frame.size.width / 2) > (self.scrollView.contentSize.width - scrollView.frame.size.width)) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.frame.size.width, 0)];
            return;
        }
        
        CGFloat x = centerX - self.scrollView.frame.size.width / 2.0;
        [self.scrollView setContentOffset:CGPointMake(x, 0)];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 1, self.frame.size.width, 1);
        _lineView.backgroundColor = [UIColor blackColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

@end
