
#import "HomeViewController.h"

@interface HomeViewController ()
//@property(nonatomic, strong) DGExpandMenuButton *ExpandMenuButton;

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) MCLineChartView *lineChartView;

@property (nonatomic, strong) NSArray *dataSource1;
@property (nonatomic, strong) MCCircleChartView *circleChartView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeFLaunch];
    
    dateString = [self getDateToday];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"AccentColor"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = [NSString stringWithFormat:@"SUMMARY %@", dateString];
    
    if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
            [navBarAppearance configureWithOpaqueBackground];
            navBarAppearance.backgroundColor = [UIColor colorNamed:@"AccentColor"];
            navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            [UINavigationBar appearance].standardAppearance = navBarAppearance;
            [UINavigationBar appearance].scrollEdgeAppearance = navBarAppearance;
            self.navigationController.navigationBar.standardAppearance = navBarAppearance;
            self.navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance;
        
        }
    
    [self setTextFont];
    
    self.buttonStart.layer.masksToBounds = YES;
    self.buttonStart.layer.cornerRadius = self.buttonStart.frame.size.height / 10.0;
    
    if (![Settings boolForKey:@"isSetup"]) {
        self.buttonMenu.enabled = FALSE;
        self.buttonDateDialog.enabled = FALSE;
        self.messageSetup.hidden = FALSE;
        [self.inputName setDelegate:self];
        [self.inputHeight setDelegate:self];
        [self.inputWeight setDelegate:self];
    }
    
    self.viewMain.frame = CGRectMake(0, 0, self.scrollMain.frame.size.width, 820);
    [self.scrollMain setScrollEnabled:YES];
    [self.scrollMain setContentSize:CGSizeMake(self.scrollMain.frame.size.width, 820)];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    
    
    
    
    
    
    /*NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    [self.dbManager updateRunItem:[dateFormat stringFromDate:today] onwdistance:5200 onwcalories:500 onwtime:2400 onwmin:5 onwmax:9 onwavg:8];
    [self.dbManager saveStepsDataItem:[dateFormat stringFromDate:today] ontime:[Settings integerForKey:@"workoutStepsTime"] ondistance:1800 onsteps:5600 onfloors:3];
    [self.dbManager updateItem:1 onwtype:1 onwname:@"Basic" onwdate:[dateFormat stringFromDate:today] onwexercises:10 onwcalories:566 onwtime:(10*[Settings integerForKey:@"stepExercise"])];
    [self.dbManager saveWaterDataItem:10];
    [self.dbManager updateYogaItem:0 onwname:@"Meditation" onwdate:[dateFormat stringFromDate:today] onwseconds:[Settings integerForKey:@"stepYogaMeditation"] onwhappy:4 onwenergies:70 onwid:0 onwtitle:@"Meditation" onwtime:[[dateFormat stringFromDate:today] substringWithRange:NSMakeRange(11, 7)]];
    [self.dbManager saveCaloriesDataItem:920 onval:@"Pizza"];
    [self.dbManager saveWeightDataItem:67];*/
    
    
    
    
    
    totalValue1 = [self.dbManager loadRunDistance:dateString];
    totalValue2 = [self.dbManager loadFitnessCalories:dateString];
    totalValue3 = [self.dbManager loadStepsCount:dateString];
    totalValue4 = [self.dbManager loadWaterCount:dateString];
    totalValue5 = [self.dbManager loadYogaTime:dateString];
    totalValue6 = [self.dbManager loadCaloriesCount:dateString];
    totalValue7 = [self.dbManager loadWeightCount:dateString];
    
    isMile = 1;
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) isMile = 0.621371;
    
    [self updateLabels];
    [self prepareMainView];
    
    
    /*NSDate *today1 = [NSDate date];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString1 = [dateFormat1 stringFromDate:today1];
    
    [self.dbManager saveStepsDataItem:dateString1 ontime:60 ondistance:0.05 onsteps:100 onfloors:2];
    [self.dbManager saveHeartDataItem:dateString1 onrate:75 ontype:8];*/
    
    self.buttonOver.frame = CGRectMake(0, 0, self.buttonOver.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    self.viewOverButtons.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.viewOverButtons.frame.size.width, self.viewOverButtons.frame.size.height);
    
    //[self configureDCPathButton];
    
    isloaded = FALSE;
    arrLineChart = [[NSMutableArray alloc] init];
    [self refreshData:(int)self.segmentFilter.selectedSegmentIndex];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10.0f] forKey:NSFontAttributeName];
    [self.segmentFilter setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self initCircle];
    
    if(![Settings boolForKey:@"secondload"]) {
        [Settings setBool:TRUE forKey:@"secondload"];
        [Settings synchronize];
        [self.dbManager createRelaxTable];
    }
}


