//
//  MGYRefreshHeader.m
//  MGYanJiuYuan
//
//  Created by loaer on 2017/3/15.
//  Copyright © 2017年 loaer. All rights reserved.
//

#import "MGYRefreshHeader.h"

#define KStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

static const CGFloat MJDIYCircleRadiu = 8.0;
static const CGFloat MJDIYCircleLineWidth = 2.0;
static const CGFloat MJDIYEyeRadiuWidth = 1.0;

@interface MGYRefreshHeader()
@property (assign, nonatomic) BOOL adaptationIphoneX;

@property (weak, nonatomic)UIView *faceView;
@property (weak, nonatomic)CALayer *leftEye;
@property (weak, nonatomic)CALayer *rightEye;
@property (weak, nonatomic)CAShapeLayer *mouth;
@property (weak, nonatomic) UIImageView *logo;
@end

@implementation MGYRefreshHeader

+ (instancetype)headerAdaptationIphoneXWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    MGYRefreshHeader *cmp = [[super alloc]init];
    cmp.refreshingBlock = refreshingBlock;
    if(KStatusHeight>20){
        cmp.adaptationIphoneX = YES;
        cmp.mj_h = 74;
    }
    return cmp;
}

#pragma mark 在这里做一些初始化配置（比如添加子控件）

- (void)prepare{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 50;//适配iPhoneX
    
    //    self.backgroundColor = [UIColor grayColor];
    
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
//    logo.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:logo];
//    self.logo = logo;
    
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    self.faceView = view;
    
    CALayer *leftEyeLayer = [CALayer layer];
    leftEyeLayer.backgroundColor = [UIColor colorWithRed:50.0/255 green:218.0/255 blue:195.0/255 alpha:1.0].CGColor;
    leftEyeLayer.cornerRadius = MJDIYEyeRadiuWidth;
    [view.layer addSublayer:leftEyeLayer];
    self.leftEye = leftEyeLayer;
    
    CALayer *rightEyeLayer = [CALayer layer];
    rightEyeLayer.backgroundColor = [UIColor colorWithRed:50.0/255 green:218.0/255 blue:195.0/255 alpha:1.0].CGColor;
    rightEyeLayer.cornerRadius = MJDIYEyeRadiuWidth;
    [view.layer addSublayer:rightEyeLayer];
    self.rightEye = rightEyeLayer;
    
    CAShapeLayer *halfCircleLayer = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(MJDIYCircleRadiu, MJDIYCircleRadiu) radius:MJDIYCircleRadiu startAngle:0 endAngle:M_PI clockwise:true];
    halfCircleLayer.path = circlePath.CGPath;
    halfCircleLayer.lineWidth = MJDIYCircleLineWidth;
    halfCircleLayer.fillColor = nil;
    halfCircleLayer.strokeColor = [UIColor colorWithRed:50.0/255 green:218.0/255 blue:195.0/255 alpha:1.0].CGColor;
    [view.layer addSublayer:halfCircleLayer];
    self.mouth = halfCircleLayer;
    
}

- (CGRect)eyeRectAtWithAngel:(CGFloat)angel
                 circleWidth:(CGFloat)circleWidth
                      origal:(CGPoint)orignal
              containerWidth:(CGFloat)containerWidth{
    //    CGFloat radius = (containerWidth-circleWidth)/2;
    CGFloat radius = containerWidth/2.0;
    return  CGRectMake(orignal.x-radius*(sin(angel)), orignal.y-radius*(cos(angel)), circleWidth, circleWidth);
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    
    CGFloat centerX = self.mj_w*0.5;
    CGFloat centerY = self.mj_h*0.5+(self.adaptationIphoneX?24*0.5:0);//适配iPhoneX
    
//    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
//    self.logo.center = CGPointMake(centerX, - self.logo.mj_h + 20);
    
    self.faceView.frame = CGRectMake(0, 0, MJDIYCircleRadiu*2, MJDIYCircleRadiu*2);
    self.faceView.center = CGPointMake(centerX, centerY);
    
    self.mouth.frame = CGRectMake(0, 0, MJDIYCircleRadiu*2, MJDIYCircleRadiu*2);
    
    self.leftEye.frame = [self eyeRectAtWithAngel:M_PI_4 circleWidth:MJDIYEyeRadiuWidth*2 origal:CGPointMake(MJDIYCircleRadiu-MJDIYEyeRadiuWidth, MJDIYCircleRadiu-MJDIYEyeRadiuWidth) containerWidth:MJDIYCircleRadiu*2];
    self.rightEye.frame = [self eyeRectAtWithAngel:M_PI_4*7 circleWidth:MJDIYEyeRadiuWidth*2 origal:CGPointMake(MJDIYCircleRadiu-MJDIYEyeRadiuWidth, MJDIYCircleRadiu-MJDIYEyeRadiuWidth) containerWidth:MJDIYCircleRadiu*2];
    
}

#pragma mark- 动画

- (void)layerAnimation{
    self.rightEye.hidden = YES;
    self.leftEye.hidden = YES;
    self.mouth.hidden = YES;
    self.mouth.strokeEnd = 0.f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.leftEye.hidden = NO;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rightEye.hidden = NO;
    });
    
    self.mouth.hidden = NO;
    
    CABasicAnimation * progressAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnima.duration = .4;
    progressAnima.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    progressAnima.fromValue = @0.0;
    progressAnima.toValue   = @1.0;
    progressAnima.beginTime = 0.6+CACurrentMediaTime();
    progressAnima.removedOnCompletion = NO;
    progressAnima.fillMode = kCAFillModeForwards;
    [self.mouth addAnimation:progressAnima forKey:@"MouthProgressAnima"];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.keyTimes = @[@(0),@(0.5),@(1)];
    rotateAnimation.duration = 0.8;
    rotateAnimation.repeatCount = HUGE;
    rotateAnimation.beginTime = 1+CACurrentMediaTime();
    rotateAnimation.values = @[@(0),@(M_PI),@(2*M_PI)];
    [self.mouth addAnimation:rotateAnimation forKey:@"MouthRotateAnimation"];
    
    
}

#pragma mark 监听scrollView的contentOffset改变

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态

- (void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.mouth removeAllAnimations];
            self.mouth.strokeEnd = 1.f;
            break;
        case MJRefreshStatePulling:
            
            break;
        case MJRefreshStateRefreshing:
            [self layerAnimation];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）

- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    if(pullingPercent<=0)self.mouth.strokeEnd = 0;
    else if(pullingPercent >=1)self.mouth.strokeEnd = 1;
    else self.mouth.strokeEnd = pullingPercent;
}

@end
