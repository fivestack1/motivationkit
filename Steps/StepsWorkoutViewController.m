
#import "StepsWorkoutViewController.h"

@implementation StepsWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentPedometerData:) name:@"refreshCurrentPedometerMessageEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"refreshAllDataMessageEvent" object:nil];
    self.buttonStop.layer.masksToBounds = YES;
    self.buttonStop.layer.cornerRadius = self.buttonStop.frame.size.height / 15;
    
    synth = [[AVSpeechSynthesizer alloc] init];
    
    workout_time = 0;
    workout_distance = 0;
    workout_steps = 0;
    workout_floors = 0;
    workout_distance2 = 0;
    workout_steps2 = 0;
    workout_floors2 = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self initData];
    [self setTextFont];
}


#pragma mark Data
- (void)initData {
    // Init Current Pedometer Data
    [[PedometerService sharedManager]startTracking];
    
    // Init Past Pedometer Data from the last N days
    [[PedometerService sharedManager]getPastPedometerDataSince:9];
}

#pragma mark Notifications

- (void)refreshCurrentPedometerData:(NSNotification*)notification {
    self.currentPedometer = [notification object];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->workout_steps == 0) {
            self->workout_steps = [self.currentPedometer.numberOfSteps longValue];
            self->workout_floors = ([self.currentPedometer.floorsAscended integerValue] + [self.currentPedometer.floorsDescended integerValue]);
            self->workout_distance = [self.currentPedometer.distance doubleValue];
        }
        self->workout_steps2 = [self.currentPedometer.numberOfSteps longValue];
        self->workout_floors2 = ([self.currentPedometer.floorsAscended integerValue] + [self.currentPedometer.floorsDescended integerValue]);
        self->workout_distance2 = [self.currentPedometer.distance doubleValue];
        
        [self.labelSteps setText:[NSString stringWithFormat:@"%ld STEPS", (self->workout_steps2 - self->workout_steps)]];
        [self.labelFloors setText:[NSString stringWithFormat:@"%ld", (self->workout_floors2 - self->workout_floors)]];
        [self.labelDistance setText:[NSString stringWithFormat:@"%.2fmi", ((self->workout_distance2 * 0.000621371192) - (self->workout_distance * 0.000621371192))]];
        
        
        /*[self.labelSteps setText:[NSString stringWithFormat:@"%@ STEPS", self.currentPedometer.numberOfSteps]];
        [self.labelFloors setText:[NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:([self.currentPedometer.floorsAscended floatValue] + [self.currentPedometer.floorsDescended floatValue])]]];
        [self.labelDistance setText:[NSString stringWithFormat:@"%.2fmi", [self.currentPedometer.distance doubleValue] * 0.000621371192]];
        
        self->workout_steps = [self.currentPedometer.numberOfSteps longValue];
        self->workout_floors = ([self.currentPedometer.floorsAscended integerValue] + [self.currentPedometer.floorsDescended integerValue]);
        self->workout_distance = [self.currentPedometer.distance doubleValue];*/
        
    });
}

/*- (NSString*)convertToSelectedMetric:(NSNumber*)value {
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedMetric"] isEqualToString:@"Miles"]) {
        return [NSString stringWithFormat:@"%.2f mi", [value doubleValue] * 0.000621371192];
    }
    return [NSString stringWithFormat:@"%.2f km", [value doubleValue] / 1000];
}*/

- (IBAction)buttonStopAction:(id)sender {
    [Settings setInteger:workout_time forKey:@"workoutStepsTime"];
    [Settings setDouble:(workout_distance2 - workout_distance) forKey:@"workoutStepsDistance"];
    [Settings setInteger:(workout_steps2 - workout_steps) forKey:@"workoutSteps"];
    [Settings setInteger:(workout_floors2 - workout_floors) forKey:@"workoutStepsFloors"];
    [Settings synchronize];
    if ([Settings boolForKey:@"checkVibration"]) { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); }
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    synth = nil;
}

- (void)onTimer {
    workout_time++;
    
    self.labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(workout_time/3600),((workout_time/60)%60),(workout_time%60)];
}

- (void) updateLabels{
    self.labelSteps.text = [NSString stringWithFormat:@"%ld STEPS",workout_steps];
    self.labelDistance.text = [NSString stringWithFormat:@"%.2f MI",workout_distance/1609.344];
}

-(void)setTextFont {
    self.labelSteps.font = [UIFont systemFontOfSize:45.0f];
    self.labelTime.font = [UIFont systemFontOfSize:20.0f];
    self.labelSteps.font = [UIFont systemFontOfSize:20.0f];
    self.labelFloors.font = [UIFont systemFontOfSize:20.0f];
    self.labelSt1.font = [UIFont systemFontOfSize:16.0f];
    self.labelSt1.font = [UIFont systemFontOfSize:16.0f];
    self.labelSt1.font = [UIFont systemFontOfSize:16.0f];
    self.buttonStop.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    
}

@end
