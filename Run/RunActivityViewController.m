
#import "RunActivityViewController.h"

@interface RunActivityViewController ()

@end

@implementation RunActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isMile = 1;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    
    /*if (IS_IPHONEX) {
        self.viewChart.frame = CGRectMake(0, self.viewChart.frame.origin.y+24, self.viewChart.frame.size.width, self.viewChart.frame.size.height);
        self.viewStatistic.frame = CGRectMake(self.viewStatistic.frame.origin.x, self.viewStatistic.frame.origin.y+24, self.viewStatistic.frame.size.width, self.viewStatistic.frame.size.height);
        
        float tpsize = [[UIScreen mainScreen] bounds].size.width-80;
        self.topProgressView.frame = CGRectMake((self.viewProgress.frame.size.width/2)-(tpsize/2), (self.viewProgress.frame.size.height/2)-(tpsize/2), tpsize, tpsize);
    }*/
    
    //arrayWorkouts = [self.dbManager loadRunTopItem:@""];
    
    [self prepareMainView];
    
    arrayChart = [[NSMutableArray alloc] init];
    
    [self setTextFont];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) isMile = 0.621371;
    else isMile = 1;
    
    arrayChart = [self.dbManager loadRunAllItems:@""];
    [_barChartView removeFromSuperview];
    [self showBarChart];
    
    arrayWorkouts = [self.dbManager loadRunTopItem:@""];
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
    
    float sz = self.topProgressView.frame.size.height;
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
    _titleLabel.textColor = [UIColor labelColor];
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
    if ([arrayWorkouts[0] doubleValue] > 0) todayValue = ([arrayWorkouts[0] doubleValue]/([Settings integerForKey:@"goalRunTotalValue"]*1000/isMile))*100;
    else todayValue = 0;
    
    if ([arrayWorkouts[3] intValue] > 0) self.labelWorkout.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[3] intValue]];
    else self.labelWorkout.text = @"0";
    if ([arrayWorkouts[0] floatValue] > 0) self.labelDistance.text = [NSString stringWithFormat:@"%.2f%@", ([arrayWorkouts[0] floatValue]/1000)*isMile, [Settings objectForKey:@"checkDistance"]];
    else self.labelDistance.text = @"0";
    if ([arrayWorkouts[1] intValue] > 0) self.labelCalories.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[1] intValue]];
    else self.labelCalories.text = @"0";
    if ([arrayWorkouts[2] intValue] > 0)
        //self.labelMinutes.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[2] intValue]/60];
        self.labelMinutes.text = [NSString stringWithFormat:@"%02d:%02d:%02d",([arrayWorkouts[2] intValue]/3600),(([arrayWorkouts[2] intValue]/60)%60),([arrayWorkouts[2] intValue]%60)];
    else self.labelMinutes.text = @"0";
}

