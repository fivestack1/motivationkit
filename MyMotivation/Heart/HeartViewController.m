#import "HeartViewController.h"

typedef NS_ENUM(NSUInteger, CURRENT_STATE) {
    STATE_PAUSED,
    STATE_SAMPLING
};

#define MIN_FRAMES_FOR_FILTER_TO_SETTLE 10

@interface HeartViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    CABasicAnimation *theAnimation;
}

@property (assign, nonatomic) CGFloat progress;

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *camera;
@property(nonatomic, strong) PulseDetector *pulseDetector;
@property(nonatomic, strong) Filter *filter;
@property(nonatomic, assign) CURRENT_STATE currentState;
@property(nonatomic, assign) int validFrameCounter;

@end

@implementation HeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"HEARTRATE";
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]} forState:UIControlStateSelected];
    
    self.tabBarController.tabBar.unselectedItemTintColor = [UIColor colorNamed:@"AccentColor"];
    
    synth = [[AVSpeechSynthesizer alloc] init];
    self.rateready = FALSE;
    self.timerPause = TRUE;
    
    [self exerciseProgress];
    
    isLoaded = FALSE;
    
    if (!test_device) {
        self.filter=[[Filter alloc] init];
        self.pulseDetector=[[PulseDetector alloc] init];
        [self startCameraCapture];
        isLoaded = TRUE;
    }
    
    [self setTextFont];
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
    
    self.rateready = FALSE;
    self.timerPause = TRUE;
    [self exerciseProgress];
    [self heartGraph];
    if (!test_device) {
        [self resume];
    }

}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.rateready = FALSE;
    self.timerPause = TRUE;
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    if (!test_device) {
        [graphView removeFromSuperview];
        [self stopCameraCapture];
    }
}

- (void)exerciseProgress {
    self.timerCount = 1400;
    self.timerValue = 20;
    self.progressValue = self.timerCount;
    _progress = 0.000001;
    [self.progressButton setProgress:self.progress];
    self.progressCircle.layer.masksToBounds = YES;
    self.progressCircle.layer.cornerRadius = self.progressCircle.frame.size.width / 2.0;
    self.progressBorder.layer.masksToBounds = YES;
    self.progressBorder.layer.cornerRadius = self.progressBorder.frame.size.width / 2.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(onTimer1) userInfo:nil repeats:YES];
}

- (void)heartGraph {
    graphView = [[GraphView alloc]initWithFrame:CGRectMake(-2, 1, self.viewPulseGraph.frame.size.width, self.viewPulseGraph.frame.size.height-1)];
    [graphView setBackgroundColor:[UIColor clearColor]];
    [graphView setSpacing:0];
    [graphView setFill:YES];
    [graphView setStrokeColor:main_color2];
    [graphView setZeroLineStrokeColor:[UIColor clearColor]];
    [graphView setFillColor:[UIColor clearColor]];
    [graphView setLineWidth:2];
    [graphView setCurvedLines:YES];
    [graphView hideAxis:YES];
    [self.viewPulseGraph addSubview:graphView];
    self.gvalue = 30;
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer2) userInfo:nil repeats:YES];
}

- (void)onTimer {
    if (!self.timerPause & self.rateready) {
        self.timerValue--;
        if ([Settings boolForKey:@"voiseCoundown"]) {
            if (self.timerValue == 3) {
                utterance = [AVSpeechUtterance speechUtteranceWithString:@"One"];
                utterance.rate = 0.5;
                [synth speakUtterance:utterance];
            }
            else if (self.timerValue == 4) {
                utterance = [AVSpeechUtterance speechUtteranceWithString:@"Two"];
                utterance.rate = 0.5;
                [synth speakUtterance:utterance];
            }
            else if (self.timerValue == 5) {
                utterance = [AVSpeechUtterance speechUtteranceWithString:@"Three"];
                utterance.rate = 0.5;
                [synth speakUtterance:utterance];
            }
        }
        if (self.timerValue < 1) {
            [self endCheckHeartRate];
        }
    }
}
- (void)onTimer1 {
    if (!self.timerPause & self.rateready) {
        self.progressValue--;
        if (self.progressValue>=0) {
            _progress += 1/self.timerCount;
            [self.progressButton setProgress:self.progress];
        }
    }
}
- (void)onTimer2 {
    if (!self.timerPause & self.rateready) {
        if (self.gvalue == 30) self.gvalue = -30;
        else self.gvalue = 30;
    }
    else {
        float low_bound = -2.00;
        float high_bound = 2.00;
        float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
        self.gvalue = (int)(rndValue + 0.5);
    }
    [graphView setPoint:self.gvalue];
}



- (void) resetTimers {
    [self.timer invalidate];
    self.timer = nil;
    [self.timer1 invalidate];
    self.timer1 = nil;
    [self.timer2 invalidate];
    self.timer2 = nil;
}

- (void) endCheckHeartRate {
    [self resetTimers];
    [synth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    synth = nil;
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HeartFinishViewBoard"];
    secondViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:secondViewController animated:YES completion:nil];
}



