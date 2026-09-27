
#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonReset.layer.masksToBounds = YES;
    self.buttonReset.layer.cornerRadius = self.buttonReset.frame.size.height / 5.0;
    
    self.buttonRate.layer.masksToBounds = YES;
    self.buttonRate.layer.cornerRadius = self.buttonRate.frame.size.height / 5.0;
    
    self.viewMain.frame = CGRectMake(0, 0, self.scrollViewMain.frame.size.width, 1600);
    [self.scrollViewMain setScrollEnabled:YES];
    [self.scrollViewMain setContentSize:CGSizeMake(self.scrollViewMain.frame.size.width, 1600)];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    [self restoreSettings];
    
    [self setTextFont];
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

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self SaveSettings];
}

- (void)restoreSettings {
    if ([Settings boolForKey:@"checkReminders"]) { self.switchNotifications.on = TRUE; }
    else { self.switchNotifications.on = FALSE; }
    
    self.stepWorkout.value = (double)([Settings integerForKey:@"stepExercise"]);
    self.stepRest.value = (double)([Settings integerForKey:@"stepRest"]);
    self.stepGoal.value = (double)[Settings integerForKey:@"goalValue"];
    self.stepTotalGoal.value = (double)[Settings integerForKey:@"goalTotalValue"];
    self.labelWorkout.text = [NSString stringWithFormat:@"Exercise duration (%d sec)", (int)[Settings integerForKey:@"stepExercise"]];
    self.labelRest.text = [NSString stringWithFormat:@"Rest duration (%d sec)", (int)[Settings integerForKey:@"stepRest"]];
    self.labelGoal.text = [NSString stringWithFormat:@"Daily goal (%d Kcal)", (int)[Settings integerForKey:@"goalValue"]];
    self.labelTotalGoal.text = [NSString stringWithFormat:@"Total goal (%d Kcal)", (int)[Settings integerForKey:@"goalTotalValue"]];
    
    
    dst = [NSString stringWithFormat:@"%@", [Settings objectForKey:@"checkDistance"]];
    if ([dst isEqualToString:@"Mi"]) { self.segmentDistance.selectedSegmentIndex = 1; }
    else { self.segmentDistance.selectedSegmentIndex = 0; }
    
    self.stepRunGoal.value = (double)[Settings integerForKey:@"goalRunValue"];
    self.stepRunTotalGoal.value = (double)[Settings integerForKey:@"goalRunTotalValue"];

    self.labelRunGoal.text = [NSString stringWithFormat:@"Daily goal (%d %@)", (int)[Settings integerForKey:@"goalRunValue"], dst];
    self.labelRunTotalGoal.text = [NSString stringWithFormat:@"Total goal (%d %@)", (int)[Settings integerForKey:@"goalRunTotalValue"], dst];
    
    self.stepWaterExercise.value = [Settings integerForKey:@"stepWaterGoal"] ;
    if ([Settings integerForKey:@"typeWaterUnits"] == 0) {
        [self.stepWaterUnits setSelectedSegmentIndex:0];
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%ld Oz)", [Settings integerForKey:@"stepWaterGoal"]];
    }
    else {
        [self.stepWaterUnits setSelectedSegmentIndex:1];
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%ld Ml)", [Settings integerForKey:@"stepWaterGoal"]];
    }
    
    self.stepPedometerExercise.value = (double)[Settings doubleForKey:@"stepPedometerGoal"];
    self.labelPedometerExercise.text = [NSString stringWithFormat:@"Daily goal (%ld steps)", [Settings integerForKey:@"stepPedometerGoal"]];
    
    if ([Settings boolForKey:@"checkMusic"]) { self.switchMusic.on = TRUE; }
    else { self.switchMusic.on = FALSE; }
    self.stepYogaWorkout.value = (double)([Settings integerForKey:@"stepYogaExercise"]/60);
    self.stepYogaMeditation.value = (double)([Settings integerForKey:@"stepYogaMeditation"]/60);
    self.stepYogaGoal.value = (double)[Settings integerForKey:@"goalYogaValue"]/60;
    self.labelYogaWorkout.text = [NSString stringWithFormat:@"Exercise (%d min)", (int)([Settings integerForKey:@"stepYogaExercise"]/60)];
    self.labelYogaMeditation.text = [NSString stringWithFormat:@"Meditation (%d min)", (int)([Settings integerForKey:@"stepYogaMeditation"]/60)];
    self.labelYogaGoal.text = [NSString stringWithFormat:@"Daily goal (%d min)", (int)([Settings integerForKey:@"goalYogaValue"]/60)];
    
    self.labelWeightExercise.text = [NSString stringWithFormat:@"Daily goal (%2.f Kcal)", [Settings doubleForKey:@"stepCaloriesGoal"]];
    self.stepWeightExercise.value = [Settings doubleForKey:@"stepCaloriesGoal"];
    
    self.stepWeightGoal.value = (int)[Settings integerForKey:@"stepWeightGoal"];
    if ([Settings boolForKey:@"profileImperial"]) self.labelWeightGoal.text = [NSString stringWithFormat:@"Goal (%ld lb)", (long)[Settings integerForKey:@"stepWeightGoal"]];
    else self.labelWeightGoal.text = [NSString stringWithFormat:@"Goal (%ld kg)", (long)[Settings integerForKey:@"stepWeightGoal"]];
    if ([Settings integerForKey:@"typeWeightType"] == 0) [self.segmentWeightType setSelectedSegmentIndex:0];
    else [self.segmentWeightType setSelectedSegmentIndex:1];
}

