//
//  UITabBar+XPTabBarRefresh.m
//  https://github.com/xiaopin/UITabBarRefresh.git
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import "UITabBar+XPTabBarRefresh.h"
#import <objc/runtime.h>

@interface UITabBarItem (XPTabBarRefreshPrivate)

/// 是否正在刷新
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

/// 开始刷新
- (void)startRefresh;

@end

@implementation UITabBarItem (XPTabBarRefreshPrivate)

- (void)startRefresh {
    self.refreshing = YES;
    if (!self.isEnabledRefreshAnimation) {
        return;
    }
    UIView *containerView = (UIView *)[self valueForKey:@"_view"];
    if (containerView == nil || ![containerView isKindOfClass:UIView.class]) {
        return;
    }
    for (UIView *subview in containerView.subviews) {
        subview.hidden = YES;
    }
    UIView<XPTabBarRefreshViewAnimating> *animatingView = self.refreshView;
    [animatingView setUserInteractionEnabled:NO];
    [animatingView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:animatingView];
    NSDictionary *views = @{@"view" : animatingView};
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    [animatingView startRefreshAnimating];
}

- (void)stopRefresh {
    self.refreshing = NO;
    if (!self.isEnabledRefreshAnimation) {
        return;
    }
    UIView<XPTabBarRefreshViewAnimating> *animatingView = self.refreshView;
    for (UIView *subview in animatingView.superview.subviews) {
        subview.hidden = NO;
    }
    [animatingView stopRefreshAnimating];
    [animatingView removeFromSuperview];
}

- (void)setRefreshBlock:(XPTabBarRefreshBlock)refreshBlock {
    objc_setAssociatedObject(self, @selector(refreshBlock), refreshBlock, OBJC_ASSOCIATION_COPY);
}

- (XPTabBarRefreshBlock)refreshBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRefreshView:(UIView<XPTabBarRefreshViewAnimating> *)refreshView {
    objc_setAssociatedObject(self, @selector(refreshView), refreshView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView<XPTabBarRefreshViewAnimating> *)refreshView {
    UIView<XPTabBarRefreshViewAnimating> *view = objc_getAssociatedObject(self, _cmd);
    if (nil == view) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.hidesWhenStopped = YES;
        view = (UIView<XPTabBarRefreshViewAnimating> *)indicator;
        [self setRefreshView:view];
    }
    return view;
}

- (void)setEnabledRefreshAnimation:(BOOL)enabledRefreshAnimation {
    objc_setAssociatedObject(self, @selector(isEnabledRefreshAnimation), @(enabledRefreshAnimation), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isEnabledRefreshAnimation {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRefreshing:(BOOL)refreshing {
    objc_setAssociatedObject(self, @selector(isRefreshing), @(refreshing), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isRefreshing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end


#pragma mark -

@implementation UITabBar (XPTabBarRefresh)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = NSSelectorFromString(@"_buttonUp:");
        SEL swizllingSelector = @selector(xp_buttonUp:);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizlledMethod = class_getInstanceMethod(self, swizllingSelector);
        BOOL flag = class_addMethod(self, originalSelector, method_getImplementation(swizlledMethod), method_getTypeEncoding(swizlledMethod));
        if (flag) {
            class_replaceMethod(self, swizllingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizlledMethod);
        }
    });
}

- (void)xp_buttonUp:(UIControl *)sender {
    BOOL selected = [[sender valueForKey:@"_selected"] boolValue];
    if (selected) {
        UITabBarItem *item = self.selectedItem;
        XPTabBarRefreshBlock refreshBlock = [item refreshBlock];
        if (refreshBlock && !item.isRefreshing) {
            [item startRefresh];
            refreshBlock(self, item);
            return;
        }
    }
    [self xp_buttonUp:sender];
}

@end


#pragma mark -

@interface UIActivityIndicatorView (XPTabBarRefresh)<XPTabBarRefreshViewAnimating>

@end

@implementation UIActivityIndicatorView (XPTabBarRefresh)

- (void)startRefreshAnimating {
    [self startAnimating];
}

- (void)stopRefreshAnimating {
    [self stopAnimating];
}

@end
