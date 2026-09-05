
#import "RunWorkoutViewController.h"

@interface RunWorkoutViewController ()

@end

@implementation RunWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonStart.layer.masksToBounds = YES;
    self.buttonStart.layer.cornerRadius = self.buttonStart.frame.size.width / 15.0;
    
    self.buttonExitYes.layer.masksToBounds = YES;
    self.buttonExitYes.layer.cornerRadius = self.buttonExitYes.frame.size.width / 15.0;
    
    self.buttonExitNo.layer.masksToBounds = YES;
    self.buttonExitNo.layer.cornerRadius = self.buttonExitNo.frame.size.width / 15.0;
    
    self.timerPause = FALSE;
    
    countDis = 0;
    isMile = 1;
    minspeed = 0;
    maxspeed = 0;
    aspeed = 0;
    sp1 = 0;
    sp2 = 0;
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) isMile = 0.621371;
    run_locations = [NSMutableArray array];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = 10; // meters
    self.locationManager.pausesLocationUpdatesAutomatically = FALSE;
    self.locationManager.allowsBackgroundLocationUpdates = TRUE;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.mapViewRun.delegate = self;
    [self.mapViewRun setShowsUserLocation:YES];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapViewRun regionThatFits:viewRegion];
    [self.mapViewRun setRegion:adjustedRegion animated:YES];
    self.mapViewRun.showsUserLocation = YES;
    
    [self exerciseProgress];
    
    /*if (IS_IPHONEX) {
        self.viewMain.frame = CGRectMake(0, self.viewMain.frame.origin.y+24, self.viewMain.frame.size.width, self.viewMain.frame.size.height-24);
    }*/
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) self.labelDistanceType.text = @"miles";
    else self.labelDistanceType.text = @"kilometers";
    
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    self.labelDate.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:today]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    [self.locationManager stopUpdatingLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)exerciseProgress {
    
    self.timerValue = 0;
    
    /*if (IS_IPAD) {
        self.viewProgress.frame = CGRectMake(self.viewProgress.frame.origin.x, (self.viewTimer.frame.size.height/2) - (self.viewProgress.frame.size.height/2), self.viewProgress.frame.size.width, self.viewProgress.frame.size.height);
    }
    if (IS_IPHONEX) {
        self.viewProgress.frame = CGRectMake(self.viewProgress.frame.origin.x, (self.viewTimer.frame.size.height/2) - (self.viewProgress.frame.size.height/2)-20, self.viewProgress.frame.size.width, self.viewProgress.frame.size.height);
    }*/
    
    self.timerPause = TRUE;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)updateLabels {
    if (countDis > 0) {
        float avgspeed = self.timerValue/countDis;
        if (sp1 == 0) sp1 = avgspeed;
        else {
            if (avgspeed <= sp1) sp1 = avgspeed;
        }
        if (avgspeed >= sp2) sp2 = avgspeed;
        float units = 1000;
        if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) units = 1609.344;
        int paceMin = (int) ((avgspeed * units) / 60);
        int paceSec = (int) (avgspeed * units - (paceMin*60));
        self.labelSpeed.text = [NSString stringWithFormat:@"%i:%02i min/%@", paceMin, paceSec, [Settings objectForKey:@"checkDistance"]];
        
        int paceMin1 = (int) ((sp1 * units) / 60);
        int paceSec1 = (int) (sp1 * units - (paceMin1*60));
        self.labelMinSpeed.text = [NSString stringWithFormat:@"%i:%02i min/%@", paceMin1, paceSec1, [Settings objectForKey:@"checkDistance"]];
        
        int paceMin2 = (int) ((sp2 * units) / 60);
        int paceSec2 = (int) (sp2 * units - (paceMin2*60));
        self.labelMaxSpeed.text = [NSString stringWithFormat:@"%i:%02i min/%@", paceMin2, paceSec2, [Settings objectForKey:@"checkDistance"]];
        
        self.labelCalories.text = [NSString stringWithFormat:@"%d", (int)(countDis*0.04)];
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f", (countDis/1000)*isMile];
    }
}

