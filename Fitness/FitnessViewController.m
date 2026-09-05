
#import "FitnessViewController.h"

@interface FitnessViewController ()

@end

@implementation FitnessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"FITNESS";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    self.buttonExercise.layer.masksToBounds = YES;
    self.buttonExercise.layer.cornerRadius = self.buttonExercise.frame.size.height / 15.0;
    
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    
    arrayWorkouts = [self.dbManager loadTopItem:dateString];
    [self prepareMainView];
    
    [self setTextFont];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    arrayWorkouts = [self.dbManager loadTopItem:dateString];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareMainView{
    if ([arrayWorkouts[1] doubleValue] > 0) todayValue = ([arrayWorkouts[1] doubleValue]/(double)[Settings integerForKey:@"goalValue"])*100;
    else todayValue = 0;
    float sz = self.topProgressView.frame.size.height;
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    bView.layer.cornerRadius = bView.frame.size.height/2;
    bView.layer.borderColor = light_color.CGColor;
    bView.layer.borderWidth = 4;
    bView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:bView];
    
    _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz, sz}];
    //[_progressView setCenter:self.topProgressView.center];
    [_progressView setLineWidth:4];
    [_progressView setProgress:0];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.topProgressView.frame.size.width, (self.topProgressView.frame.size.height/5)*4}];
    _titleLabel.textColor = [UIColor systemGreenColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:48.0]];
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
    if ([arrayWorkouts[1] doubleValue] > 0) todayValue = ([arrayWorkouts[1] doubleValue]/(double)[Settings integerForKey:@"goalValue"])*100;
    else todayValue = 0;
    self.labelGoal.text = [NSString stringWithFormat:@"Daily Goal - %ld kcal", (long)[Settings integerForKey:@"goalValue"]];
    
    if ([arrayWorkouts[3] intValue] > 0) self.labelWorkout.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[3] intValue]];
    else self.labelWorkout.text = @"0";
    if ([arrayWorkouts[0] intValue] > 0) self.labelExercises.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[0] intValue]];
    else self.labelExercises.text = @"0";
    if ([arrayWorkouts[1] intValue] > 0) self.labelCalories.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[1] intValue]];
    else self.labelCalories.text = @"0";
    if ([arrayWorkouts[2] intValue] > 0) self.labelMinutes.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[2] intValue]/60];
    else self.labelMinutes.text = @"0";
}

- (void)onRefresh
{
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    _subTitleLabel.text = [NSString stringWithFormat:@"%d kcal of %ld Goal", [arrayWorkouts[1] intValue], [Settings integerForKey:@"goalValue"]];
    
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

- (IBAction)buttonExerciseAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationExercises"];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationSelect"];
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

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

-(void)setTextFont {
    self.labelGoal.font = [UIFont systemFontOfSize:13.0f];
    self.buttonExercise.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    self.labelGoal.font = [UIFont systemFontOfSize:13.0f];
    
    self.labelSt1.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:14.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:14.0f];
    self.labelMinutes.font = [UIFont systemFontOfSize:22.0f];
    self.labelWorkout.font = [UIFont systemFontOfSize:22.0f];
    self.labelCalories.font = [UIFont systemFontOfSize:22.0f];
    self.labelExercises.font = [UIFont systemFontOfSize:22.0f];
}


@end