-(void)makeFLaunch{
    if(![Settings boolForKey:@"firstload"]) {
        [Settings setBool:TRUE forKey:@"firstload"];
        [Settings setObject:@"Fitness" forKey:@"profileName"];
        [Settings setInteger:60 forKey:@"profileWeight"];
        [Settings setInteger:170 forKey:@"profileHeight"];
        [Settings setBool:FALSE forKey:@"profileImperial"];
        
        [Settings setBool:TRUE forKey:@"checkReminders"];
        [Settings setBool:FALSE forKey:@"proActivated"];
        [Settings setBool:FALSE forKey:@"isSetup"];
        
        [Settings setInteger:0 forKey:@"freeLimit"];
        
        [Settings setInteger:500 forKey:@"goalValue"];
        [Settings setInteger:5000 forKey:@"goalTotalValue"];
        [Settings setInteger:30 forKey:@"stepExercise"];
        [Settings setInteger:10 forKey:@"stepRest"];
        [Settings setBool:TRUE forKey:@"checkCountdown1"];
        [Settings setBool:TRUE forKey:@"checkCountdown2"];
        [Settings setBool:TRUE forKey:@"checkName"];
        [Settings setInteger:0 forKey:@"rewardCurrent"];
        
        [Settings setInteger:10 forKey:@"goalRunValue"];
        [Settings setInteger:100 forKey:@"goalRunTotalValue"];
        [Settings setObject:@"Km" forKey:@"checkDistance"];
        
        [Settings setInteger:0 forKey:@"workoutStepsTime"];
        [Settings setDouble:0 forKey:@"workoutStepsDistance"];
        [Settings setInteger:0 forKey:@"workoutSteps"];
        [Settings setInteger:0 forKey:@"workoutStepsFloors"];
        
        
        [Settings setInteger:10000 forKey:@"stepPedometerGoal"];
        
        
        [Settings setInteger:30 forKey:@"stepWaterGoal"];
        [Settings setInteger:0 forKey:@"typeWaterUnits"];
        
        
        [Settings setBool:TRUE forKey:@"checkMusic"];
        [Settings setInteger:1800 forKey:@"goalYogaValue"];
        [Settings setInteger:900 forKey:@"stepYogaMeditation"];
        [Settings setInteger:300 forKey:@"stepYogaExercise"];
        
        
        [Settings setInteger:0 forKey:@"currentRate"];
        [Settings setBool:TRUE forKey:@"voiseHeart"];
        [Settings setBool:TRUE forKey:@"voiseCoundown"];
        [Settings setBool:TRUE forKey:@"voiseMessage"];
        
        
        [Settings setDouble:1000 forKey:@"stepCaloriesGoal"];
        
        [Settings setInteger:60 forKey:@"stepWeightGoal"];
        [Settings setInteger:0 forKey:@"typeWeightType"];
        
        [Settings setInteger:1800 forKey:@"stepRelaxGoal"];
        
        [Settings synchronize];
    }
}

-(UIButton *)loadExpandMenu:(UIButton *)btn withColor:(UIColor *)clr withImage:(NSString *)img {
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.height / 2.0;
    btn.backgroundColor = clr;
    UIImage *image1 = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImage:image1 forState: UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    return btn;
}

-(NSString *)getDateToday {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    //NSString *dateString = [[dateFormat stringFromDate:today] substringToIndex:10];
    return [[dateFormat stringFromDate:today] substringToIndex:10];
}

