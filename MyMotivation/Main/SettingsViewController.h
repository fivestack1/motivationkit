
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"

@interface SettingsViewController : UIViewController{
    NSString *dst;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UISwitch *switchNotifications;
@property (weak, nonatomic) IBOutlet UIButton *buttonReset;
@property (weak, nonatomic) IBOutlet UIButton *buttonRate;
- (IBAction)buttonResetAction:(id)sender;
- (IBAction)buttonRateAction:(id)sender;

/* Fitness */
@property (weak, nonatomic) IBOutlet UIStepper *stepWorkout;
@property (weak, nonatomic) IBOutlet UIStepper *stepRest;
@property (weak, nonatomic) IBOutlet UIStepper *stepGoal;
@property (weak, nonatomic) IBOutlet UIStepper *stepTotalGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelRest;
@property (weak, nonatomic) IBOutlet UILabel *labelGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalGoal;
- (IBAction)stepWorkoutAction:(id)sender;
- (IBAction)stepRestAction:(id)sender;
- (IBAction)stepGoalAction:(id)sender;
- (IBAction)stepTotalGoalAction:(id)sender;

/* Run */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentDistance;
- (IBAction)segmentDistanceAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *stepRunGoal;
@property (weak, nonatomic) IBOutlet UIStepper *stepRunTotalGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelRunGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelRunTotalGoal;
- (IBAction)stepRunGoalAction:(id)sender;
- (IBAction)stepRunTotalGoalAction:(id)sender;

/* Water */
@property (weak, nonatomic) IBOutlet UIStepper *stepWaterExercise;
@property (weak, nonatomic) IBOutlet UILabel *labelWaterExercise;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stepWaterUnits;
- (IBAction)stepWaterExerciseAction:(id)sender;
- (IBAction)stepWaterUnitsChanged:(id)sender;

/* Steps */
@property (weak, nonatomic) IBOutlet UIStepper *stepPedometerExercise;
@property (weak, nonatomic) IBOutlet UILabel *labelPedometerExercise;
- (IBAction)stepPedometerExerciseAction:(id)sender;

/* Yoga */
@property (weak, nonatomic) IBOutlet UISwitch *switchMusic;
@property (weak, nonatomic) IBOutlet UIStepper *stepYogaWorkout;
@property (weak, nonatomic) IBOutlet UIStepper *stepYogaMeditation;
@property (weak, nonatomic) IBOutlet UIStepper *stepYogaGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelYogaWorkout;
@property (weak, nonatomic) IBOutlet UILabel *labelYogaMeditation;
@property (weak, nonatomic) IBOutlet UILabel *labelYogaGoal;
- (IBAction)stepYogaWorkoutAction:(id)sender;
- (IBAction)stepYogaMeditationAction:(id)sender;
- (IBAction)stepYogaGoalAction:(id)sender;

/* Food calories */
@property (weak, nonatomic) IBOutlet UIStepper *stepWeightExercise;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightExercise;
- (IBAction)stepWeightExerciseAction:(id)sender;

/* Weight */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentWeightType;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightGoal;
@property (weak, nonatomic) IBOutlet UIStepper *stepWeightGoal;
- (IBAction)stepWeightGoalAction:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;
@property (weak, nonatomic) IBOutlet UILabel *labelSt5;
@property (weak, nonatomic) IBOutlet UILabel *labelSt6;
@property (weak, nonatomic) IBOutlet UILabel *labelSt7;
@property (weak, nonatomic) IBOutlet UILabel *labelSt8;
@property (weak, nonatomic) IBOutlet UILabel *labelSt9;
@property (weak, nonatomic) IBOutlet UILabel *labelSt10;
@property (weak, nonatomic) IBOutlet UILabel *labelSt11;
@property (weak, nonatomic) IBOutlet UILabel *labelSt12;
@property (weak, nonatomic) IBOutlet UILabel *labelSt13;
@property (weak, nonatomic) IBOutlet UILabel *labelSt14;
@property (weak, nonatomic) IBOutlet UILabel *labelSt15;
@property (weak, nonatomic) IBOutlet UILabel *labelSt16;
@property (weak, nonatomic) IBOutlet UILabel *labelSt17;
@property (weak, nonatomic) IBOutlet UILabel *labelSt18;
@property (weak, nonatomic) IBOutlet UILabel *labelSt19;
@property (weak, nonatomic) IBOutlet UILabel *labelSt20;
@property (weak, nonatomic) IBOutlet UILabel *labelSt21;
@property (weak, nonatomic) IBOutlet UILabel *labelSt22;
@property (weak, nonatomic) IBOutlet UILabel *labelSt23;
@property (weak, nonatomic) IBOutlet UILabel *labelSt24;
@property (weak, nonatomic) IBOutlet UILabel *labelSt25;
@property (weak, nonatomic) IBOutlet UILabel *labelSt26;
@property (weak, nonatomic) IBOutlet UILabel *labelSt27;

@end
