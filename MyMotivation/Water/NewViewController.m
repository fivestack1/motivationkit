
#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

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
    
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    pickerData = [[NSMutableArray alloc] init];
    cval = 0;
    double ozml = 1;
    if ([Settings integerForKey:@"typeWaterUnits"] > 0) {
        ozml = oztoml;
    }
    for (int i = 1; i < 16; i++) {
        [pickerData addObject:[NSString stringWithFormat:@"%2.f", i*ozml]];
    }
    
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
    if (cval > 0) {
        if ([Settings integerForKey:@"typeWaterUnits"] > 0) {
            [self.dbManager saveWaterDataItem:cval/oztoml];
        }
        else {
            [self.dbManager saveWaterDataItem:cval];
        }
        
    }
    
    self.viewBack.hidden = false;
    
    [self showRainEffect];
    
}

/*-(void)showAds {
    if (self.interstitial.isReady) [self.interstitial presentFromRootViewController:self];
    else NSLog(@"Ad wasn't ready");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self showRainEffect];
}*/

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)[pickerData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"WaterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    /*UIImage *iconImage = [UIImage systemImageNamed:""];
    if (iconImage) {
        cell.imageView.image = iconImage;
        CGSize  itemSize = CGSizeMake(48, 48);
        UIGraphicsBeginImageContextWithOptions(itemSize, false, self.view.contentScaleFactor);
        CGRect  imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }*/
    
    cell.textLabel.font  = [UIFont fontWithName: @"Gotham-Book" size: 24.0];
    cell.textLabel.textColor = [UIColor labelColor];
    NSString *ctype = @" Oz";
    if ([Settings integerForKey:@"typeWaterUnits"] > 0) ctype = @" Ml";
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", pickerData[indexPath.row], ctype];
    cell.restorationIdentifier = [NSString stringWithFormat:@"%@", pickerData[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableMain deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cval = [cell.restorationIdentifier doubleValue];
}

-(void)setTextFont {
    self.labelTitle.font = [UIFont fontWithName:@"GothamBlack" size:30.0f];
    self.labelAward.font = [UIFont systemFontOfSize:25.0f];
    self.buttonOk.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.buttonBack.titleLabel.font = [UIFont systemFontOfSize:20.0f];
}

@end
