
#import "YogaWorkoutViewController.h"

@interface YogaWorkoutViewController ()

@property (assign, nonatomic) CGFloat progress;

@end

@implementation YogaWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([Settings boolForKey:@"checkMusic"]) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"yogafile" ofType: @"mp3"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        myAudioPlayer.numberOfLoops = -1; //infinite loop
        [myAudioPlayer play];
    }
    
    self.buttonStart.layer.masksToBounds = YES;
    self.buttonStart.layer.cornerRadius = self.buttonStart.frame.size.width / 15.0;
    
    self.buttonExitYes.layer.masksToBounds = YES;
    self.buttonExitYes.layer.cornerRadius = self.buttonExitYes.frame.size.width / 15.0;
    
    self.buttonExitNo.layer.masksToBounds = YES;
    self.buttonExitNo.layer.cornerRadius = self.buttonExitNo.frame.size.width / 15.0;
    
    self.timerPause = FALSE;
    
    if (self.isMeditation) {
        self.labelTitle.text = [NSString stringWithFormat:@"Meditation"];
        self.labelGoal.text = [NSString stringWithFormat:@"of %ld min Meditation Time", (long)([Settings integerForKey:@"stepYogaMeditation"]/60)];
    }
    else {
        self.labelGoal.text = [NSString stringWithFormat:@"of %ld min Exercise Time", (long)([Settings integerForKey:@"stepYogaExercise"]/60)];
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"ydata" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
        NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
        json = [[NSMutableArray alloc] init];
        json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
        self.imageTitle.image=[UIImage imageNamed:[[json objectAtIndex:self.currentItem] objectForKey:@"picture"]];
        self.labelTitle.text = [[json objectAtIndex:self.currentItem] objectForKey:@"name"];
    }
    
    [self exerciseProgress];
    
    [self setTextFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [myAudioPlayer stop];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)exerciseProgress {
    if (self.isMeditation) self.timerCount = [Settings integerForKey:@"stepYogaMeditation"];
    else self.timerCount = [Settings integerForKey:@"stepYogaExercise"];
    
    self.timerPause = TRUE;
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

- (void)onTimer {
    if (!self.timerPause && (self.timerValue > 0)) {
        self.timerValue--;
        _progress += 1/self.timerCount;
        [self.progressButton setProgress:self.progress];
        
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        //self.progressLabel.text = [NSString stringWithFormat:@"%ld",(long)self.timerValue];
    }
    if (self.timerValue < 1) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.progressLabel.text = [NSString stringWithFormat:@"00:00:00"];
        [self.timer invalidate];
        self.timer = nil;
        [self.progressButton setProgress:0];
            
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationYogaSuccess"];
        YogaSuccessViewController *controller = (YogaSuccessViewController *)navController.topViewController;
        controller.isMedt = self.isMeditation;
        if (self.isMeditation) controller.exCount = 0;
        else controller.exCount = self.currentItem;
        [self presentViewController:navController animated:YES completion:nil];
    
     }
}

-(void) setCounter {
    if (self.timerValue > 0) {
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
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

- (IBAction)buttonPauseAction:(id)sender {
    if (self.timerPause) {
        self.timerPause = FALSE;
        //[self.buttonPause setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState: UIControlStateNormal];
        if (self.isMeditation) self.labelTitle.text = [NSString stringWithFormat:@"Meditation"];
        else self.labelTitle.text = [NSString stringWithFormat:@"%@", [[json objectAtIndex:self.currentItem] objectForKey:@"name"]];
    }
    else {
        self.timerPause = TRUE;
        //[self.buttonPause setBackgroundImage:[UIImage imageNamed:@"play.png"] forState: UIControlStateNormal];
        if (self.isMeditation) self.labelTitle.text = [NSString stringWithFormat:@"Meditation - PAUSED"];
        else self.labelTitle.text = [NSString stringWithFormat:@"%@ - PAUSED", [[json objectAtIndex:self.currentItem] objectForKey:@"name"]];
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
    self.labelGoal.font = [UIFont systemFontOfSize:18.0f];
}

@end
