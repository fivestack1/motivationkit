
#import "RunViewController.h"

@interface RunViewController ()

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"RUN TRACKER";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.buttonGo.layer.masksToBounds = YES;
    self.buttonGo.layer.cornerRadius = self.buttonGo.frame.size.height / 15.0;
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    
    isMile = 1;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    /*NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    
    arrayWorkouts = [self.dbManager loadRunTopItem:dateString];*/
    [self prepareMainView];
    
    [self updateProgress];
    
    [self setTextFont];
    
    [self checkLocPermission];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) isMile = 0.621371;
    else isMile = 1;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    arrayWorkouts = [self.dbManager loadRunTopItem:dateString];
    [self refreshMainView];
    
    //[NSString stringWithFormat:@"%.2f %@ of %ld Goal", ([arrayWorkouts[0] floatValue]/1000)*isMile, [Settings objectForKey:@"checkDistance"], [Settings integerForKey:@"goalRunValue"]];
    
    float tv = 0;
    if ([arrayWorkouts[3] intValue] > 0) tv = ([arrayWorkouts[0] floatValue]/([Settings integerForKey:@"goalRunValue"]*1000/isMile))*100;
    //if ([arrayWorkouts[3] intValue] > 0) tv = ((float)[Settings integerForKey:@"goalRunValue"])/(([arrayWorkouts[0] floatValue]/1000)*isMile);
    self.cprogressView.progress = tv/100;
    //[self onRefresh];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[_progressView setProgress:0];
    //_titleLabel.text = @"";
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
    /*if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/([Settings integerForKey:@"goalValue"]*1000))*100;
    else todayValue = 0;*/
    
    /*float sz = self.topProgressView.frame.size.height;
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    bView.layer.cornerRadius = bView.frame.size.height/2;
    bView.layer.borderColor = light_color.CGColor;
    bView.layer.borderWidth = 4;
    bView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:bView];
    
    _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz, sz}];
    [_progressView setLineWidth:4];
    [_progressView setProgress:0];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.topProgressView.frame.size.width, (self.topProgressView.frame.size.height/5)*4}];
    _titleLabel.textColor = green_color;
    [_titleLabel setFont:[UIFont systemFontOfSize:48.0]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, (self.topProgressView.frame.size.height/3), self.topProgressView.frame.size.width, (self.topProgressView.frame.size.height/3)*2}];
    _subTitleLabel.textColor = [UIColor lightGrayColor];
    [_subTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    _subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_subTitleLabel];
    
    cursor = -1;
     themes = @[@[main_color2, main_color2]];*/
    
    
}

-(void)refreshMainView{
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/([Settings integerForKey:@"goalRunValue"]*1000/isMile))*100;
    else todayValue = 0;
    
    self.labelGoal.text = [NSString stringWithFormat:@"of %ld %@ daily goal", (long)[Settings integerForKey:@"goalRunValue"], [Settings objectForKey:@"checkDistance"]];
    
    if ([arrayWorkouts[3] intValue] > 0) self.labelWorkout.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[3] intValue]];
    else self.labelWorkout.text = @"0";
    self.labelDistanceTitle.text = [NSString stringWithFormat:@"Distance(%@)", [Settings objectForKey:@"checkDistance"]];
    if ([arrayWorkouts[0] floatValue] > 0) self.labelDistance.text = [NSString stringWithFormat:@"%.2f", ([arrayWorkouts[0] floatValue]/1000)*isMile];
    else self.labelDistance.text = @"0";
    if ([arrayWorkouts[1] intValue] > 0) self.labelCalories.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[1] intValue]];
    else self.labelCalories.text = @"0";
    if ([arrayWorkouts[2] intValue] > 0)
        self.labelMinutes.text = [NSString stringWithFormat:@"%02d:%02d:%02d",([arrayWorkouts[2] intValue]/3600),(([arrayWorkouts[2] intValue]/60)%60),([arrayWorkouts[2] intValue]%60)];
    else self.labelMinutes.text = @"0";
    
    
    if ([arrayWorkouts[4] floatValue] > 0) self.labelMin.text = [NSString stringWithFormat:@"%.2f", [arrayWorkouts[4] floatValue]];
    else self.labelMin.text = @"0";
    if ([arrayWorkouts[5] floatValue] > 0) self.labelMax.text = [NSString stringWithFormat:@"%.2f", [arrayWorkouts[5] floatValue]];
    else self.labelMax.text = @"0";
    if ([arrayWorkouts[6] floatValue] > 0) self.labelFloors.text = [NSString stringWithFormat:@"%.2f", [arrayWorkouts[6] floatValue]];
    else self.labelFloors.text = @"0";
}

