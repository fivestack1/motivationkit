
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"
#import "SFProgressCircle.h"
#import "HXCharts.h"

@interface CaloriesActivityViewController : UIViewController{
    NSMutableArray *arrayWorkouts;
    NSMutableArray *arrayChart;
    double todayValue;
    NSArray *themes;
    NSInteger cursor;
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
    HXBarChart *bar;
}

@property (weak, nonatomic) IBOutlet UIView *viewChart;
@property (weak, nonatomic) IBOutlet UIView *viewStatistic;
//@property (weak, nonatomic) IBOutlet UIView *viewProgress;

@property (weak, nonatomic) IBOutlet UIView *topProgressView;
@property (nonatomic) SFCircleGradientView *progressView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;

@end