- (void)SaveSettings {
    if (self.switchNotifications.on) { [Settings setBool:TRUE forKey:@"checkReminders"]; }
    else { [Settings setBool:FALSE forKey:@"checkReminders"]; }
    
    [Settings setInteger:(long)(self.stepWorkout.value) forKey:@"stepExercise"];
    [Settings setInteger:(long)(self.stepRest.value) forKey:@"stepRest"];
    [Settings setInteger:(long)(self.stepGoal.value) forKey:@"goalValue"];
    [Settings setInteger:(long)(self.stepTotalGoal.value) forKey:@"goalTotalValue"];
    
    
    [Settings setInteger:(long)(self.stepRunGoal.value) forKey:@"goalRunValue"];
    [Settings setInteger:(long)(self.stepRunTotalGoal.value) forKey:@"goalRunTotalValue"];
    
    if (self.segmentDistance.selectedSegmentIndex == 1) { [Settings setObject:@"Mi" forKey:@"checkDistance"]; }
    else { [Settings setObject:@"Km" forKey:@"checkDistance"]; }
    
    if ([self.stepWaterUnits selectedSegmentIndex] == 0) {
        [Settings setInteger:0 forKey:@"typeWaterUnits"];
    }
    else {
        [Settings setInteger:1 forKey:@"typeWaterUnits"];
    }
    [Settings setInteger:(int)self.stepWaterExercise.value forKey:@"stepWaterGoal"];
    
    [Settings setInteger:(long)self.stepPedometerExercise.value forKey:@"stepPedometerGoal"];
    
    if (self.switchMusic.on) { [Settings setBool:TRUE forKey:@"checkMusic"]; }
    else { [Settings setBool:FALSE forKey:@"checkMusic"]; }
    [Settings setInteger:(long)(self.stepYogaWorkout.value*60) forKey:@"stepYogaExercise"];
    [Settings setInteger:(long)(self.stepYogaMeditation.value*60) forKey:@"stepYogaMeditation"];
    [Settings setInteger:(long)(self.stepYogaGoal.value*60) forKey:@"goalYogaValue"];
    
    [Settings setDouble:self.stepWeightExercise.value forKey:@"stepCaloriesGoal"];
    
    if ([self.segmentWeightType selectedSegmentIndex] == 0) { [Settings setInteger:0 forKey:@"typeWeightType"]; }
    else { [Settings setInteger:1 forKey:@"typeWeightType"]; }
    [Settings setInteger:self.stepWeightGoal.value forKey:@"stepWeightGoal"];
    
    [Settings synchronize];
}

- (IBAction)stepWorkoutAction:(id)sender {
    self.labelWorkout.text = [NSString stringWithFormat:@"Exercise duration (%d sec)", (int)self.stepWorkout.value];
}

- (IBAction)stepRestAction:(id)sender {
    self.labelRest.text = [NSString stringWithFormat:@"Rest duration (%d sec)", (int)self.stepRest.value];
}

- (IBAction)stepGoalAction:(id)sender {
    self.labelGoal.text = [NSString stringWithFormat:@"Daily goal (%d Kcal)", (int)self.stepGoal.value];
}

- (IBAction)stepTotalGoalAction:(id)sender {
    self.labelTotalGoal.text = [NSString stringWithFormat:@"Total goal (%d Kcal)", (int)self.stepTotalGoal.value];
}