-(void)reloadAll {
    totalValue1 = [self.dbManager loadRunDistance:dateString];
    totalValue2 = [self.dbManager loadFitnessCalories:dateString];
    totalValue3 = [self.dbManager loadStepsCount:dateString];
    totalValue4 = [self.dbManager loadWaterCount:dateString];
    totalValue5 = [self.dbManager loadYogaTime:dateString];
    totalValue6 = [self.dbManager loadCaloriesCount:dateString];
    totalValue7 = [self.dbManager loadWeightCount:dateString];
    
    [self refreshMainView];
    [self onRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //dateString = [self getDateToday];
    
    [self reloadAll];
    
    //[self checkLocPermission];
    
    //[self reloadExpandMenu];
    
    [self refreshData:(int)self.segmentFilter.selectedSegmentIndex];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView1 setProgress:0];
    [_progressView2 setProgress:0];
    [_progressView3 setProgress:0];
    [_progressView4 setProgress:0];
    [_progressView5 setProgress:0];
    [_progressView6 setProgress:0];
    [_progressView7 setProgress:0];
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


-(void)updateLabels {
    
    self.labelPer1.backgroundColor = main_color2;
    self.labelPer2.backgroundColor = main_color2;
    self.labelPer3.backgroundColor = main_color2;
    self.labelPer4.backgroundColor = main_color2;
    self.labelPer5.backgroundColor = main_color2;
    self.labelPer6.backgroundColor = main_color2;
    self.labelPer7.backgroundColor = main_color2;
    
    self.labelPer1.layer.masksToBounds = YES;
    self.labelPer1.layer.cornerRadius = 3.0;
    
    self.labelPer2.layer.masksToBounds = YES;
    self.labelPer2.layer.cornerRadius = 3.0;
    
    self.labelPer3.layer.masksToBounds = YES;
    self.labelPer3.layer.cornerRadius = 3.0;
    
    self.labelPer4.layer.masksToBounds = YES;
    self.labelPer4.layer.cornerRadius = 3.0;
    
    self.labelPer5.layer.masksToBounds = YES;
    self.labelPer5.layer.cornerRadius = 3.0;
    
    self.labelPer6.layer.masksToBounds = YES;
    self.labelPer6.layer.cornerRadius = 3.0;
    
    self.labelPer7.layer.masksToBounds = YES;
    self.labelPer7.layer.cornerRadius = 3.0;
    
}

-(UIView *)makeLightCircle:(float)sz {
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    bView.layer.cornerRadius = bView.frame.size.height/2;
    bView.layer.borderColor = light_color.CGColor;
    bView.layer.borderWidth = 13;
    bView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    return bView;
}

-(void)prepareMainView {
    
    todayValue1 = (totalValue1/([Settings integerForKey:@"goalRunValue"]*1000/isMile))*100;
    todayValue2 = (totalValue2/(double)[Settings integerForKey:@"goalValue"])*100;
    todayValue3 = (totalValue3/(double)[Settings integerForKey:@"stepPedometerGoal"])*100;
    todayValue4 = (totalValue4/(double)[Settings integerForKey:@"stepWaterGoal"])*100;
    todayValue5 = (totalValue5/(double)[Settings integerForKey:@"goalYogaValue"])*100;
    todayValue6 = (totalValue6/(double)[Settings integerForKey:@"stepCaloriesGoal"])*100;
    if ([Settings integerForKey:@"typeWeightType"] == 0) todayValue7 = (totalValue7/(double)[Settings integerForKey:@"stepWeightGoal"])*100;
    else todayValue7 = ((double)[Settings integerForKey:@"stepWeightGoal"]/totalValue7)*100;
    
    float sz1 = self.topProgressView1.frame.size.height;
    float sz2 = self.topProgressView2.frame.size.height;
    float sz3 = self.topProgressView3.frame.size.height;
    float sz4 = self.topProgressView4.frame.size.height;
    float sz5 = self.topProgressView5.frame.size.height;
    float sz6 = self.topProgressView6.frame.size.height;
    float sz7 = self.topProgressView7.frame.size.height;
    
    [self.topProgressView1 addSubview:[self makeLightCircle:sz1]];
    [self.topProgressView2 addSubview:[self makeLightCircle:sz2]];
    [self.topProgressView3 addSubview:[self makeLightCircle:sz3]];
    [self.topProgressView4 addSubview:[self makeLightCircle:sz4]];
    [self.topProgressView5 addSubview:[self makeLightCircle:sz5]];
    [self.topProgressView6 addSubview:[self makeLightCircle:sz6]];
    [self.topProgressView7 addSubview:[self makeLightCircle:sz7]];
    
    _progressView1 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz1, sz1}];
    [_progressView1 setLineWidth:13];
    [_progressView1 setProgress:0];
    _progressView1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView1 addSubview:_progressView1];
    
    
    _progressView2 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz2, sz2}];
    [_progressView2 setLineWidth:13];
    [_progressView2 setProgress:0];
    _progressView2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView2 addSubview:_progressView2];
    
    
    _progressView3 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz3, sz3}];
    [_progressView3 setLineWidth:13];
    [_progressView3 setProgress:0];
    _progressView3.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView3 addSubview:_progressView3];
    
    
    _progressView4 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz4, sz4}];
    [_progressView4 setLineWidth:13];
    [_progressView4 setProgress:0];
    _progressView4.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView4 addSubview:_progressView4];
    
    
    _progressView5 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz5, sz5}];
    [_progressView5 setLineWidth:13];
    [_progressView5 setProgress:0];
    _progressView5.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView5 addSubview:_progressView5];
    
    
    _progressView6 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz6, sz6}];
    [_progressView6 setLineWidth:13];
    [_progressView6 setProgress:0];
    _progressView6.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView6 addSubview:_progressView6];
    
    
    _progressView7 = [[SFCircleGradientView alloc] initWithFrame:(CGRect){0, 0, sz7, sz7}];
    [_progressView7 setLineWidth:13];
    [_progressView7 setProgress:0];
    _progressView7.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.topProgressView7 addSubview:_progressView7];
    
    cursor = -1;
    themes = @[@[main_color2, main_color2]];
    
}

