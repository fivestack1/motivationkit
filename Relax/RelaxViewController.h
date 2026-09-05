
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface RelaxViewController : UIViewController{
    NSMutableArray *json;
    AVAudioPlayer *myAudioPlayer;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;

@property (nonatomic) BOOL timerPause;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat timerCount;
@property (nonatomic) int timerValue;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (nonatomic, strong) DBManager *dbManager;

@end
