
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GlobalState.h"
#import "PedometerService.h"

@interface StepsWorkoutViewController : UIViewController{
    AVSpeechUtterance *utterance;
    AVSpeechSynthesizer *synth;
    long workout_time;
    float workout_distance;
    long workout_floors;
    long workout_steps;
    
    float workout_distance2;
    long workout_steps2;
    long workout_floors2;
}

- (IBAction)buttonStopAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonStop;

@property (nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *labelSteps;
@property (weak, nonatomic) IBOutlet UILabel *labelFloors;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

@property (nonatomic) CMPedometerData *currentPedometer;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;

@end