-(void)refreshMainView{
    
    todayValue1 = (totalValue1/([Settings integerForKey:@"goalRunValue"]*1000/isMile))*100;
    todayValue2 = (totalValue2/(double)[Settings integerForKey:@"goalValue"])*100;
    todayValue3 = (totalValue3/(double)[Settings integerForKey:@"stepPedometerGoal"])*100;
    todayValue4 = (totalValue4/(double)[Settings integerForKey:@"stepWaterGoal"])*100;
    todayValue5 = (totalValue5/(double)[Settings integerForKey:@"goalYogaValue"])*100;
    todayValue6 = (totalValue6/(double)[Settings integerForKey:@"stepCaloriesGoal"])*100;
    if ([Settings integerForKey:@"typeWeightType"] == 0) todayValue7 = (totalValue7/(double)[Settings integerForKey:@"stepWeightGoal"])*100;
    else todayValue7 = ((double)[Settings integerForKey:@"stepWeightGoal"]/totalValue7)*100;
    
    self.labelPer1.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue1)];
    self.labelPer2.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue2)];
    self.labelPer3.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue3)];
    self.labelPer4.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue4)];
    self.labelPer5.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue5)];
    self.labelPer6.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue6)];
    self.labelPer7.text = [NSString stringWithFormat:@"%d%%", (int)roundf(todayValue7)];
    
    [self initCircle];
    
    self.labelVal1.text = [NSString stringWithFormat:@"%.2f of %d %@ Goal", ((float)totalValue1/1000)*isMile, (int)[Settings integerForKey:@"goalRunValue"], [Settings objectForKey:@"checkDistance"]];
    self.labelVal2.text = [NSString stringWithFormat:@"%d of %ld kcal Goal", (int)totalValue2, (long)[Settings integerForKey:@"goalValue"]];
    
    self.labelVal3.text = [NSString stringWithFormat:@"%ld of %ld steps Goal", totalValue3, (long)[Settings integerForKey:@"stepPedometerGoal"]];
    
    if ([Settings integerForKey:@"typeWaterUnits"] == 0) {
        self.labelVal4.text = [NSString stringWithFormat:@"%.1f of %ld oz Goal", totalValue4, (long)[Settings integerForKey:@"stepWaterGoal"]];
    }
    else if ([Settings integerForKey:@"typeWaterUnits"] == 1) {
        self.labelVal4.text = [NSString stringWithFormat:@"%2.f of %ld ml Goal", totalValue4*oztoml, (long)([Settings integerForKey:@"stepWaterGoal"]*oztoml)];
    }
    
    self.labelVal5.text = [NSString stringWithFormat:@"%ld of %ld min Goal", (totalValue5/60), (long)[Settings integerForKey:@"goalYogaValue"]/60];
    
    self.labelVal6.text = [NSString stringWithFormat:@"%.1f of %.0f kcal Goal", totalValue6, [Settings doubleForKey:@"stepCaloriesGoal"]];
    
    if ([Settings boolForKey:@"profileImperial"]) self.labelVal7.text = [NSString stringWithFormat:@"%.1f of %.1f lb Goal", totalValue7/lbtokg, [Settings integerForKey:@"stepWeightGoal"]/lbtokg];
    else self.labelVal7.text = [NSString stringWithFormat:@"%ld of %ld kg Goal", (long)totalValue7, (long)[Settings integerForKey:@"stepWeightGoal"]];
}