// start capturing frames
-(void) startCameraCapture {
    // Create the AVCapture Session
    self.session = [[AVCaptureSession alloc] init];
    
    // Get the default camera device
    self.camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn] & [self.camera hasFlash]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        
        [self.camera unlockForConfiguration];
    }
    
    // Create a AVCaptureInput with the camera device
    NSError *error=nil;
    AVCaptureInput* cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.camera error:&error];
    if (cameraInput == nil) {
        NSLog(@"Error to create camera capture:%@",error);
    }
    
    // Set the output
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // create a queue to run the capture on
    dispatch_queue_t captureQueue=dispatch_queue_create("captureQueue", NULL);
    
    // setup ourself up as the capture delegate
    [videoOutput setSampleBufferDelegate:self queue:captureQueue];
    
    // configure the pixel format
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey, nil];
    
    // set the minimum acceptable frame rate to 10 fps
    videoOutput.minFrameDuration=CMTimeMake(1, 10);
    
    // and the size of the frames we want - we'll use the smallest frame size available
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
    // Add the input and output
    [self.session addInput:cameraInput];
    [self.session addOutput:videoOutput];
    
    // Start the session
    [self.session startRunning];
    
    // we're now sampling from the camera
    //self.currentState=STATE_SAMPLING;
    
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // update our UI on a timer every 0.1 seconds
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
}

-(void) stopCameraCapture {
    [self.session stopRunning];
    self.session=nil;
}


#pragma mark Pause and Resume of pulse detection
-(void) pause {
    if(self.currentState==STATE_PAUSED) return;
    
    // switch off the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn] & [self.camera hasFlash]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOff;
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_PAUSED;
    // let the application go to sleep if the phone is idle
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    theAnimation=nil;
}

-(void) resume {
    if(self.currentState!=STATE_PAUSED) return;
    
    // switch on the torch
    if([self.camera isTorchModeSupported:AVCaptureTorchModeOn] & [self.camera hasFlash]) {
        [self.camera lockForConfiguration:nil];
        self.camera.torchMode=AVCaptureTorchModeOn;
        [self.camera unlockForConfiguration];
    }
    self.currentState=STATE_SAMPLING;
    // stop the app from sleeping
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

// r,g,b values are from 0 to 1 // h = [0,360], s = [0,1], v = [0,1]
//    if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        // r = g = b = 0
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h=2+(b-r)/delta;
    else
        *h=4+(r-g)/delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

// process the frame of video
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    // if we're paused don't do anything
    if(self.currentState==STATE_PAUSED) {
        // reset our frame counter
        self.validFrameCounter=0;
        return;
    }
    // this is the image buffer
    CVImageBufferRef cvimgRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the image buffer
    CVPixelBufferLockBaseAddress(cvimgRef,0);
    // access the data
    size_t width=CVPixelBufferGetWidth(cvimgRef);
    size_t height=CVPixelBufferGetHeight(cvimgRef);
    // get the raw image bytes
    uint8_t *buf=(uint8_t *) CVPixelBufferGetBaseAddress(cvimgRef);
    size_t bprow=CVPixelBufferGetBytesPerRow(cvimgRef);
    // and pull out the average rgb value of the frame
    float r=0,g=0,b=0;
    for(int y=0; y<height; y++) {
        for(int x=0; x<width*4; x+=4) {
            b+=buf[x];
            g+=buf[x+1];
            r+=buf[x+2];
        }
        buf+=bprow;
    }
    r/=255*(float) (width*height);
    g/=255*(float) (width*height);
    b/=255*(float) (width*height);
    // convert from rgb to hsv colourspace
    float h,s,v;
    RGBtoHSV(r, g, b, &h, &s, &v);
    // do a sanity check to see if a finger is placed over the camera
    if(s>0.5 && v>0.5) {
        // increment the valid frame count
        self.validFrameCounter++;
        // filter the hue value - the filter is a simple band pass filter that removes any DC component and any high frequency noise
        float filtered=[self.filter processValue:h];
        // have we collected enough frames for the filter to settle?
        if(self.validFrameCounter > MIN_FRAMES_FOR_FILTER_TO_SETTLE) {
            // add the new value to the pulse detector
            [self.pulseDetector addNewValue:filtered atTime:CACurrentMediaTime()];
        }
    } else {
        self.validFrameCounter = 0;
        // clear the pulse detector - we only really need to do this once, just before we start adding valid samples
        [self.pulseDetector reset];
    }
    
}


-(void) update {
    
    self.labelReady.text = [NSString stringWithFormat:@"Ready %d%%", MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE)];
    
    if (MIN(100, (100 * self.validFrameCounter)/MIN_FRAMES_FOR_FILTER_TO_SETTLE) > 99) {
        if (theAnimation == nil) {
            [self animateHeart];
        }
    }
    
    // if we're paused then there's nothing to do
    if(self.currentState==STATE_PAUSED) return;
    
    // get the average period of the pulse rate from the pulse detector
    float avePeriod=[self.pulseDetector getAverage];
    if(avePeriod==INVALID_PULSE_PERIOD) {
        // no value available
        self.pulseRate.text=@"00";
        self.rateready = FALSE;
        
    } else {
        // got a value so show it
        float pulse=60.0/avePeriod;
        [Settings setInteger:pulse forKey:@"currentRate"];
        [Settings synchronize];
        self.pulseRate.text=[NSString stringWithFormat:@"%0.0f", pulse];
        self.rateready = TRUE;
    }
    
}

- (void) animateHeart{
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.8];
    [self.heartImg.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    self.timerPause = FALSE;
}

-(void)setTextFont {
    self.pulseRate.font = [UIFont systemFontOfSize:55.0f];
    self.labelReady.font = [UIFont systemFontOfSize:20.0f];
    
    self.labelSt1.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:20.0f];
}

@end
