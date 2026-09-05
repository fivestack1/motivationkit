
#import "WorkoutViewController.h"

@interface WorkoutViewController ()

@property (assign, nonatomic) CGFloat progress;

@end

@implementation WorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonStart.layer.masksToBounds = YES;
    self.buttonStart.layer.cornerRadius = self.buttonStart.frame.size.width / 15.0;
    
    self.buttonExitYes.layer.masksToBounds = YES;
    self.buttonExitYes.layer.cornerRadius = self.buttonExitYes.frame.size.width / 15.0;
    
    self.buttonExitNo.layer.masksToBounds = YES;
    self.buttonExitNo.layer.cornerRadius = self.buttonExitNo.frame.size.width / 15.0;
    
    self.timerPause = FALSE;
    
    isPause = FALSE;
    
    currentItem = 0;
    countEx = 0;
    countCal = 0;
    typeW = @"";
    
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    NSMutableArray *json1 = [[NSMutableArray alloc] init];
    workoutArray = [[NSMutableArray alloc] init];
    json1 = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
    workoutArray = [[json1 objectAtIndex:self.currentWorkout] objectForKey:@"exercises"];
    if ([[[json1 objectAtIndex:self.currentWorkout] objectForKey:@"name"] length] > 0) {
        typeW = [NSString stringWithFormat:@"%@", [[json1 objectAtIndex:self.currentWorkout] objectForKey:@"name"]];
    }
    self.navigationItem.title = typeW;
    [self reloadExercise];
    [self exerciseProgress];
    
    [self setTextFont];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reloadExercise {
    if (currentItem == 0) self.buttonPrev.enabled = FALSE;
    else self.buttonPrev.enabled = TRUE;
    if (currentItem >= ((int)[workoutArray count] - 1)) self.buttonNext.enabled = FALSE;
    else self.buttonNext.enabled = TRUE;
    self.imageTitle.image=[UIImage imageNamed:[[workoutArray objectAtIndex:currentItem] objectForKey:@"picture"]];
    self.labelTitle.text = [NSString stringWithFormat:@"%d - %@", (currentItem+1), [[workoutArray objectAtIndex:currentItem] objectForKey:@"name"]];
    if (currentItem >= ((int)[workoutArray count] - 1)) self.labelNext.text = [NSString stringWithFormat:@"Finish"];
    else self.labelNext.text = [NSString stringWithFormat:@"Next - %@", [[workoutArray objectAtIndex:(currentItem+1)] objectForKey:@"name"]];
    self.viewExerciseProgress.frame = CGRectMake(self.viewExerciseProgress.frame.origin.x, self.viewExerciseProgress.frame.origin.y, ([UIScreen mainScreen].bounds.size.width/(int)[workoutArray count])*(currentItem+1), self.viewExerciseProgress.frame.size.height);
}

- (void)reloadRest {
    if (currentItem == 0) self.buttonPrev.enabled = FALSE;
    else self.buttonPrev.enabled = TRUE;
    if (currentItem >= ((int)[workoutArray count] - 1)) self.buttonNext.enabled = FALSE;
    else self.buttonNext.enabled = TRUE;
    //self.imageTitle.image=[UIImage imageNamed:@"pause.png"];
    self.labelTitle.text = [NSString stringWithFormat:@"REST"];
    if (currentItem >= ((int)[workoutArray count] - 1)) self.labelNext.text = [NSString stringWithFormat:@"Finish"];
    else self.labelNext.text = [NSString stringWithFormat:@"Next - %@", [[workoutArray objectAtIndex:(currentItem+1)] objectForKey:@"name"]];
    self.viewExerciseProgress.frame = CGRectMake(self.viewExerciseProgress.frame.origin.x, self.viewExerciseProgress.frame.origin.y, ([UIScreen mainScreen].bounds.size.width/(int)[workoutArray count])*(currentItem+1), self.viewExerciseProgress.frame.size.height);
}

