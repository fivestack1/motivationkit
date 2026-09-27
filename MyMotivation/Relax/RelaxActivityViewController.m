
#import "RelaxActivityViewController.h"
#import "GlobalState.h"

@interface RelaxActivityViewController ()

@end

@implementation RelaxActivityViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*self.navigationController.navigationBar.barTintColor = blue_color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};*/
    
    self.navigationController.navigationBar.topItem.title = @"ACTIVITY";
    
    /*if (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXSMAX) {
        self.viewStatistic.frame = CGRectMake(0, self.viewStatistic.frame.origin.y+24, self.viewStatistic.frame.size.width, self.viewStatistic.frame.size.height);
        self.viewChart.frame = CGRectMake(self.viewChart.frame.origin.x, self.viewChart.frame.origin.y+24, self.viewChart.frame.size.width, self.viewChart.frame.size.height);
    }*/
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    
    arrayWorkouts = [self.dbManager loadRelaxTopItem:@""];
    [self prepareMainView];
    
    arrayChart = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    arrayChart = [self.dbManager loadRelaxLogItems:@""];
    [self showBarChart];
    
    arrayWorkouts = [self.dbManager loadRelaxTopItem:@""];
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
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/(double)[Settings integerForKey:@"stepRelaxGoal"])*100;
    else todayValue = 0;
    float sz = self.topProgressView.frame.size.height;
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    bView.layer.cornerRadius = bView.frame.size.height/2;
    bView.layer.borderColor = light_color.CGColor;
    bView.layer.borderWidth = 4;
    bView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:bView];
    /*if (IS_IPAD) {
        self.topProgressView.frame = CGRectMake(self.topProgressView.frame.origin.x, (self.viewProgress.frame.size.height/2) - (self.topProgressView.frame.size.height/2), self.topProgressView.frame.size.width, self.topProgressView.frame.size.height);
    }*/
    
    _progressView = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz, sz}];
    //[_progressView setCenter:self.topProgressView.center];
    [_progressView setLineWidth:4];
    [_progressView setProgress:0];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_progressView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, (self.topProgressView.frame.size.height/2)-60, self.topProgressView.frame.size.width, 80}];
    _titleLabel.textColor = [UIColor labelColor];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:50.0]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    //_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, self.topProgressView.frame.size.height-100, self.topProgressView.frame.size.width, 50}];
    _subTitleLabel.textColor = [UIColor whiteColor];
    [_subTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [_subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    //_subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView addSubview:_subTitleLabel];
    
    cursor = -1;
    themes = @[@[main_color1, main_color1]];
    
}

-(void)refreshMainView{
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/(double)[Settings integerForKey:@"stepRelaxGoal"])*100;
    else todayValue = 0;
    
    if ([arrayWorkouts[1] intValue] > 0) self.labelWorkout.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[1] intValue]];
    else self.labelWorkout.text = @"0";
    if ([arrayWorkouts[0] intValue] > 0) {
        int seconds = fmod(fmod(fmod([arrayWorkouts[0] intValue], 86400), 3600), 60);
        int minutes = (fmod(fmod([arrayWorkouts[0] intValue], 86400), 3600) / 60);
        int hours = fmod([arrayWorkouts[0] intValue], 86400) / 3600;
        self.labelTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
    //self.labelTime.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[0] intValue]];
    else self.labelTime.text = @"00:00:00";
}

