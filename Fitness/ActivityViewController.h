
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"
#import "SFProgressCircle.h"
//#import "HXCharts.h"
#import "MCBarChartView.h"

@interface ActivityViewController : UIViewController<MCBarChartViewDataSource, MCBarChartViewDelegate>{
    NSMutableArray *arrayWorkouts;
    NSMutableArray *arrayChart;
    double todayValue;
    NSArray *themes;
    NSInteger cursor;
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
    //HXBarChart *bar;
    int max;
}

@property (weak, nonatomic) IBOutlet UIView *viewChart;
@property (weak, nonatomic) IBOutlet UIView *viewStatistic;
@property (weak, nonatomic) IBOutlet UIView *topProgressView;
@property (nonatomic) SFCircleGradientView *progressView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelExercises;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelMinutes;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) MCBarChartView *barChartView;

@property (nonatomic, strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;

@end
