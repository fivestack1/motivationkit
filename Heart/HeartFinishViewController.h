
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GlobalState.h"
#import "DBManager.h"


@interface HeartFinishViewController : UIViewController {
    AVSpeechUtterance *utterance;
    AVSpeechSynthesizer *synth;
    int crate;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
- (IBAction)buttonSaveAction:(id)sender;
- (IBAction)buttonShareAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelCurrentRate;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