- (void)onRefresh
{
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    _subTitleLabel.text = [NSString stringWithFormat:@"%.2f %@ of %ld Goal", ([arrayWorkouts[0] floatValue]/1000)*isMile, [Settings objectForKey:@"checkDistance"], [Settings integerForKey:@"goalRunValue"]];
    
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

- (IBAction)buttonSettingsAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationRewards"];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)buttonGoAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationRunWorkout"];
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





- (void)updateProgress {
    //float ht = UIScreen.mainScreen.bounds.size.height;
    float ht = self.viewProgress.bounds.size.height;
    if (ht > UIScreen.mainScreen.bounds.size.width*0.85) ht = UIScreen.mainScreen.bounds.size.width*0.85;
    //self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-(ht-20)/2, ht/2-(ht-20)/2, ht-20, ht-20) pathBackColor:[UIColor lightGrayColor] pathFillColor:[UIColor redColor] startAngle:0 strokeWidth:10];
    self.cprogressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-ht/2, 10, ht, ht) pathBackColor:light_color pathFillColor:main_color2 startAngle:0 strokeWidth:10];
    self.cprogressView.startAngle = 125;
    self.cprogressView.reduceAngle = 75;
    self.cprogressView.strokeWidth = 15;
    //self.cprogressView.pointImage.image = [UIImage imageNamed:@"test"];
    self.cprogressView.duration = 1.5;
    self.cprogressView.showPoint = YES;
    self.cprogressView.showSubtitle = YES;
    self.cprogressView.showProgressText = NO;
    self.cprogressView.increaseFromLast = NO;
    self.cprogressView.showPercent = NO;
    //self.progressView.progressLabel......//progressLabel集成自UILabel。属性随意设置
    [self.viewProgress addSubview:self.cprogressView];
    
    
}


-(void)setTextFont {
    self.labelDistanceTitle.font = [UIFont systemFontOfSize:20.0f];
    self.labelDistance.font = [UIFont systemFontOfSize:85.0f];
    self.labelGoal.font = [UIFont systemFontOfSize:20.0f];
    self.buttonGo.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    
    self.labelSt1.font = [UIFont systemFontOfSize:15.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:15.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:15.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:15.0f];
    self.labelSt5.font = [UIFont systemFontOfSize:15.0f];
    self.labelSt6.font = [UIFont systemFontOfSize:15.0f];
    self.labelMinutes.font = [UIFont systemFontOfSize:20.0f];
    self.labelWorkout.font = [UIFont systemFontOfSize:20.0f];
    self.labelCalories.font = [UIFont systemFontOfSize:20.0f];
    self.labelMax.font = [UIFont systemFontOfSize:20.0f];
    self.labelMin.font = [UIFont systemFontOfSize:20.0f];
    self.labelFloors.font = [UIFont systemFontOfSize:20.0f];
}


- (void) checkLocPermission {
    BOOL showAlertSetting = false;
    BOOL showInitLocation = false;
    //islocenabled = false;
    if ([CLLocationManager locationServicesEnabled]) {
        
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied:
                showAlertSetting = true;
                NSLog(@"kCLAuthorizationStatusDenied");
                break;
            case kCLAuthorizationStatusRestricted:
                showAlertSetting = true;
                NSLog(@"kCLAuthorizationStatusRestricted");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                //showInitLocation = true;
                //islocenabled = true;
                NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                showAlertSetting = true;
                NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
                break;
            case kCLAuthorizationStatusNotDetermined:
                showInitLocation = true;
                NSLog(@"kCLAuthorizationStatusNotDetermined");
                break;
            default:
                break;
        }
    } else {
        showAlertSetting = true;
        NSLog(@"locationServicesDisabled");
    }
    
    if (showAlertSetting) {
        NSString *tit = @"Background location is not enabled";
        NSString *mess = @"To use background location, you must enable 'Always' in the Location Service Settings";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tit message:mess preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (showInitLocation){
        self.locationManager = [[CLLocationManager alloc] init];
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    //if (islocenabled) { return true; }
    //else { return false; }
}


@end
