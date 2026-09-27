
#import "StepsFinishViewController.h"

@interface StepsFinishViewController (){
    long wsteps;
}

@end

@implementation StepsFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    synth = [[AVSpeechSynthesizer alloc] init];
    wsteps = [Settings integerForKey:@"workoutSteps"];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    self.labelTotal.text = [NSString stringWithFormat:@"TOTAL STEPS %ld",wsteps];
    
    [self setTextFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)buttonShareAction:(id)sender {
    NSString *message = [NSString stringWithFormat:@"TOTAL STEPS %ld",wsteps];
    NSArray *postItems = @[message];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)buttonHomeAction:(id)sender {
    if (wsteps > 0) {
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        [self.dbManager saveStepsDataItem:dateString ontime:[Settings integerForKey:@"workoutStepsTime"] ondistance:[Settings doubleForKey:@"workoutStepsDistance"] onsteps:wsteps onfloors:[Settings integerForKey:@"workoutStepsFloors"]];
        
    }
    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont fontWithName:@"GothamBlack" size:28.0f];
    self.labelAward.font = [UIFont systemFontOfSize:24.0f];
    self.labelTotal.font = [UIFont systemFontOfSize:24.0f];
}

@end
