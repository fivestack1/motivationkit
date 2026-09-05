
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface StepsFinishViewController : UIViewController {
    AVSpeechUtterance *utterance;
    AVSpeechSynthesizer *synth;
}

- (IBAction)buttonShareAction:(id)sender;
- (IBAction)buttonHomeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelAward;
@property (weak, nonatomic) IBOutlet UILabel *labelTotal;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