- (void)onRefresh
{
    [_progressView1 setProgress:0];
    [_progressView2 setProgress:0];
    [_progressView3 setProgress:0];
    [_progressView4 setProgress:0];
    [_progressView5 setProgress:0];
    [_progressView6 setProgress:0];
    [_progressView7 setProgress:0];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf locateNewTheme];
            
            [strongSelf locateNewData:self->todayValue1 onview:1];
            [strongSelf locateNewData:self->todayValue2 onview:2];
            [strongSelf locateNewData:self->todayValue3 onview:3];
            [strongSelf locateNewData:self->todayValue4 onview:4];
            [strongSelf locateNewData:self->todayValue5 onview:5];
            [strongSelf locateNewData:self->todayValue6 onview:6];
            [strongSelf locateNewData:self->todayValue7 onview:7];
        }
    });
}

- (void)locateNewTheme {
    
    [_progressView1 setStartColor:main_color2];
    [_progressView1 setEndColor:main_color2];
    
    [_progressView2 setStartColor:main_color2];
    [_progressView2 setEndColor:main_color2];
    
    [_progressView3 setStartColor:main_color2];
    [_progressView3 setEndColor:main_color2];
    
    [_progressView4 setStartColor:main_color2];
    [_progressView4 setEndColor:main_color2];
    
    [_progressView5 setStartColor:main_color2];
    [_progressView5 setEndColor:main_color2];
    
    [_progressView6 setStartColor:main_color2];
    [_progressView6 setEndColor:main_color2];
    
    [_progressView7 setStartColor:main_color2];
    [_progressView7 setEndColor:main_color2];
    
}

- (void)locateNewData:(double)tv onview:(int)pv {
    
    CGFloat from = 0.f;
    CGFloat to = 1.f;
    
    if (tv == 0) {
        to = 0.f;
    }
    else if (tv > 100) {
        to = 1.f;
    }
    else {
        to = tv/100;
        to = (round(to*100))/100.0;
    }
    
    if (pv == 2) [_progressView2 setProgress:to animateWithDuration:0.6];
    else if (pv == 3) [_progressView3 setProgress:to animateWithDuration:0.6];
    else if (pv == 4) [_progressView4 setProgress:to animateWithDuration:0.6];
    else if (pv == 5) [_progressView5 setProgress:to animateWithDuration:0.6];
    else if (pv == 6) [_progressView6 setProgress:to animateWithDuration:0.6];
    else if (pv == 7) [_progressView7 setProgress:to animateWithDuration:0.6];
    else [_progressView1 setProgress:to animateWithDuration:0.6];
    
    [self animateTitle:@(from) toNumber:@((int)(to*100))];
}

- (void)animateTitle:(NSNumber *)from toNumber:(NSNumber *)to
{
    fromNumber = from;
    toNumber = to;

    //_titleLabel.text = [NSString stringWithFormat:@"%@ %%", fromNumber];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animateNumber:(CADisplayLink *)link
{
    float dt = ([link timestamp] - startTime) / 0.6;
    if (dt >= 1.0) {
        //_titleLabel.text = [NSString stringWithFormat:@"%@%%", toNumber];
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        return;
    }
}

- (IBAction)buttonStartAction:(id)sender {
    float lb = 1;
    float ft = 1;
    if (self.stepWeight.selectedSegmentIndex == 0) {
        [Settings setBool:FALSE forKey:@"profileImperial"];
    }
    else {
        lb = lbtokg;
        ft = 30.48;
        [Settings setBool:TRUE forKey:@"profileImperial"];
    }
    if ([self.inputName.text length] > 0) [Settings setObject:self.inputName.text forKey:@"profileName"];
    if ([self.inputWeight.text length] > 0) [Settings setInteger:(long)([self.inputWeight.text floatValue]*lb) forKey:@"profileWeight"];
    if ([self.inputHeight.text length] > 0) [Settings setInteger:(long)([self.inputHeight.text floatValue]*ft) forKey:@"profileHeight"];
    [Settings setBool:TRUE forKey:@"isSetup"];
    [Settings synchronize];
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.messageSetup.alpha = 0.0;} completion:^(BOOL finished) {
        self.messageSetup.hidden = TRUE;
    }];
    
    self.buttonMenu.enabled = TRUE;
    self.buttonDateDialog.enabled = TRUE;
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



