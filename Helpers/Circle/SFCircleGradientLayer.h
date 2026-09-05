

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SFCircleGradientLayer : CALayer

@property (nonatomic) CGFloat progress;
@property (nonatomic) UIColor *startColor;
@property (nonatomic) UIColor *endColor;
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) int numSegments;
@property (nonatomic) CGFloat circleRadius;
@property (nonatomic) CGFloat circleWidth;

@end