- (void)onTimer {
    if (!self.timerPause) {
        self.timerValue++;
        self.labelTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(self.timerValue/3600),((self.timerValue/60)%60),(self.timerValue%60)];
        //[self updateLabels];
    }
    
}

- (IBAction)buttonStartAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.messageReady.alpha = 0.0;} completion:^(BOOL finished) {
        self.messageReady.hidden = TRUE;
        self.timerPause = FALSE;
    }];
}

- (IBAction)buttonExitYesAction:(id)sender {
    [self.locationManager stopUpdatingLocation];
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonReturnAction:(id)sender {
    [self.locationManager stopUpdatingLocation];
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonExitNoAction:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.viewExit.alpha = 0.0;} completion:^(BOOL finished) {
        self.viewExit.hidden = TRUE;
        self.timerPause = FALSE;
    }];
}

- (IBAction)buttonStopAction:(id)sender {
    if ((minspeed >= 0) && (maxspeed > 0)) {
        aspeed = (maxspeed+minspeed)/2;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ready" message:@"Do you want to finish?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel action");
        self.timerPause = FALSE;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.locationManager stopUpdatingLocation];
        [self.timer invalidate];
        self.timer = nil;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationRunSuccess"];
        RunSuccessViewController *controller = (RunSuccessViewController *)navController.topViewController;
        controller.disCount = self->countDis;
        controller.secCount = self.timerValue;
        controller.minCount = self->minspeed;
        controller.maxCount = self->maxspeed;
        controller.avgCount = self->aspeed;
        [self presentViewController:navController animated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    self.timerPause = TRUE;
    if ([Settings boolForKey:@"checkVibration"]) { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); }
}

- (IBAction)buttonCloseAction:(id)sender {
    self.viewExit.hidden = FALSE;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{self.viewExit.alpha = 1.0;} completion:^(BOOL finished) {
        self.timerPause = TRUE;
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.timerPause) {
        for (CLLocation *newLocation in locations) {
            
            NSDate *eventDate = newLocation.timestamp;
            
            
            NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
            if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
                
                // update distance
                if (run_locations.count > 0) {
                    countDis += [newLocation distanceFromLocation:run_locations.lastObject];
                    
                    if (newLocation.speed >= maxspeed) maxspeed = newLocation.speed;
                    if (minspeed == 0) minspeed = newLocation.speed;
                    else {
                        if (newLocation.speed <= minspeed) minspeed = newLocation.speed;
                    }
                    
                    CLLocationCoordinate2D coords[2];
                    coords[0] = ((CLLocation *)run_locations.lastObject).coordinate;
                    coords[1] = newLocation.coordinate;
                    
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                    [self.mapViewRun setRegion:region animated:YES];
                    [self.mapViewRun addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
                    
                    [self updateLabels];
                }
                
                [run_locations addObject:newLocation];
            }
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
        
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error retrieving location" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { NSLog(@"Cancel action"); }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = main_color2;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.labelSt2.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.buttonStart.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    self.buttonExitNo.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    self.buttonExitYes.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    
    self.progressLabel.font = [UIFont systemFontOfSize:75.0f];
    self.labelDistanceType.font = [UIFont systemFontOfSize:22.0f];
    self.labelTime.font = [UIFont systemFontOfSize:18.0f];
    self.labelCalories.font = [UIFont systemFontOfSize:18.0f];
    self.labelDate.font = [UIFont systemFontOfSize:18.0f];
    self.labelSpeed.font = [UIFont systemFontOfSize:18.0f];
    self.labelMaxSpeed.font = [UIFont systemFontOfSize:18.0f];
    self.labelMinSpeed.font = [UIFont systemFontOfSize:18.0f];
    
    self.labelSt3.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt5.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt6.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt7.font = [UIFont systemFontOfSize:17.0f];
    self.labelSt8.font = [UIFont systemFontOfSize:17.0f];
}


@end
