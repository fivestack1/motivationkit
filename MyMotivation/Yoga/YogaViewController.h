
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"
#import "SFProgressCircle.h"
#import "YogaWorkoutViewController.h"

@interface YogaViewController : UIViewController<UITextFieldDelegate>{
    NSMutableArray *arrayWorkouts;
    double todayValue;
    NSArray *themes;
    NSInteger cursor;
    
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
}


@property (weak, nonatomic) IBOutlet UIView *viewStart;
@property (weak, nonatomic) IBOutlet UIView *viewStatistic;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;

@property (weak, nonatomic) IBOutlet UIView *topProgressView;
@property (nonatomic) SFCircleGradientView *progressView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelEnergies;
@property (weak, nonatomic) IBOutlet UILabel *labelHappiness;
@property (weak, nonatomic) IBOutlet UILabel *labelSessions;
@property (weak, nonatomic) IBOutlet UILabel *labelMinutes;
@property (weak, nonatomic) IBOutlet UILabel *labelGoal;

- (IBAction)buttonMeditationAction:(id)sender;
- (IBAction)buttonExerciseAction:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;
@property (weak, nonatomic) IBOutlet UILabel *labelSt5;
@property (weak, nonatomic) IBOutlet UILabel *labelSt6;

@end
