
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GlobalState.h"
#import "UIView+LSPieProgress.h"
#import "SuccessViewController.h"

@interface WorkoutViewController : UIViewController{
    NSMutableArray *workoutArray;
    int currentItem;
    int countEx;
    int countCal;
    NSString *typeW;
    BOOL isPause;
}

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIView *viewTimer;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIButton *progressCircle;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIView *viewExerciseProgress;

@property (weak, nonatomic) IBOutlet UIView *messageReady;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
- (IBAction)buttonStartAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewExit;
@property (weak, nonatomic) IBOutlet UIButton *buttonExitYes;
@property (weak, nonatomic) IBOutlet UIButton *buttonExitNo;
- (IBAction)buttonExitYesAction:(id)sender;
- (IBAction)buttonExitNoAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonPause;
@property (weak, nonatomic) IBOutlet UIButton *buttonPrev;
@property (weak, nonatomic) IBOutlet UIButton *buttonNext;

- (IBAction)buttonPrevAction:(id)sender;
- (IBAction)buttonNextAction:(id)sender;
- (IBAction)buttonPauseAction:(id)sender;
- (IBAction)buttonStopAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelNext;

@property (nonatomic) BOOL timerPause;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat timerCount;
@property (nonatomic) int timerValue;
@property (nonatomic) int currentWorkout;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;

@end