- (IBAction)buttonResetAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"All data will be deleted" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        self.dbManager = [[DBManager alloc] initDatabase];
        [self.dbManager emptyDataBase];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buttonRateAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rate_id] options:@{} completionHandler:nil];
}

- (IBAction)stepRunGoalAction:(id)sender {
    self.labelRunGoal.text = [NSString stringWithFormat:@"Daily goal (%d %@)", (int)self.stepRunGoal.value, dst];
}

- (IBAction)stepRunTotalGoalAction:(id)sender {
    self.labelRunTotalGoal.text = [NSString stringWithFormat:@"Total goal (%d %@)", (int)self.stepRunTotalGoal.value, dst];
}

- (IBAction)segmentDistanceAction:(id)sender {
    if (self.segmentDistance.selectedSegmentIndex == 0) dst = @"Km";
    else dst = @"Mi";
    self.labelRunGoal.text = [NSString stringWithFormat:@"Daily goal (%d %@)", (int)self.stepRunGoal.value, dst];
    self.labelRunTotalGoal.text = [NSString stringWithFormat:@"Total goal (%d %@)", (int)self.stepRunTotalGoal.value, dst];
}

- (IBAction)stepWaterExerciseAction:(id)sender {
    if ([self.stepWaterUnits selectedSegmentIndex] == 0) {
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%ld Oz)", (long)self.stepWaterExercise.value];
    }
    else if ([self.stepWaterUnits selectedSegmentIndex] == 1) {
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%ld Ml)", (long)(self.stepWaterExercise.value*oztoml)];
    }
}

- (IBAction)stepWaterUnitsChanged:(id)sender {
    if ([self.stepWaterUnits selectedSegmentIndex] == 0) {
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%d.0 Oz)", (int)(self.stepWaterExercise.value/oztoml)];
        //self.stepWaterExercise.value = (int)(self.stepWaterExercise.value/oztoml);
    }
    else if ([self.stepWaterUnits selectedSegmentIndex] == 1) {
        self.labelWaterExercise.text = [NSString stringWithFormat:@"Daily (%d.0 Ml)", (int)(self.stepWaterExercise.value*oztoml)];
        //self.stepWaterExercise.value = (int)(self.stepWaterExercise.value*oztoml);
    }
    self.stepWaterExercise.value = self.stepWaterExercise.value;
}

- (IBAction)stepPedometerExerciseAction:(id)sender {
    self.labelPedometerExercise.text = [NSString stringWithFormat:@"Daily goal (%g.0 steps)", self.stepPedometerExercise.value];
}

- (IBAction)stepWeightExerciseAction:(id)sender {
    self.labelWeightExercise.text = [NSString stringWithFormat:@"Daily goal (%g.0 Kcal)", self.stepWeightExercise.value];
}

- (IBAction)stepYogaWorkoutAction:(id)sender {
    self.labelYogaWorkout.text = [NSString stringWithFormat:@"Exercise (%d min)", (int)self.stepYogaWorkout.value];
}

- (IBAction)stepYogaMeditationAction:(id)sender {
    self.labelYogaMeditation.text = [NSString stringWithFormat:@"Meditation (%d min)", (int)self.stepYogaMeditation.value];
}

- (IBAction)stepYogaGoalAction:(id)sender {
    self.labelYogaGoal.text = [NSString stringWithFormat:@"Daily goal (%d min)", (int)self.stepYogaGoal.value];
}

- (IBAction)stepWeightGoalAction:(id)sender {
    if ([Settings boolForKey:@"profileImperial"]) self.labelWeightGoal.text = [NSString stringWithFormat:@"Goal (%g lb)", self.stepWeightGoal.value];
    else self.labelWeightGoal.text = [NSString stringWithFormat:@"Goal (%g kg)", self.stepWeightGoal.value];
}

-(void)setTextFont {
    self.buttonReset.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.buttonRate.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0f] forKey:NSFontAttributeName];
    [self.segmentDistance setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.segmentWeightType setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.stepWaterUnits setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.labelSt1.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt5.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt6.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt7.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt8.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt9.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt10.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt11.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt12.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt13.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt14.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt15.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt16.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt17.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt18.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt19.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt20.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt21.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt22.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt23.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt24.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt25.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt26.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt27.font = [UIFont systemFontOfSize:18.0f];
}

- (IBAction)openStAction:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HeartFinishViewBoard"];
    secondViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:secondViewController animated:YES completion:nil];
}


@end
