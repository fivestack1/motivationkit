
#import "CaloriesViewController.h"

@implementation CaloriesViewController {
    NSArray *recipes;
    double todayValue;
    NSArray *themes;
    NSInteger cursor;
    
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"FOOD CALORIES";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    [self refreshMainView];
    
    [self setTextFont];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)refreshMainView{
    
    //_progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz, sz}];
    _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){self.topProgressView.frame.size.width/2-150, self.topProgressView.frame.size.height/2-150, 300, 300}];
    //[_progressView setCenter:self.topProgressView.center];
    [_progressView setLineWidth:4];
    [_progressView setProgress:0];
    //_progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.topProgressView.frame.size.width, self.topProgressView.frame.size.height}];
    //[_titleLabel setCenter:self.view.center];
    _titleLabel.textColor = [UIColor systemGreenColor];
    [_titleLabel setFont:[UIFont systemFontOfSize:48.0]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_titleLabel];
    
    cursor = -1;
    themes = @[@[main_color2, main_color2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    todayValue = [self.dbManager loadCaloriesTopItems];
    [self onRefresh];
    [self updateLabels];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onRefresh {
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    
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
    else if (todayValue > [Settings doubleForKey:@"stepCaloriesGoal"]) {
        to = 1.f;
    }
    else {
        to = todayValue/[Settings doubleForKey:@"stepCaloriesGoal"];
    }
    
    int tonum = (int)(to * 100);
    
    [_progressView setProgress:to animateWithDuration:0.6];
    [self animateTitle:@(from) toNumber:@(tonum)];
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



- (void)updateLabels {
    
    self.labelCurrent.text = [NSString stringWithFormat:@"%2.f of %2.f Kcal", todayValue , [Settings doubleForKey:@"stepCaloriesGoal"]];
    
    if (todayValue == 0) {
        [self.labelPercent setFrame:CGRectMake(self.labelPercent.frame.origin.x, self.labelPercent.frame.origin.y, 0, self.labelPercent.frame.size.height)];
    }
    else if (todayValue > [Settings doubleForKey:@"stepCaloriesGoal"]) {
        [self.labelPercent setFrame:CGRectMake(self.labelPercent.frame.origin.x, self.labelPercent.frame.origin.y, self.viewPercent.frame.size.width, self.labelPercent.frame.size.height)];
    }
    else {
        CGFloat wdth = (([[UIScreen mainScreen] bounds].size.width - 45)/100)*((todayValue/[Settings doubleForKey:@"stepCaloriesGoal"])*100);
        [self.labelPercent setFrame:CGRectMake(self.labelPercent.frame.origin.x, self.labelPercent.frame.origin.y, wdth, self.labelPercent.frame.size.height)];
    }
    
    //int wcurr = (100*todayValue)/[Settings doubleForKey:@"stepCaloriesGoal"];
    
}

- (IBAction)buttonMinusAction:(id)sender {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    if ([self.dbManager checkCaloriesDataItems:[components day] onmonth:[components month] onyear:[components year]]) {
        [self.dbManager deleteCaloriesDataItem1];
        todayValue = 0;
        [self.dbManager loadCaloriesTopItems];
        [self updateLabels];
    }
}

- (IBAction)buttonPlusAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationNewCalories"];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Free limit" message:@"Unlock Pro version in Settings in Store section to remove limit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)setTextFont {
    self.labelCurrent.font = [UIFont systemFontOfSize:28.0f];
    self.labelSt1.font = [UIFont systemFontOfSize:18.0f];
}


@end
