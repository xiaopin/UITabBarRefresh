//
//  CustomRefreshView.m
//  Example
//
//  Created by xiaopin on 2018/11/7.
//  Copyright © 2018 xiaopin. All rights reserved.
//

#import "CustomRefreshView.h"
#import "UITabBar+XPTabBarRefresh.h"

@implementation CustomRefreshView
{
    UIImageView *_animatingView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _animatingView = [[UIImageView alloc] init];
        _animatingView.image = [UIImage imageNamed:@"refresh"];
        _animatingView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_animatingView];
        [_animatingView.widthAnchor constraintEqualToConstant:30.0].active = YES;
        [_animatingView.heightAnchor constraintEqualToConstant:30.0].active = YES;
        [_animatingView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_animatingView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0].active = YES;
    }
    return self;
}

- (void)startRefreshAnimating {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [_animatingView.layer addAnimation:rotationAnimation forKey:nil];
}

- (void)stopRefreshAnimating {
    [_animatingView.layer removeAllAnimations];
}

@end
