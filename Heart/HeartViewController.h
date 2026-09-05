
#import <UIKit/UIKit.h>
#import "GlobalState.h"
//#import "DBManager.h"
#import <AVFoundation/AVFoundation.h>
#import "GraphView.h"
#import "UIView+LSPieProgress.h"
#import "PulseDetector.h"
#import "Filter.h"

@interface HeartViewController : UIViewController{
    AVSpeechUtterance *utterance;
    AVSpeechSynthesizer *synth;
    GraphView *graphView;
    BOOL isLoaded;
}

@property (strong, nonatomic) GraphView *graphView;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *timer1;
@property (nonatomic) NSTimer *timer2;
@property (nonatomic) BOOL timerPause;
@property (nonatomic) BOOL rateready;
@property (nonatomic) BOOL ratefinish;
@property (nonatomic) int timerValue;
@property (nonatomic) int progressValue;
@property (nonatomic) CGFloat timerCount;
@property (nonatomic) int gvalue;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UIButton *progressCircle;
@property (weak, nonatomic) IBOutlet UILabel *progressBorder;
@property (weak, nonatomic) IBOutlet UIImageView *heartImg;
@property (weak, nonatomic) IBOutlet UILabel *labelReady;
@property(nonatomic, strong) IBOutlet UILabel *pulseRate;
@property (weak, nonatomic) IBOutlet UIView *viewPulseGraph;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;

@end

