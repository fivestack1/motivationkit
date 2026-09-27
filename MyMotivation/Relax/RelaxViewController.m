
#import "RelaxViewController.h"


@implementation RelaxViewController {
    NSArray *recipes;
    long todayValue;
    long workout;
    long currentsound;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*self.navigationController.navigationBar.barTintColor = blue_color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"RELAX SOUNDS";*/
    self.navigationController.navigationBar.topItem.title = @"RELAX SOUNDS";
    
    //if (IS_IPHONEX) {
        //self.topProgressView.frame = CGRectMake(self.topProgressView.frame.origin.x, self.topProgressView.frame.origin.y+84, self.topProgressView.frame.size.width, self.topProgressView.frame.size.height-84);
        //self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y+24, self.bottomView.frame.size.width, self.bottomView.frame.size.height-24);
        
        //float tpsize = (self.viewProgress.frame.size.height-self.labelGoal.frame.size.height-30);
        //float tpsize = [[UIScreen mainScreen] bounds].size.width-80;
        //self.topProgressView.frame = CGRectMake((self.topProgressView.frame.size.width/2)-(tpsize/2), (self.topProgressView.frame.size.height/2+self.labelGoal.frame.size.height)-(tpsize/2), tpsize, tpsize);
    //}
    
    
    currentsound = 0;
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"sounds" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    json = [[NSMutableArray alloc] init];
    json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
    [self refreshSoundsView];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    todayValue = 0;
    [self exerciseProgress];
    
    [self setPlayer];
    
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [myAudioPlayer stop];
    if ((self.timerValue - todayValue) > 60) [self.dbManager saveRelaxDataItem:self.timerValue onval:workout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.timerValue = [self.dbManager loadRelaxTopItems];
    todayValue = [self.dbManager loadRelaxTopItems];
    [self updateLabels];
}


- (void) refreshSoundsView {
    self.viewMain.frame = CGRectMake(0, 0, self.scrollMain.frame.size.width, (([json count] * 108)+8));
    [self.scrollMain setScrollEnabled:YES];
    [self.scrollMain setContentSize:CGSizeMake(self.scrollMain.frame.size.width, self.viewMain.frame.size.height)];
    
    int coffset = 8;
    for (int i = 0; i < [json count]; i++) {
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(8, coffset, self.viewMain.frame.size.width-16, 100)];
        wView.backgroundColor = [UIColor whiteColor];
        wView.layer.masksToBounds = YES;
        wView.layer.cornerRadius = 10.0f;
        
        UIImageView *pic =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.viewMain.frame.size.width-16,100)];
        //pic.image=[UIImage imageNamed:[[json objectAtIndex:i] objectForKey:@"picture"]];
        NSString *fileP = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", [[json objectAtIndex:i] objectForKey:@"picture"]] ofType:@"jpg"];
        pic.image = [UIImage imageWithContentsOfFile:fileP];
        pic.contentMode = UIViewContentModeScaleAspectFill;
        [wView addSubview:pic];
        
        UILabel *wLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 25, wView.frame.size.width-32, 50)];
        wLabel.textColor = [UIColor whiteColor];
        wLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:28.0];
        wLabel.text = [[json objectAtIndex:i] objectForKey:@"name"];
        [wView addSubview:wLabel];
        
        UIButton *wButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wButton addTarget:self action:@selector(buttonStartSound:) forControlEvents:UIControlEventTouchUpInside];
        [wButton setTitle:@"" forState:UIControlStateNormal];
        //wButton.layer.masksToBounds = YES;
        //wButton.layer.borderWidth = 2.0f;
        //wButton.layer.cornerRadius = 10.0f;
        //if (i == 0) wButton.layer.borderColor = red_color.CGColor;
        //else wButton.layer.borderColor = [UIColor clearColor].CGColor;
        wButton.frame = CGRectMake(0, 0, wView.frame.size.width, wView.frame.size.height);
        wButton.restorationIdentifier = [NSString stringWithFormat:@"%d",i];
        [wView addSubview:wButton];
        
        [self.viewMain addSubview:wView];
        coffset = coffset+108;
    }
    
}

