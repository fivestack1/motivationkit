
#import "WeightNewViewController.h"

@interface WeightNewViewController ()

@end

@implementation WeightNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonOk.layer.masksToBounds = YES;
    self.buttonOk.layer.cornerRadius = self.buttonOk.frame.size.height / 5;
    
    self.buttonBack.layer.masksToBounds = YES;
    self.buttonBack.layer.cornerRadius = self.buttonBack.frame.size.height / 5;
    
    self.textWeightValue.layer.cornerRadius = self.textWeightValue.frame.size.height / 5.0;
    self.textWeightValue.layer.borderWidth = 1.0f;
    self.textWeightValue.layer.borderColor = [light_color CGColor];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
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



- (IBAction)buttonOkAction:(id)sender {
    if ([self.textWeightValue.text length] > 0) {
        if ([Settings boolForKey:@"profileImperial"]) {
            cval = [self.textWeightValue.text floatValue]*lbtokg;
        }
        else {
            cval = [self.textWeightValue.text floatValue];
        }
        
        if (cval > 0) { [self.dbManager saveWeightDataItem:cval]; }
    
        self.viewBack.hidden = false;
    
        [self showRainEffect];
    }
    
}

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

- (IBAction)buttonCloseAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setTextFont {
    self.buttonBack.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.buttonOk.titleLabel.font = [UIFont systemFontOfSize:20.0f];
}

@end
