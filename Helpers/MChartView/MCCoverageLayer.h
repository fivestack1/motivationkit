
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCCoverageLayer : CALayer

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, assign) CGFloat maxRadius;

@property (nonatomic, assign) CGColorRef coverageColor;

@property (nonatomic, assign) CGFloat radius;

- (void)reloadRadiusWithAnimate:(BOOL)animate;
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