- (void) buttonStartSound:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    currentsound = [resultButton.restorationIdentifier intValue];
    [self changeSound];
}

-(void) setPlayer {
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", [[json objectAtIndex:currentsound] objectForKey:@"file"]] ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    
    myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    myAudioPlayer.numberOfLoops = -1;
    myAudioPlayer.volume = 0.5f;
    [myAudioPlayer prepareToPlay];
    
    
}


-(void) changeSound {
    [myAudioPlayer stop];
    [self setPlayer];
    [myAudioPlayer play];
    self.timerPause = FALSE;
    [self.buttonPlay setBackgroundImage:[UIImage systemImageNamed:@"pause.circle"] forState: UIControlStateNormal];
    self.labelTitle.text = [NSString stringWithFormat:@"%@", [[json objectAtIndex:currentsound] objectForKey:@"name"]];
}

- (void)exerciseProgress {
    //self.timerValue = 0;
    self.timerValue = [self.dbManager loadRelaxTopItems];
    self.timerPause = TRUE;
    
    [self setCounter];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)updateLabels {
    self.labelTitle.text = [NSString stringWithFormat:@"%@", [[json objectAtIndex:currentsound] objectForKey:@"name"]];
    int goal = (fmod(fmod(((int)[Settings integerForKey:@"stepRelaxGoal"]-self.timerValue), 86400), 3600) / 60);
    self.labelLeft.text = [NSString stringWithFormat:@"%d minutes left to reach daily goal", goal];
}

- (void)onTimer {
    if (!self.timerPause) {
        self.timerValue++;
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        
        int goal = (fmod(fmod(((int)[Settings integerForKey:@"stepRelaxGoal"]-self.timerValue), 86400), 3600) / 60);
        self.labelLeft.text = [NSString stringWithFormat:@"%d minutes left to reach daily goal", goal];
        
        
    }
}

-(void) setCounter {
    if (self.timerValue > 0) {
        int seconds = fmod(fmod(fmod(self.timerValue, 86400), 3600), 60);
        int minutes = (fmod(fmod(self.timerValue, 86400), 3600) / 60);
        int hours = fmod(self.timerValue, 86400) / 3600;
        self.progressLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
}

- (IBAction)buttonPlayAction:(id)sender {
    if (([Settings integerForKey:@"freeLimit"] < free_limit) || [Settings boolForKey:@"proActivated"]) {
        if (self.timerPause) {
            self.timerPause = FALSE;
            [myAudioPlayer play];
            [self.buttonPlay setBackgroundImage:[UIImage systemImageNamed:@"pause.circle"] forState: UIControlStateNormal];
            self.labelTitle.text = [NSString stringWithFormat:@"%@", [[json objectAtIndex:currentsound] objectForKey:@"name"]];
        }
        else {
            self.timerPause = TRUE;
            [myAudioPlayer pause];
            [self.buttonPlay setBackgroundImage:[UIImage systemImageNamed:@"play.circle"] forState: UIControlStateNormal];
            self.labelTitle.text = [NSString stringWithFormat:@"%@ - paused", [[json objectAtIndex:currentsound] objectForKey:@"name"]];
        }
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Free limit" message:@"Unlock Pro version in Settings to remove limit" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)buttonStopAction:(id)sender {
    [myAudioPlayer stop];
    [self.buttonPlay setBackgroundImage:[UIImage systemImageNamed:@"play.circle"] forState: UIControlStateNormal];
    self.timerPause = TRUE;
}

- (IBAction)buttonPrevAction:(id)sender {
    if (currentsound == 0) currentsound = [json count]-1;
    else currentsound--;
    [self changeSound];
}
- (IBAction)buttonNextAction:(id)sender {
    if (currentsound >= ([json count]-1)) currentsound = 0;
    else currentsound++;
    [self changeSound];
}


@end
