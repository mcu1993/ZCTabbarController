//
//  ZCTabBarItem.h
//  自己写个第三方库
//
//  Created by HZC on 17/1/2.
//  Copyright © 2017年 huiaijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCTabBarItem : UIButton
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger index;
@end
