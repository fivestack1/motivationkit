
#import "WeightViewController.h"

@implementation WeightViewController {
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
    self.navigationController.navigationBar.topItem.title = @"WEIGHT DIARY";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    //UIImage *image = [[UIImage imageNamed:@"plus.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[self.buttonPlus setBackgroundImage:image forState:UIControlStateNormal];
    //self.buttonPlus.tintColor = main_color2;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    [self updateProgress];
    [self setTextFont];
}

-(void)refreshMainView{
    todayValue = 0;
    
    todayValue = [self.dbManager loadWeightTopItems];
    //if (todayValue == 0) todayValue = (double)[Settings integerForKey:@"profileWeight"];
    [self updateLabels];
    
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
    if ([Settings boolForKey:@"profileImperial"]) {
        self.labelCurrent.text = [NSString stringWithFormat:@"%.1f of %.2f lb goal", todayValue/lbtokg, (float)[Settings integerForKey:@"stepWeightGoal"]/lbtokg];
        if ([Settings integerForKey:@"typeWeightType"] == 0){
            self.progressView.progress = (todayValue/lbtokg)/((float)[Settings integerForKey:@"stepWeightGoal"]/lbtokg);
            self.labelLeft.text = [NSString stringWithFormat:@"%.1f lb left to reach goal", ((float)[Settings integerForKey:@"stepWeightGoal"]-todayValue)/lbtokg];
        }
        else {
            self.progressView.progress = ((float)[Settings integerForKey:@"stepWeightGoal"]/lbtokg)/(todayValue/lbtokg);
            self.labelLeft.text = [NSString stringWithFormat:@"%.1f lb left to reach goal", ((float)[Settings integerForKey:@"stepWeightGoal"]-todayValue)/lbtokg];
        }
    }
    else {
        self.labelCurrent.text = [NSString stringWithFormat:@"%.1f of %d kg goal", todayValue, (int)[Settings integerForKey:@"stepWeightGoal"]];
        if ([Settings integerForKey:@"typeWeightType"] == 0) {
            self.progressView.progress = todayValue/(float)[Settings integerForKey:@"stepWeightGoal"];
            self.labelLeft.text = [NSString stringWithFormat:@"%.1f kg left to reach goal", ((float)[Settings integerForKey:@"stepWeightGoal"]-todayValue)];
        }
        else {
            self.progressView.progress = (float)[Settings integerForKey:@"stepWeightGoal"]/todayValue;
            self.labelLeft.text = [NSString stringWithFormat:@"%.1f kg left to reach goal", ((float)[Settings integerForKey:@"stepWeightGoal"]-todayValue)];
        }
    }
    
}

- (void)updateProgress {
    //float ht = UIScreen.mainScreen.bounds.size.height;
    float ht = self.viewProgress.bounds.size.height-30;
    if (ht > UIScreen.mainScreen.bounds.size.width*0.85) ht = UIScreen.mainScreen.bounds.size.width*0.85;
    //self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-(ht-20)/2, ht/2-(ht-20)/2, ht-20, ht-20) pathBackColor:[UIColor lightGrayColor] pathFillColor:[UIColor redColor] startAngle:0 strokeWidth:10];
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width/2-ht/2, 0, ht, ht) pathBackColor:light_color pathFillColor:main_color2 startAngle:0 strokeWidth:10];
    self.progressView.startAngle = 125;
    self.progressView.reduceAngle = 75;
    self.progressView.strokeWidth = 15;
    //self.progressView.pointImage.image = [UIImage imageNamed:@"test"];
    self.progressView.duration = 1.5;
    self.progressView.showPoint = YES;
    self.progressView.showProgressText = YES;
    self.progressView.increaseFromLast = NO;
    self.progressView.showPercent = NO;
    [self.viewProgress addSubview:self.progressView];
    
}

- (IBAction)buttonPlusAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"WeightNewStoryBoardView"];
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

-(void)setTextFont {
    self.labelCurrent.font = [UIFont systemFontOfSize:30];
    self.labelLeft.font = [UIFont systemFontOfSize:17];
    self.labelSt1.font = [UIFont systemFontOfSize:17.0f];
}

@end