- (IBAction)showDateDialog:(id)sender {
    /*NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 7]; //One week from now
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -3;
    NSDate* threeYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    
    LSLDatePickerDialog *dialog = [[LSLDatePickerDialog alloc] initWithTextColor:[UIColor darkGrayColor] buttonColor:main_color2 font:[UIFont boldSystemFontOfSize:14.0] locale:nil cancelButton:YES];
    [dialog showWithTitle:@"Select Date" doneButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" defaultDate:[NSDate date] minimumDate:threeYearsAgo maximumDate:currentDate datePickerMode:UIDatePickerModeDate callback:^(NSDate * _Nullable date) {
        if(date)
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd.MM.yyyy"];
            self->dateString = [dateFormat stringFromDate:date];
            self->_subTitleLabel.text = self->dateString;
            [self reloadAll];
        }
    }];*/
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}




- (IBAction)stepWeightChange:(id)sender {
    if (self.stepWeight.selectedSegmentIndex == 0) self.stepHeight.selectedSegmentIndex = 0;
    else self.stepHeight.selectedSegmentIndex = 1;
}
- (IBAction)stepHeightChange:(id)sender {
    if (self.stepHeight.selectedSegmentIndex == 0) self.stepWeight.selectedSegmentIndex = 0;
    else self.stepWeight.selectedSegmentIndex = 1;
}

- (IBAction)buttonOverAction:(id)sender {
    self.viewOverMenu.hidden = TRUE;
    self.buttonOver.hidden = TRUE;
    self.viewOverButtons.frame = CGRectMake(self.viewOverButtons.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.viewOverButtons.frame.size.width, self.viewOverButtons.frame.size.height);
    /*[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{self.buttonOver.alpha = 0.0f;} completion:^(BOOL finished) {
        //[self.buttonNav setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        self.viewOverMenu.hidden = TRUE;
        self.buttonOver.hidden = TRUE;
    }];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.viewOverButtons.frame = CGRectMake(self.viewOverButtons.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.viewOverButtons.frame.size.width, self.viewOverButtons.frame.size.height);
    } completion:^(BOOL finished){

    }];*/
}

- (IBAction)buttonNavAction:(id)sender {
    self.viewOverMenu.hidden = FALSE;
    self.buttonOver.hidden = FALSE;
    self.viewOverButtons.frame = CGRectMake(self.viewOverButtons.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 300, self.viewOverButtons.frame.size.width, self.viewOverButtons.frame.size.height);
    /*[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{self.buttonOver.alpha = 0.8f;} completion:^(BOOL finished) {
        //[self.buttonNav setBackgroundImage:[UIImage imageNamed:@"plus1.png"] forState:UIControlStateNormal];
    }];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.viewOverButtons.frame = CGRectMake(self.viewOverButtons.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 300, self.viewOverButtons.frame.size.width, self.viewOverButtons.frame.size.height);
    } completion:^(BOOL finished){

    }];*/
}

- (IBAction)buttonBottomAction1:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"runViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction2:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"fitnessViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction3:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"stepsViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction4:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"waterViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction5:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"yogaViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction6:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"caloriesViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction7:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"heartViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)buttonBottomAction8:(id)sender {
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"weightViewController"]]
                                                         animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}



- (void)createLineChart {
    if (isloaded) [_lineChartView removeFromSuperview];
    else isloaded = TRUE;
    _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, 35, self.viewGraph.frame.size.width, self.viewGraph.frame.size.height-40)];
    _lineChartView.dotRadius = 4;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @10;
    int kv = 10;
    if ((max >= 100) && (max <= 1000)) kv = 100;
    else if ((max > 1000) && (max <= 10000)) kv = 500;
    else if (max > 10000) kv = 1000;
    _lineChartView.maxValue = [NSNumber numberWithInt:(max+kv)];
    _lineChartView.minValue = 0;
    _lineChartView.solidDot = YES;
    _lineChartView.numberOfYAxis = 7;
    _lineChartView.colorOfXAxis = [UIColor lightGrayColor];
    _lineChartView.colorOfXText = [UIColor lightGrayColor];
    _lineChartView.colorOfYAxis = [UIColor lightGrayColor];
    _lineChartView.colorOfYText = [UIColor lightGrayColor];
    [self.viewGraph addSubview:_lineChartView];
    [_lineChartView reloadDataWithAnimate:YES];
}


