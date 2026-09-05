
#import "StepsViewController.h"

@implementation StepsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"PEDOMETER";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    self.buttonStart.layer.masksToBounds = YES;
    self.buttonStart.layer.cornerRadius = self.buttonStart.frame.size.height / 15.0;
    
    if(![Settings boolForKey:@"firstsetup"]) {
        [self.buttonStart setTitle:@"START" forState:UIControlStateNormal];
        [Settings setBool:TRUE forKey:@"firstsetup"];
        [Settings synchronize];
    }
    
    [self updateProgress];
    [self setTextFont];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    total_steps = [self.dbManager loadStepsHomeItems];
    
    [self updateLabels];
    
    if (total_steps > 0) self.cprogressView.progress = (float)total_steps/[Settings integerForKey:@"stepPedometerGoal"];
    else self.cprogressView.progress = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonStartAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        [Settings setInteger:([Settings integerForKey:@"freeLimit"] + 1) forKey:@"freeLimit"];
        [Settings synchronize];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"stepsWorkoutViewBoard"];
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

/*- (void)viewGraph {
    self.graphView = [[GraphView alloc]initWithFrame:CGRectMake(1, 1, self.historyGraph.frame.size.width, self.historyGraph.frame.size.height)];
    [self.graphView setBackgroundColor:[UIColor clearColor]];
    if (total_steps == 0) {
        [self.graphView setSpacing:1];
    }
    else {
        [self.graphView setSpacing:0];
    }
    [self.graphView setFill:YES];
    [self.graphView setStrokeColor:orange_color];
    [self.graphView setZeroLineStrokeColor:[UIColor clearColor]];
    [self.graphView setFillColor:light_color];
    [self.graphView setLineWidth:2];
    [self.graphView setCurvedLines:YES];
    //[graphView hideAxis:YES];
    [self.historyGraph addSubview:self.graphView];
    [self.graphView setArray:[self.dbManager loadStepsLastActivityItems]];
}*/

- (void) updateLabels {
    total_workouts = 0;
    total_distance = 0;
    total_floors = 0;
    total_time = 0;
    
    NSMutableArray *actArr = [[NSMutableArray alloc] init];
    actArr = [self.dbManager loadStepsDataItems];
    
    total_workouts = [actArr[0] intValue];
    total_time = [actArr[1] intValue];
    total_distance = [actArr[2] floatValue];
    total_floors = [actArr[4] intValue];
    
    self.labelWorkouts.text = [NSString stringWithFormat:@"%ld",total_workouts];
    self.labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(total_time/3600),((total_time/60)%60),(total_time%60)];
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) {
        //isMile = 0.621371;
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f mi",total_distance*0.000621371192];
    }
    else {
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f km",total_distance*0.001];
    }
    
    self.labelFloors.text = [NSString stringWithFormat:@"%ld",total_floors];
    
    if (total_steps) self.titleTotalSteps.text = [NSString stringWithFormat:@"%ld",total_steps];
    self.labelGoal.text = [NSString stringWithFormat:@"of %ld daily goal", (long)[Settings integerForKey:@"stepPedometerGoal"]];
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
    [self.viewProgress addSubview:self.cprogressView];
    
}

-(void)setTextFont {
    self.labelTsteps.font = [UIFont systemFontOfSize:20.0f];
    self.labelDistance.font = [UIFont systemFontOfSize:85.0f];
    self.labelGoal.font = [UIFont systemFontOfSize:20.0f];
    self.buttonStart.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    
    self.labelSt1.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:17.0f];
    
    self.labelTime.font = [UIFont systemFontOfSize:20.0f];
    self.labelWorkouts.font = [UIFont systemFontOfSize:20.0f];
    self.labelFloors.font = [UIFont systemFontOfSize:20.0f];
    self.labelDistance.font = [UIFont systemFontOfSize:20.0f];
}

@end
