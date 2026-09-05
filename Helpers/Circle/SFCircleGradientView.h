

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SFCircleGradientView : UIView

@property (nonatomic) IBInspectable CGFloat progress;
@property (nonatomic) IBInspectable CGFloat lineWidth;
@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic) IBInspectable CGFloat startAngle;
@property (nonatomic) IBInspectable CGFloat endAngle;

- (void)setProgress:(CGFloat)progress animateWithDuration:(NSTimeInterval)duration;
- (void)abortAnimation;

@end