- (void)onRefresh
{
    [_progressView setProgress:0];
    _titleLabel.text = @"";
    _subTitleLabel.text = [NSString stringWithFormat:@"%.2f %@ of %ld Goal", ([arrayWorkouts[0] floatValue]/1000)*isMile, [Settings objectForKey:@"checkDistance"], [Settings integerForKey:@"goalRunTotalValue"]];
    
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


-(void)showBarChart {
    /*NSArray *color1 = @[[self colorWithHexString:@"#5677fc" alpha:0.6],[self colorWithHexString:@"#5677fc" alpha:0.8]];
    NSArray *color2 = @[[self colorWithHexString:@"#dd191d" alpha:0.6],[self colorWithHexString:@"#dd191d" alpha:0.8]];
    NSArray *color3 = @[[self colorWithHexString:@"#8e24aa" alpha:0.6],[self colorWithHexString:@"#8e24aa" alpha:0.8]];
    NSArray *color4 = @[[self colorWithHexString:@"#3f51b5" alpha:0.6],[self colorWithHexString:@"#3f51b5" alpha:0.8]];
    NSArray *color5 = @[[self colorWithHexString:@"#d81b60" alpha:0.6],[self colorWithHexString:@"#d81b60" alpha:0.8]];
    NSArray *color6 = @[[self colorWithHexString:@"#2baf2b" alpha:0.6],[self colorWithHexString:@"#2baf2b" alpha:0.8]];
    NSArray *color7 = @[[self colorWithHexString:@"#b0bec5" alpha:0.6],[self colorWithHexString:@"#b0bec5" alpha:0.8]];
    
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
    if ([arrayChart count] > 0) { vl1 = [NSString stringWithFormat:@"%d", [arrayChart[0][3] intValue]]; }
    if ([arrayChart count] > 1) { vl2 = [NSString stringWithFormat:@"%d", [arrayChart[1][3] intValue]]; }
    if ([arrayChart count] > 2) { vl3 = [NSString stringWithFormat:@"%d", [arrayChart[2][3] intValue]]; }
    if ([arrayChart count] > 3) { vl4 = [NSString stringWithFormat:@"%d", [arrayChart[3][3] intValue]]; }
    if ([arrayChart count] > 4) { vl5 = [NSString stringWithFormat:@"%d", [arrayChart[4][3] intValue]]; }
    if ([arrayChart count] > 5) { vl6 = [NSString stringWithFormat:@"%d", [arrayChart[5][3] intValue]]; }
    if ([arrayChart count] > 6) { vl7 = [NSString stringWithFormat:@"%d", [arrayChart[6][3] intValue]]; }
    
    bar.titleArray = @[nm1, nm2, nm3, nm4, nm5, nm6, nm7];
    bar.valueArray = @[vl1, vl2, vl3, vl4, vl5, vl6, vl7];
    bar.colorArray = @[color1,color2,color3,color4,color5,color6,color7];
    //bar.locations = @[@0.15,@.85];
    bar.backgroundLineColor = [self colorWithHexString:@"#e1e1e1" alpha:1];
    
    [self.viewChart addSubview:bar];*/
    
    
    
    
    NSMutableArray *tit = [[NSMutableArray alloc] init];
    NSMutableArray *vl = [[NSMutableArray alloc] init];
    max = 0;
    for (int i = 0; i < [arrayChart count]; i++) {
        NSString *dt = [NSString stringWithFormat:@"%@", [[arrayChart objectAtIndex:i] objectAtIndex:1]];
        int v = [[[arrayChart objectAtIndex:i] objectAtIndex:3] intValue];
        if (v >= max) max = v;
        [tit addObject:[dt substringToIndex:10]];
        [vl addObject:[NSNumber numberWithInteger:v]];
    }
    _titles = [tit copy];
    
    _dataSource = [vl copy];
    
    
    //_titles = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物"];
    //_dataSource = [NSMutableArray arrayWithArray:@[@120, @115.0, @50, @138, @110, @100]];

    _barChartView = [[MCBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.viewChart.frame.size.width, self.viewChart.frame.size.height)];
    _barChartView.dataSource = self;
    _barChartView.delegate = self;
    _barChartView.maxValue = [NSNumber numberWithInt:(max+30)];
    //_barChartView.unitOfYAxis = @"分";
    _barChartView.colorOfXAxis = [UIColor lightGrayColor];
    _barChartView.colorOfXText = [UIColor lightGrayColor];
    _barChartView.colorOfYAxis = [UIColor lightGrayColor];
    _barChartView.colorOfYText = [UIColor lightGrayColor];
    
    [self.viewChart addSubview:_barChartView];
    
    
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





- (NSInteger)numberOfSectionsInBarChartView:(MCBarChartView *)barChartView {
    return [_dataSource count];
}

- (NSInteger)barChartView:(MCBarChartView *)barChartView numberOfBarsInSection:(NSInteger)section {
    return 1;
}

- (id)barChartView:(MCBarChartView *)barChartView valueOfBarInSection:(NSInteger)section index:(NSInteger)index {
    return _dataSource[section];
}

- (UIColor *)barChartView:(MCBarChartView *)barChartView colorOfBarInSection:(NSInteger)section index:(NSInteger)index {
    return main_color2;
}

- (NSString *)barChartView:(MCBarChartView *)barChartView titleOfBarInSection:(NSInteger)section {
    return _titles[section];
}

- (NSString *)barChartView:(MCBarChartView *)barChartView informationOfBarInSection:(NSInteger)section index:(NSInteger)index {
    return [NSString stringWithFormat:@"%@", _dataSource[section]];
}

- (CGFloat)barWidthInBarChartView:(MCBarChartView *)barChartView {
    return 26;
}

- (CGFloat)paddingForSectionInBarChartView:(MCBarChartView *)barChartView {
    return 24;
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:17.0f];
    self.labelMinutes.font = [UIFont systemFontOfSize:20.0f];
    self.labelWorkout.font = [UIFont systemFontOfSize:20.0f];
    self.labelCalories.font = [UIFont systemFontOfSize:20.0f];
    self.labelDistance.font = [UIFont systemFontOfSize:20.0f];
}

@end
