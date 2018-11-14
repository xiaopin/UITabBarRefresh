//
//  UITabBar+XPTabBarRefresh.h
//  https://github.com/xiaopin/UITabBarRefresh.git
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XPTabBarRefreshViewAnimating;
typedef void(^XPTabBarRefreshBlock)(UITabBar *tabBar, UITabBarItem *tabBarItem);


NS_CLASS_AVAILABLE_IOS(8_0) @interface UITabBarItem (XPTabBarRefresh)

/// 刷新回调
@property (nonatomic, copy) XPTabBarRefreshBlock refreshBlock;
/// 刷新动画视图, 默认`UIActivityIndicatorView`
@property (nonatomic, strong) UIView<XPTabBarRefreshViewAnimating> *refreshView;
/// 是否启用刷新动画, 默认`NO`
@property (nonatomic, assign, getter=isEnabledRefreshAnimation) BOOL enabledRefreshAnimation;

/// 停止刷新(请在`refreshBlock`回调中调用该方法)
- (void)stopRefresh;

@end


NS_CLASS_AVAILABLE_IOS(8_0) @interface UITabBar (XPTabBarRefresh)

@end


@protocol XPTabBarRefreshViewAnimating <NSObject>

/// 开始刷新动画
- (void)startRefreshAnimating;
/// 结束刷新动画
- (void)stopRefreshAnimating;

@end
