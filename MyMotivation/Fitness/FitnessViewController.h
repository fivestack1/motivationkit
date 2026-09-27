
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"
#import "SFProgressCircle.h"

@interface FitnessViewController : UIViewController<UITextFieldDelegate> {
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

@property (weak, nonatomic) IBOutlet UILabel *labelWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelExercises;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelMinutes;
@property (weak, nonatomic) IBOutlet UILabel *labelGoal;

@property (weak, nonatomic) IBOutlet UIButton *buttonExercise;
- (IBAction)buttonExerciseAction:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;

@end