- (void)refreshData:(int)nm {
    int anum = 0;
    int ynum = 1;
    switch (nm) {
        case 0:
            arrLineChart = [self.dbManager loadRunAllItems:dateString];
            anum = 2;
            break;
        case 1:
            arrLineChart = [self.dbManager loadAllItems:dateString];
            anum = 6;
            break;
        case 2:
            arrLineChart = [self.dbManager loadStepsAllItems:dateString];
            anum = 4;
            break;
        case 3:
            arrLineChart = [self.dbManager loadWaterAllItems:dateString];
            anum = 2;
            break;
        case 4:
            arrLineChart = [self.dbManager loadYogaAllItems:dateString];
            anum = 4;
            ynum = 60;
            break;
        case 5:
            arrLineChart = [self.dbManager loadCaloriesLogItems:dateString];
            anum = 2;
            break;
        case 6:
            arrLineChart = [self.dbManager loadWeightLogData:dateString];
            anum = 2;
            break;
        default:
            break;
    }
    
    NSMutableArray *tit = [[NSMutableArray alloc] init];
    NSMutableArray *vl = [[NSMutableArray alloc] init];
    if (vl.count > 0) {
        [tit removeAllObjects];
        [vl removeAllObjects];
    }
    max = 0;
    for (int i = 0; i < [arrLineChart count]; i++) {
        NSString *dt = [NSString stringWithFormat:@"%@", [[arrLineChart objectAtIndex:i] objectAtIndex:1]];
        if (anum == 6) dt = [NSString stringWithFormat:@"%@", [[arrLineChart objectAtIndex:i] objectAtIndex:4]];
        if (anum == 4) dt = [NSString stringWithFormat:@"%@", [[arrLineChart objectAtIndex:i] objectAtIndex:3]];
        int v = [[[arrLineChart objectAtIndex:i] objectAtIndex:anum/ynum] intValue];
        if (v >= max) max = v;
        //[tit addObject:[dt substringToIndex:10]];
        [tit addObject:[dt substringWithRange: NSMakeRange(12,5)]];
        [vl addObject:[NSNumber numberWithInteger:v]];
    }
    _titles = [tit copy];
    _dataSource = [vl copy];
    
    [self createLineChart];
    //[_circleChartView reloadDataWithAnimate:YES];
}

- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    return [_dataSource count];
}

- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    return _dataSource[lineNumber == 0 ? index : [_dataSource count] - index - 1];
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
    return _titles[number];
}

- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    if (lineNumber == 0) {
        return main_color2;
    } else if (lineNumber == 1) {
        return main_color2;
    } else if (lineNumber == 2) {
        return main_color2;
    } else {
        return main_color2;
    }
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    //if (index == 0 || index == _dataSource.count - 1) {
        return [NSString stringWithFormat:@"%@", _dataSource[index]];
    //}
    //return nil;
}


- (IBAction)segmentFilterAction:(id)sender {
    [self refreshData:(int)self.segmentFilter.selectedSegmentIndex];
}





-(void)initCircle {
    if ((todayValue1>0) || (todayValue2>0) || (todayValue3>0) || (todayValue4>0) || (todayValue5>0) || (todayValue6>0) || (todayValue7>0)) _dataSource1 = @[[NSNumber numberWithInt:roundf(todayValue1)], [NSNumber numberWithInt:roundf(todayValue2)], [NSNumber numberWithInt:roundf(todayValue3)], [NSNumber numberWithInt:roundf(todayValue4)], [NSNumber numberWithInt:roundf(todayValue5)], [NSNumber numberWithInt:roundf(todayValue6)], [NSNumber numberWithInt:roundf(todayValue7)]];
    else _dataSource1 = @[@100, @100, @100, @100, @100, @100, @100];
        
    //_circleChartView = [[MCCircleChartView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 310)];
    _circleChartView = [[MCCircleChartView alloc] initWithFrame:CGRectMake(8, 0, 310, 310)];
    _circleChartView.introduceColor = [UIColor grayColor];
    _circleChartView.introduceFontSize = 12.0;
    _circleChartView.maxRadius = 140;
    _circleChartView.circleWidth = 15.0;
    _circleChartView.dataSource = self;
    _circleChartView.delegate = self;
    [self.viewProgress addSubview:_circleChartView];
        
    [_circleChartView reloadDataWithAnimate:YES];
}

