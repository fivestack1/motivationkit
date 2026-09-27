
#import "HeartFinishViewController.h"

@interface HeartFinishViewController ()

@end

@implementation HeartFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    synth = [[AVSpeechSynthesizer alloc] init];
    self.dbManager = [[DBManager alloc] initDatabase];
    
    crate = (int)[Settings integerForKey:@"currentRate"];

    self.labelCurrentRate.text = [NSString stringWithFormat:@"%d bpm", crate];
    
    if ([Settings boolForKey:@"voiseHeart"]) [self performSelector:@selector(sayHeartbeat) withObject:nil afterDelay:1];
    
    [self setTextFont];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    synth = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sayHeartbeat {
    synth = [[AVSpeechSynthesizer alloc] init];
    utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"Heart rate is %d ", crate]];
    utterance.rate = 0.5;
    [synth speakUtterance:utterance];
    if ([Settings boolForKey:@"kSystemSoundID_Vibrate"]) { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); }
}

- (IBAction)buttonSaveAction:(id)sender {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy (hh:mm)"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    [self.dbManager saveHeartDataItem:dateString onrate:crate ontype:8];
    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonShareAction:(id)sender {
    NSString *message = @"";
    message = [NSString stringWithFormat:@"My Heart Rate is %d bpm", crate];
    NSArray *postItems = @[message];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.labelCurrentRate.font = [UIFont systemFontOfSize:45.0f];
}

@end
