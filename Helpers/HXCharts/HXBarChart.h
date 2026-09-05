
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrientationType) {
    OrientationHorizontal = 0,
    OrientationVertical = 1,
};

@interface HXBarChart : UIView


- (instancetype)initWithFrame:(CGRect)frame withMarkLabelCount:(int)markLabelCount withOrientationType:(OrientationType)type;


@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *valueArray;

@property (nonatomic, strong) NSArray *colorArray;

@property (nonatomic, strong) NSArray *locations;

@property (nonatomic, strong) NSArray *singleColorArray;

@property (nonatomic, weak) UIColor *markTextColor;
@property (nonatomic, weak) UIFont *markTextFont;

@property (nonatomic, weak) UIColor *backgroundLineColor;
@end
