
#import "SuccessViewController.h"

@interface SuccessViewController ()

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self showRainEffect];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    NSInteger cti = [self.dbManager countTotalItems];
    if ((cti == 1) || (cti == 5) || (cti == 10) || (cti == 45) || (cti == 20) || (cti == 25) || (cti == 35) || (cti == 50)) {
        [Settings setInteger:([Settings integerForKey:@"rewardCurrent"]+1) forKey:@"rewardCurrent"];
        [Settings synchronize];
        
        self.labelAward.hidden = FALSE;
        
        if ([Settings integerForKey:@"rewardCurrent"] > 0) {
            self.labelAward.text = award1;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 1) {
            self.labelAward.text = award2;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 2) {
            self.labelAward.text = award3;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 3) {
            self.labelAward.text = award4;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 4) {
            self.labelAward.text = award5;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 5) {
            self.labelAward.text = award6;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 6) {
            self.labelAward.text = award7;
        }
        if ([Settings integerForKey:@"rewardCurrent"] > 7) {
            self.labelAward.text = award8;
        }
    }
    
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


- (void) showRainEffect {
    // How many pieces to generate
    int confettiCount = 200;
    
    // What colors should the pieces be?
    NSArray *confettiColors = @[[UIColor redColor], [UIColor systemGreenColor], [UIColor yellowColor], [UIColor blueColor]];
    
    
    // Everything else that you can configure
    int screenWidth = self.view.frame.size.width;
    int screenHeight = self.view.frame.size.height;
    int randomStartPoint;
    int randomStartConfettiLength;
    int randomEndConfettiLength;
    int randomEndPoint;
    int randomDelayTime;
    int randomFallTime;
    int randomRotation;
    
    for (int i = 0; i < confettiCount; i++){
        randomStartPoint = arc4random_uniform(screenWidth);
        randomEndPoint = arc4random_uniform(screenWidth);
        randomDelayTime = arc4random_uniform(100);
        randomFallTime = arc4random_uniform(3);
        randomRotation = arc4random_uniform(360);
        randomStartConfettiLength = arc4random_uniform(15);
        randomEndConfettiLength = arc4random_uniform(15);
        NSUInteger randomColor = arc4random() % [confettiColors count];
        
        UIView *confetti=[[UIView alloc]initWithFrame:CGRectMake(randomStartPoint, -10, randomStartConfettiLength, 8)];
        [confetti setBackgroundColor:confettiColors[randomColor]];
        confetti.alpha = .4;
        [self.view addSubview:confetti];
        
        [UIView animateWithDuration:randomFallTime+5 delay:randomDelayTime*.1 options:UIViewAnimationOptionRepeat animations:^{
            [confetti setFrame:CGRectMake(randomEndPoint, screenHeight+30, randomEndConfettiLength, 8)];
            confetti.transform = CGAffineTransformMakeRotation(randomRotation);
        } completion:nil];
    }
}

- (IBAction)buttonHomeAction:(id)sender {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    //NSString *dateString = [dateFormat stringFromDate:today];
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    json = [[NSMutableArray alloc] init];
    json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
    //[self.dbManager updateItem:self.wId onwtype:self.wId onwname:self.wType onwdate:[[dateFormat stringFromDate:today] substringToIndex:10] onwexercises:self.exCount onwcalories:self.calCount onwtime:(self.exCount*[Settings integerForKey:@"stepExercise"])];
    [self.dbManager updateItem:self.wId onwtype:self.wId onwname:self.wType onwdate:[dateFormat stringFromDate:today] onwexercises:self.exCount onwcalories:self.calCount onwtime:(self.exCount*[Settings integerForKey:@"stepExercise"])];
    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonShareAction:(id)sender {
    NSArray *postItems = @[share_string];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont fontWithName:@"GothamBlack" size:28.0f];
    self.labelAward.font = [UIFont systemFontOfSize:24.0f];
}

@end
