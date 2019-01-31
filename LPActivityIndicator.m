//
//  LPActivityIndicator.m
//  Test
//
//  Created by Jack on 2019/1/31.
//  Copyright © 2019 Jack Template. All rights reserved.
//

#import "LPActivityIndicator.h"

static const NSInteger kReplicationCount = 3;
static const CGFloat kSize = 20.f;
static const CGFloat kInterval = 5.f;
static const CGFloat kWidth = kSize * kReplicationCount + kInterval * (kReplicationCount - 1);
static const CGFloat kHeight = kSize;
static NSString * const kAnimationKey = @"lp.activity.indictor.animation";


@interface LPActivityIndicator ()

@property (nonatomic,strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic,strong) CAShapeLayer *activityLayer;

@end

@implementation LPActivityIndicator

+ (instancetype)activityIndicatorWithType:(LPActivityType)type {
    
    LPActivityIndicator *loadingView = [[LPActivityIndicator alloc] initPrivateFrame:CGRectMake(0, 0, kWidth, kHeight)];
    
    [loadingView setup:type];
    return loadingView;
}

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
}

- (void)setBounds:(CGRect)bounds {
    
}

- (void)setTintColor:(UIColor *)tintColor {
    self.activityLayer.fillColor = tintColor.CGColor;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (hidden) {
        [self stopAnimating];
    } else{
        [self startAnimating];
    }
}

#pragma mark - Setup

- (void)lp_setFrame:(CGRect)frame {
    super.frame = frame;
}

- (instancetype)initPrivateFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self lp_setFrame:frame];
    }
    return self;
}

- (void)setup:(LPActivityType)type {
    
    self.replicatorLayer.frame = self.bounds;
    [self.layer addSublayer:self.replicatorLayer];
    
    switch (type) {
        case LPActivityTypeDot: {
            self.activityLayer.path = [self dotPath].CGPath;
        }
            break;
        case LPActivityTypeSlash: {
            self.activityLayer.path = [self slashPath].CGPath;
        }
            break;
    }
    [self.replicatorLayer addSublayer:self.activityLayer];
    
    [self startAnimating];
}

#pragma mark - Path

// 斜杠
- (UIBezierPath *)slashPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(kSize * 0.5, 0)];
    [path addLineToPoint:CGPointMake(kSize, kSize)];
    [path addLineToPoint:CGPointMake(kSize * 0.5, kSize)];
    [path closePath];
    return path;
}

// 圆点
- (UIBezierPath *)dotPath {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kSize, kSize)];
    return path;
}

#pragma mark - Getter

- (CAReplicatorLayer *)replicatorLayer {
    if (!_replicatorLayer) {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _replicatorLayer;
}

- (CAShapeLayer *)activityLayer {
    if (!_activityLayer) {
        _activityLayer = [CAShapeLayer layer];
        _activityLayer.fillColor = [UIColor darkGrayColor].CGColor;
    }
    return _activityLayer;
}

#pragma mark - Animation

- (CABasicAnimation *)alphaAnimation{
    //设置透明度动画
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @1.0;
    alpha.toValue = @0.01;
    alpha.duration = 1.f;
    return alpha;
}

- (CABasicAnimation *)scaleAnimation{
    //设置缩放动画
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @0.8;
    scale.fromValue = @1;
    return scale;
}

- (void)startAnimating {
    if (![self.activityLayer.animationKeys containsObject:kAnimationKey]) {
        
        //复制的图层数为三个
        self.replicatorLayer.instanceCount = kReplicationCount;
        //设置每个复制图层延迟时间
        self.replicatorLayer.instanceDelay = 1.f / kReplicationCount;
        //设置每个图层之间的偏移
        self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(kSize + kInterval, 0, 0);
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[[self alphaAnimation], [self scaleAnimation]];
        group.duration = 1.f;
        group.repeatCount = HUGE;
        [self.activityLayer addAnimation:group forKey:kAnimationKey];
    }
}

- (void)stopAnimating {
    if ([self.activityLayer.animationKeys containsObject:kAnimationKey]) {
        
        //复制的图层数为三个
        self.replicatorLayer.instanceCount = 0;
        
        [self.activityLayer removeAnimationForKey:kAnimationKey];
    }
}

@end
