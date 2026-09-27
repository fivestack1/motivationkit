
#import "YogaViewController.h"

@interface YogaViewController ()

@end

@implementation YogaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"YOGA & MEDITATION";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];

    arrayWorkouts = [self.dbManager loadYogaTopItem:dateString];
    [self prepareMainView];
    
    [self setTextFont];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    arrayWorkouts = [self.dbManager loadYogaTopItem:dateString];
    [self refreshMainView];
    [self onRefresh];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView setProgress:0];
    _titleLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)prepareMainView{
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/(double)[Settings integerForKey:@"goalYogaValue"])*100;
    else todayValue = 0;
    float sz = self.topProgressView.frame.size.height;
    
    _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz, sz}];
    //[_progressView setCenter:self.topProgressView.center];
    [_progressView setLineWidth:4];
    [_progressView setProgress:0];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.topProgressView.frame.size.width, (self.topProgressView.frame.size.height/5)*4}];
    _titleLabel.textColor = [UIColor systemGreenColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:44.0]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, (self.topProgressView.frame.size.height/3), self.topProgressView.frame.size.width, (self.topProgressView.frame.size.height/3)*2}];
    _subTitleLabel.textColor = [UIColor labelColor];
    [_subTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    _subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_subTitleLabel];
    
    cursor = -1;
    themes = @[@[main_color2, main_color2]];
    
}

-(void)refreshMainView{
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/(double)[Settings integerForKey:@"goalYogaValue"])*100;
    else todayValue = 0;
    self.labelGoal.text = [NSString stringWithFormat:@"Daily Goal - %ld min of Meditation or Exercises", (long)[Settings integerForKey:@"goalYogaValue"]/60];
    
    self.labelEnergies.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[2] intValue]];
    if ([arrayWorkouts[1] intValue] > 0) self.labelHappiness.text = [NSString stringWithFormat:@"%d%%", ([arrayWorkouts[1] intValue]*10)/[arrayWorkouts[3] intValue]];
    else self.labelHappiness.text = @"0%";
    self.labelSessions.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[3] intValue]];
    self.labelMinutes.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[0] intValue]/60];
    
}

/*- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}*/

- (void)onRefresh
{
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    _subTitleLabel.text = [NSString stringWithFormat:@"Today %d min of %ld Goal", [arrayWorkouts[0] intValue]/60, [Settings integerForKey:@"goalYogaValue"]/60];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf locateNewTheme];
        }
    });
}

- (void)locateNewTheme
{
    cursor++;
    if (cursor >= themes.count) {
        cursor = 0;
    }
    UIColor *startColor = [themes[cursor] firstObject];
    UIColor *endColor = [themes[cursor] lastObject];
    
    [_progressView setStartColor:startColor];
    [_progressView setEndColor:endColor];
    //[_titleLabel setTextColor:startColor];
    
    CGFloat from = 0.f;
    CGFloat to = 1.f;
    
    if (todayValue == 0) {
        to = 0.f;
    }
    else if (todayValue > 100) {
        to = 1.f;
    }
    else {
        to = todayValue/100;
        to = (round(to*100))/100.0;
    }

    [_progressView setProgress:to animateWithDuration:0.6];
    [self animateTitle:@(from) toNumber:@((int)(to*100))];
}

- (void)animateTitle:(NSNumber *)from toNumber:(NSNumber *)to
{
    fromNumber = from;
    toNumber = to;
    //_titleLabel.text = [fromNumber stringValue];
    _titleLabel.text = [NSString stringWithFormat:@"%@ %%", fromNumber];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateNumber:(CADisplayLink *)link
{
    float dt = ([link timestamp] - startTime) / 0.6;
    if (dt >= 1.0) {
        //_titleLabel.text = [toNumber stringValue];
        _titleLabel.text = [NSString stringWithFormat:@"%@ %%", toNumber];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        return;
    }
    float current = ([toNumber floatValue] - [fromNumber floatValue]) * dt + [fromNumber floatValue];
    _titleLabel.text = [NSString stringWithFormat:@"%li %%", (long)current];
}



- (IBAction)buttonMeditationAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationYogaWorkout"];
        YogaWorkoutViewController *controller = (YogaWorkoutViewController *)navController.topViewController;
        controller.isMeditation = TRUE;
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Free limit" message:@"Unlock Pro version in Settings to remove limit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)buttonExerciseAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationYogaExercises"];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Free limit" message:@"Unlock Pro version in Settings to remove limit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)setTextFont {
    self.labelGoal.font = [UIFont systemFontOfSize:14.0f];
    
    self.labelSt1.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt5.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt6.font = [UIFont systemFontOfSize:14.0f];
    
    self.labelMinutes.font = [UIFont systemFontOfSize:18.0f];
    self.labelEnergies.font = [UIFont systemFontOfSize:18.0f];
    self.labelSessions.font = [UIFont systemFontOfSize:18.0f];
    self.labelHappiness.font = [UIFont systemFontOfSize:18.0f];
}

@end
