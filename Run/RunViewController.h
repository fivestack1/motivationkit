
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"
#import "SFProgressCircle.h"
#import "ZZCircleProgress.h"
#import <CoreLocation/CoreLocation.h>

@interface RunViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate> {
    NSMutableArray *arrayWorkouts;
    double todayValue;
    NSArray *themes;
    NSInteger cursor;
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
    float isMile;
}

@property (weak, nonatomic) IBOutlet UIView *viewStatistic;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;

@property (weak, nonatomic) IBOutlet UIView *topProgressView;
@property (nonatomic) SFCircleGradientView *progressView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelDistanceTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelMinutes;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;
@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelFloors;
@property (weak, nonatomic) IBOutlet UILabel *labelGoal;

@property (weak, nonatomic) IBOutlet UIButton *buttonGo;
- (IBAction)buttonGoAction:(id)sender;

@property (strong, nonatomic) ZZCircleProgress *cprogressView;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;
@property (weak, nonatomic) IBOutlet UILabel *labelSt5;
@property (weak, nonatomic) IBOutlet UILabel *labelSt6;

@end
