
#import <UIKit/UIKit.h>

@interface ZZCountingLabel : UILabel

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL showPercent;

- (void)countingFrom:(CGFloat)fromValue to:(CGFloat)toValue;
- (void)countingFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(CGFloat)duration;

@end
