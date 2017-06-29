//
//  ZCTabBarItem.m
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import "ZCTabBarItem.h"

@implementation ZCTabBarItem
-(void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
