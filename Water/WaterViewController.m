
#import "WaterViewController.h"

@implementation WaterViewController {
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
    self.navigationController.navigationBar.topItem.title = @"WATER BALANCE";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    [self setTextFont];
}

-(void)refreshMainView{
    todayValue = 0;
    
    todayValue = [self.dbManager loadWaterTopItems];
    [self updateLabels];
    
    HcdProcessView *customView = [[HcdProcessView alloc]initWithFrame:CGRectMake(self.viewProgress.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    CGFloat prc = 0;
    if ([Settings integerForKey:@"typeWaterUnits"] == 0) {
        prc = todayValue/[Settings integerForKey:@"stepWaterGoal"];
    }
    else if ([Settings integerForKey:@"typeWaterUnits"] == 1) {
        prc = (todayValue*oztoml)/([Settings integerForKey:@"stepWaterGoal"]*oztoml);
    }

    customView.percent = prc;
    customView.showBgLineView = YES;
    customView.waveLength = self.viewProgress.frame.size.width;
    customView.amplitude = self.viewProgress.frame.size.width * 1 / 20;
    customView.showBgLineView = NO;
    customView.waterBgColor = [UIColor whiteColor];
    //customView.lineBgColor = [UIColor colorWithRed:0.749 green:0.910 blue:0.984 alpha:1.00];
    //customView.scaleColor = [UIColor colorWithRed:0.969 green:0.937 blue:0.227 alpha:1.00];
     customView.lineBgColor = main_color2;
     customView.scaleColor = main_color2;
    
    [self.viewProgress addSubview:customView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshMainView];
}

- (void)updateLabels {
    
    
    if ([Settings integerForKey:@"typeWaterUnits"] == 0) {
        self.labelCurrent.text = [NSString stringWithFormat:@"%.1f of %ld Oz", todayValue , (long)([Settings integerForKey:@"stepWaterGoal"])];
    }
    else if ([Settings integerForKey:@"typeWaterUnits"] == 1) {
        self.labelCurrent.text = [NSString stringWithFormat:@"%2.f of %ld Ml", todayValue*oztoml, (long)([Settings integerForKey:@"stepWaterGoal"]*oztoml)];
    }
    
    //int wcurr = (100*todayValue)/[Settings doubleForKey:@"stepGoal"];
    
}


- (IBAction)buttonPlusAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NewStoryBoardView"];
        secondViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:secondViewController animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Free limit" message:@"Unlock Pro version in Settings to remove limit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)buttonMinusAction:(id)sender {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    if ([self.dbManager checkWaterDataItems:[components day] onmonth:[components month] onyear:[components year]]) {
        [self.dbManager deleteWaterDataItem];
        todayValue = 0;
        todayValue = [self.dbManager loadWaterTopItems];
        [self updateLabels];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Water" message:@"Last portion has been deleted" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont systemFontOfSize:17.0f];
    self.labelCurrent.font = [UIFont systemFontOfSize:30.0f];
}

@end