- (void)exerciseProgress {
    
    if (isPause) self.timerCount = [Settings integerForKey:@"stepRest"];
    else self.timerCount = [Settings integerForKey:@"stepExercise"];
    
    
    //self.timerPause = TRUE;
    self.progressLabel.text = [NSString stringWithFormat:@"%ld",(long)self.timerCount];
    
    self.timerValue = self.timerCount;
    _progress = 0.000001;
    [self.progressButton setProgress:self.progress];
    //[self.progressCircle setProgress:0.000001];
    self.progressCircle.layer.masksToBounds = YES;
    self.progressCircle.layer.cornerRadius = self.progressCircle.frame.size.width / 2.0;
    [self setCounter];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void) setCounter {
    if (self.timerValue > 0) {
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        //int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
}

- (void)onTimer {
    if (!self.timerPause && (self.timerValue > 0)) {
        self.timerValue--;
        _progress += 1/self.timerCount;
        [self.progressButton setProgress:self.progress];
        
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        //int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    if (self.timerValue < 1) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.progressLabel.text = [NSString stringWithFormat:@"00:00:00"];
        
        [self.timer invalidate];
        self.timer = nil;
        [self.progressButton setProgress:0];
        //if ([[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] != nil) countCal = countCal + [[[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] intValue];
        //countEx++;
        
        if (currentItem >= ((int)[workoutArray count] - 1)) {
            if ([[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] != nil) countCal = countCal + [[[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] intValue];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationSuccess"];
            SuccessViewController *controller = (SuccessViewController *)navController.topViewController;
            //controller.exCount = countEx;
            controller.exCount = (int)[workoutArray count];
            
            controller.calCount = countCal;
            controller.wType = typeW;
            controller.wId = self.currentWorkout;
            [self presentViewController:navController animated:YES completion:nil];
        }
        else {
            if (isPause) {
                isPause = FALSE;
                currentItem++;
                self.timerPause = FALSE;
                [self reloadExercise];
                [self exerciseProgress];
            }
            else {
                
                //countEx++;
                if ([[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] != nil) countCal = countCal + [[[workoutArray objectAtIndex:currentItem] objectForKey:@"calories"] intValue];
                
                isPause =  TRUE;
                self.timerPause = FALSE;
                [self reloadRest];
                [self exerciseProgress];
            }
        }
    
     }
}

- (IBAction)buttonStartAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.messageReady.alpha = 0.0;} completion:^(BOOL finished) {
        self.messageReady.hidden = TRUE;
        self.timerPause = FALSE;
    }];
}

- (IBAction)buttonExitYesAction:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonExitNoAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.viewExit.alpha = 0.0;} completion:^(BOOL finished) {
        self.viewExit.hidden = TRUE;
        self.timerPause = FALSE;
    }];
}

- (IBAction)buttonPrevAction:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self.progressButton setProgress:0];
    currentItem--;
    self.timerPause = FALSE;
    [self reloadExercise];
    [self exerciseProgress];
}

- (IBAction)buttonNextAction:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self.progressButton setProgress:0];
    currentItem++;
    self.timerPause = FALSE;
    [self reloadExercise];
    [self exerciseProgress];
}

- (IBAction)buttonPauseAction:(id)sender {
    if (self.timerPause) {
        self.timerPause = FALSE;
        //[self.buttonPause setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState: UIControlStateNormal];
        self.labelTitle.text = [NSString stringWithFormat:@"%@", [[workoutArray objectAtIndex:currentItem] objectForKey:@"name"]];
    }
    else {
        self.timerPause = TRUE;
        //[self.buttonPause setBackgroundImage:[UIImage imageNamed:@"play.png"] forState: UIControlStateNormal];
        self.labelTitle.text = [NSString stringWithFormat:@"%@ - PAUSED", [[workoutArray objectAtIndex:currentItem] objectForKey:@"name"]];
    }
}

- (IBAction)buttonStopAction:(id)sender {
    self.timerPause = TRUE;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.viewExit.alpha = 1.0;} completion:^(BOOL finished) {
        self.viewExit.hidden = FALSE;
    }];
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.labelSt2.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.buttonStart.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    self.buttonExitNo.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    self.buttonExitYes.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    
    self.labelTitle.font = [UIFont systemFontOfSize:22.0f];
    self.progressLabel.font = [UIFont systemFontOfSize:42.0f];
    self.labelNext.font = [UIFont systemFontOfSize:17.0f];
}

@end