- (void)onRefresh
{
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    
    if ([arrayWorkouts[0] intValue] > 0) {
        int goal = (fmod(fmod((int)[Settings integerForKey:@"stepRelaxGoal"], 86400), 3600) / 60);
        _subTitleLabel.text = [NSString stringWithFormat:@"%d total time", goal];
    }
    //else _subTitleLabel.text = [NSString stringWithFormat:@"%d total time", [arrayWorkouts[0] intValue]];
    
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
    _titleLabel.text = [NSString stringWithFormat:@"%@%%", fromNumber];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateNumber:(CADisplayLink *)link
{
    float dt = ([link timestamp] - startTime) / 0.6;
    if (dt >= 1.0) {
        //_titleLabel.text = [toNumber stringValue];
        _titleLabel.text = [NSString stringWithFormat:@"%@%%", toNumber];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        return;
    }
    float current = ([toNumber floatValue] - [fromNumber floatValue]) * dt + [fromNumber floatValue];
    _titleLabel.text = [NSString stringWithFormat:@"%li%%", (long)current];
}


-(void)showBarChart {
    NSArray *color1 = @[[self colorWithHexString:@"#5677fc" alpha:1.0],[self colorWithHexString:@"#5677fc" alpha:1.0]];
    NSArray *color2 = @[[self colorWithHexString:@"#dd191d" alpha:1.0],[self colorWithHexString:@"#dd191d" alpha:1.0]];
    NSArray *color3 = @[[self colorWithHexString:@"#8e24aa" alpha:1.0],[self colorWithHexString:@"#8e24aa" alpha:1.0]];
    NSArray *color4 = @[[self colorWithHexString:@"#3f51b5" alpha:1.0],[self colorWithHexString:@"#3f51b5" alpha:1.0]];
    NSArray *color5 = @[[self colorWithHexString:@"#d81b60" alpha:1.0],[self colorWithHexString:@"#d81b60" alpha:1.0]];
    NSArray *color6 = @[[self colorWithHexString:@"#2baf2b" alpha:1.0],[self colorWithHexString:@"#2baf2b" alpha:1.0]];
    NSArray *color7 = @[[self colorWithHexString:@"#b0bec5" alpha:1.0],[self colorWithHexString:@"#b0bec5" alpha:1.0]];
    //NSArray *color8 = @[[self colorWithHexString:@"#f57c00" alpha:0.6],[self colorWithHexString:@"#f57c00" alpha:0.6]];
    
    NSArray *color8 = @[[self colorWithHexString:@"#f07167" alpha:1.0],[self colorWithHexString:@"#f07167" alpha:1.0]];
    
    bar = [[HXBarChart alloc] initWithFrame:CGRectMake(0, 30, self.viewChart.frame.size.width-20, self.viewChart.frame.size.height-30) withMarkLabelCount:8 withOrientationType:OrientationVertical];
    
    NSString *nm1 = @"";
    NSString *nm2 = @"";
    NSString *nm3 = @"";
    NSString *nm4 = @"";
    NSString *nm5 = @"";
    NSString *nm6 = @"";
    NSString *nm7 = @"";
    NSString *vl1 = @"";
    NSString *vl2 = @"";
    NSString *vl3 = @"";
    NSString *vl4 = @"";
    NSString *vl5 = @"";
    NSString *vl6 = @"";
    NSString *vl7 = @"";
    
    if ([arrayChart count] > 0) { /*nm1 = arrayChart[0][3];*/ vl1 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[0][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 1) { /*nm2 = arrayChart[1][3];*/ vl2 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[1][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 2) { /*nm3 = arrayChart[2][3];*/ vl3 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[2][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 3) { /*nm4 = arrayChart[3][3];*/ vl4 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[3][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 4) { /*nm5 = arrayChart[4][3];*/ vl5 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[4][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 5) { /*nm6 = arrayChart[5][3];*/ vl6 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[5][2] intValue], 86400), 3600) / 60)]; }
    if ([arrayChart count] > 6) { /*nm7 = arrayChart[6][3];*/ vl7 = [NSString stringWithFormat:@"%d", (int)(fmod(fmod([arrayChart[6][2] intValue], 86400), 3600) / 60)]; }
    
    bar.titleArray = @[nm1, nm2, nm3, nm4, nm5, nm6, nm7];
    bar.valueArray = @[vl1, vl2, vl3, vl4, vl5, vl6, vl7];
    bar.colorArray = @[color8,color8,color8,color8,color8,color8,color8];
    //bar.locations = @[@0.15,@.85];
    bar.backgroundLineColor = [self colorWithHexString:@"#e1e1e1" alpha:1];
    
    [self.viewChart addSubview:bar];
    
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


@end
