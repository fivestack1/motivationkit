
#import "YogaSuccessViewController.h"

@interface YogaSuccessViewController ()

@end

@implementation YogaSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showRainEffect];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    self.rateCount = 10;
    
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
    NSArray *confettiColors = @[[UIColor redColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor]];
    
    
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
    if (self.isMedt) {
        //[self.dbManager updateYogaItem:0 onwname:@"Meditation" onwdate:[[dateFormat stringFromDate:today] substringToIndex:10] onwseconds:[Settings integerForKey:@"stepYogaMeditation"] onwhappy:self.rateCount onwenergies:meditation_energies onwid:0 onwtitle:@"Meditation" onwtime:[[dateFormat stringFromDate:today] substringWithRange:NSMakeRange(11, 7)]];
        [self.dbManager updateYogaItem:0 onwname:@"Meditation" onwdate:[dateFormat stringFromDate:today] onwseconds:[Settings integerForKey:@"stepYogaMeditation"] onwhappy:self.rateCount onwenergies:meditation_energies onwid:0 onwtitle:@"Meditation" onwtime:[[dateFormat stringFromDate:today] substringWithRange:NSMakeRange(11, 7)]];
    }
    else {
        NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"ydata" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
        NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
        json = [[NSMutableArray alloc] init];
        json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
        //[self.dbManager updateYogaItem:1 onwname:@"Exercise" onwdate:[[dateFormat stringFromDate:today] substringToIndex:10] onwseconds:[Settings integerForKey:@"stepYogaExercise"] onwhappy:self.rateCount onwenergies:yoga_energies onwid:[[[json objectAtIndex:self.exCount] objectForKey:@"id"] intValue] onwtitle:[[json objectAtIndex:self.exCount] objectForKey:@"name"] onwtime:[[dateFormat stringFromDate:today] substringWithRange:NSMakeRange(11, 5)]];
        [self.dbManager updateYogaItem:1 onwname:@"Exercise" onwdate:[dateFormat stringFromDate:today] onwseconds:[Settings integerForKey:@"stepYogaExercise"] onwhappy:self.rateCount onwenergies:yoga_energies onwid:[[[json objectAtIndex:self.exCount] objectForKey:@"id"] intValue] onwtitle:[[json objectAtIndex:self.exCount] objectForKey:@"name"] onwtime:[[dateFormat stringFromDate:today] substringWithRange:NSMakeRange(11, 5)]];
    }
    [Settings setBool:FALSE forKey:@"typeYogaMeditation"];
    [Settings synchronize];
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonShareAction:(id)sender {
    NSArray *postItems = @[share_string];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)buttonStarAction1:(id)sender {
    self.rateCount = 2;
    [self setRating:1];
}

- (IBAction)buttonStarAction2:(id)sender {
    self.rateCount = 4;
    [self setRating:2];
}

- (IBAction)buttonStarAction3:(id)sender {
    self.rateCount = 6;
    [self setRating:3];
}

- (IBAction)buttonStarAction4:(id)sender {
    self.rateCount = 8;
    [self setRating:4];
}

- (IBAction)buttonStarAction5:(id)sender {
    self.rateCount = 10;
    [self setRating:5];
}

- (void) setRating:(int)curr {
    if (curr == 1) {
        [self.buttonStar1 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar2 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar3 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar4 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar5 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
    }
    else if (curr == 2) {
        [self.buttonStar1 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar2 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar3 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar4 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar5 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
    }
    else if (curr == 3) {
        [self.buttonStar1 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar2 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar3 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar4 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
        [self.buttonStar5 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
    }
    else if (curr == 4) {
        [self.buttonStar1 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar2 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar3 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar4 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar5 setBackgroundImage:[UIImage systemImageNamed:@"star"] forState: UIControlStateNormal];
    }
    else if (curr == 5) {
        [self.buttonStar1 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar2 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar3 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar4 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
        [self.buttonStar5 setBackgroundImage:[UIImage systemImageNamed:@"star.fill"] forState: UIControlStateNormal];
    }
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.labelAward.font = [UIFont systemFontOfSize:30.0f];
    self.labelRate.font = [UIFont systemFontOfSize:24.0f];
}

@end