- (float)isMax:(float)vl {
    if (vl > 0) return vl;
    else return 100;
}

- (NSInteger)numberOfCircleInCircleChartView:(MCCircleChartView *)circleChartView {
    return _dataSource1.count;
}

- (id)circleChartView:(MCCircleChartView *)circleChartView valueOfCircleAtIndex:(NSInteger)index {
    return _dataSource1[index];
}

- (NSString *)circleChartView:(MCCircleChartView *)circleChartView introduceAtIndex:(NSInteger)index {
    NSString *tp = @"";
    switch(index){
        case 0:
            tp = @"Run";
            break;
        case 1:
            tp = @"Workout";
            break;
        case 2:
            tp = @"Steps";
            break;
        case 3:
            tp = @"Water";
            break;
        case 4:
            tp = @"Yoga";
            break;
        case 5:
            tp = @"Food";
            break;
        case 6:
            tp = @"Weight";
            break;
        default :
            tp = @"Other";
    }
    if ((todayValue1>0) || (todayValue2>0) || (todayValue3>0) || (todayValue4>0) || (todayValue5>0) || (todayValue6>0) || (todayValue7>0)) return [NSString stringWithFormat:@"%@%% %@", _dataSource1[index], tp];
    else return [NSString stringWithFormat:@"0%% %@", tp];
}

/*- (NSAttributedString *)titleInCircleChartView:(MCCircleChartView *)circleChartView {
    return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}*/

- (UIColor *)circleChartView:(MCCircleChartView *)circleChartView colorOfCircleAtIndex:(NSInteger)index {
    if ((todayValue1>0) || (todayValue2>0) || (todayValue3>0) || (todayValue4>0) || (todayValue5>0) || (todayValue6>0) || (todayValue7>0)) {
        /*switch (index) {
            case 0:
                return main_color3;
            case 1:
                return main_color3;
            case 2:
                return main_color3;
            case 3:
                return main_color3;
            case 4:
                return main_color3;
            case 5:
                return main_color3;
            case 6:
                return main_color3;
            default:
                return main_color3;
        }*/
        return [UIColor systemGreenColor];
    }
    else {
        return [UIColor systemGray5Color];
    }
}

-(void)setTextFont {
    self.labelTp1.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp2.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp3.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp4.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp5.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp6.font = [UIFont systemFontOfSize:13.0f];
    self.labelTp7.font = [UIFont systemFontOfSize:13.0f];
    self.labelPer1.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer2.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer3.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer4.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer5.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer6.font = [UIFont systemFontOfSize:15.0f];
    self.labelPer7.font = [UIFont systemFontOfSize:15.0f];
    self.labelVal1.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal2.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal3.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal4.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal5.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal6.font = [UIFont systemFontOfSize:13.0f];
    self.labelVal7.font = [UIFont systemFontOfSize:13.0f];
    
    self.labelOverButton1.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton2.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton3.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton4.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton5.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton6.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton7.font = [UIFont systemFontOfSize:13.0f];
    self.labelOverButton8.font = [UIFont systemFontOfSize:13.0f];
    
    self.labelST.font = [UIFont fontWithName:@"GothamBlack" size:26.0f];
    self.labelSN.font = [UIFont systemFontOfSize:16.0f];
    self.labelSW.font = [UIFont systemFontOfSize:16.0f];
    self.labelSH.font = [UIFont systemFontOfSize:16.0f];
    self.labelSD.font = [UIFont systemFontOfSize:14.0f];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey:NSFontAttributeName];
    [self.stepWeight setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.stepHeight setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.inputName.font = [UIFont systemFontOfSize:13.0f];
    self.inputHeight.font = [UIFont systemFontOfSize:13.0f];
    self.inputWeight.font = [UIFont systemFontOfSize:13.0f];
    self.buttonStart.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:10.0f] forKey:NSFontAttributeName];
    [self.segmentFilter setTitleTextAttributes:attributes1 forState:UIControlStateNormal];
}


@end
