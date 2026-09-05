
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GlobalState.h"
#import "RunSuccessViewController.h"

@interface RunWorkoutViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    NSMutableArray *workoutArray;
    float countDis;
    NSMutableArray *run_locations;
    float isMile;
    float minspeed;
    float maxspeed;
    float aspeed;
    
    float sp1;
    float sp2;
}

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewMap;

@property (weak, nonatomic) IBOutlet UIView *viewTimer;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIView *messageReady;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
- (IBAction)buttonStartAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewExit;
@property (weak, nonatomic) IBOutlet UIButton *buttonExitYes;
@property (weak, nonatomic) IBOutlet UIButton *buttonExitNo;
- (IBAction)buttonExitYesAction:(id)sender;
- (IBAction)buttonExitNoAction:(id)sender;

- (IBAction)buttonStopAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelMinSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelMaxSpeed;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelDistanceType;

@property (nonatomic) BOOL timerPause;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat timerCount;
@property (nonatomic) int timerValue;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewRun;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;
@property (weak, nonatomic) IBOutlet UILabel *labelSt3;
@property (weak, nonatomic) IBOutlet UILabel *labelSt4;
@property (weak, nonatomic) IBOutlet UILabel *labelSt5;
@property (weak, nonatomic) IBOutlet UILabel *labelSt6;
@property (weak, nonatomic) IBOutlet UILabel *labelSt7;
@property (weak, nonatomic) IBOutlet UILabel *labelSt8;

@end
