
#import "StepsHistoryViewController.h"

@interface StepsHistoryViewController ()

@end

@implementation StepsHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isMile = 1;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) isMile = 0.621371;
    else isMile = 1;
    [self clearMainView];
    arrayWorkouts = [self.dbManager loadStepsAllItems:@""];
    if ((int)[arrayWorkouts count] > 0) {
        [self refreshActivityView];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) refreshActivityView {
    /*if (IS_IPHONEX) {
        self.scrollMain.frame = CGRectMake(0, 88, self.scrollMain.frame.size.width, self.scrollMain.frame.size.height);
    }*/
    self.viewMain.frame = CGRectMake(0, 0, self.scrollMain.frame.size.width, (((int)[arrayWorkouts count] * 118)+16));
    [self.scrollMain setScrollEnabled:YES];
    [self.scrollMain setContentSize:CGSizeMake(self.scrollMain.frame.size.width, self.viewMain.frame.size.height)];
    
    int coffset = 8;
    int dc = (int)[arrayWorkouts count];
    for (int i = 0; i < (int)[arrayWorkouts count]; i++)
    {
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(8, coffset, self.viewMain.frame.size.width-16, 110)];
        //wView.backgroundColor = [self colorWithHexString:@"#f9f9f9" alpha:1.0];
        wView.layer.masksToBounds = YES;
        wView.layer.cornerRadius = 10.0f;
        
        UIView *wleftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 110)];
        wleftView.backgroundColor = [UIColor whiteColor];
        [wView addSubview:wleftView];
        
        UILabel *wLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, wleftView.frame.size.width-8, 40)];
        wLabel1.textColor = [UIColor labelColor];
        wLabel1.font = [UIFont systemFontOfSize:18.0];
        wLabel1.text = [NSString stringWithFormat:@"Walk #%d",dc];
        [wleftView addSubview:wLabel1];
        
        UILabel *wLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(108, 8, wView.frame.size.width-116, 40)];
        wLabel4.textColor = [UIColor systemGreenColor];
        wLabel4.font = [UIFont systemFontOfSize:18.0];
        wLabel4.text = arrayWorkouts[i][1];
        [wView addSubview:wLabel4];
        
        UILabel *wLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(108, 50, 80, 25)];
        wLabel5.textColor = [UIColor labelColor];
        wLabel5.font = [UIFont systemFontOfSize:15.0];
        wLabel5.text = @"Distance";
        [wView addSubview:wLabel5];
        
        UILabel *wLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(189, 50, 80, 25)];
        wLabel6.textColor = [UIColor labelColor];
        wLabel6.font = [UIFont systemFontOfSize:15.0];
        wLabel6.text = @"Steps";
        [wView addSubview:wLabel6];
        
        UILabel *wLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(271, 50, 80, 25)];
        wLabel7.textColor = [UIColor labelColor];
        wLabel7.font = [UIFont systemFontOfSize:15.0];
        wLabel7.text = @"Time";
        [wView addSubview:wLabel7];
        
        
        UILabel *wLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(108, 77, 80, 25)];
        wLabel8.textColor = [UIColor systemGreenColor];
        wLabel8.font = [UIFont systemFontOfSize:15.0];
        wLabel8.text = [NSString stringWithFormat:@"%.2f%@", ([arrayWorkouts[i][3] floatValue]/1000)*isMile, [Settings objectForKey:@"checkDistance"]];
        [wView addSubview:wLabel8];
        
        UILabel *wLabel9 = [[UILabel alloc] initWithFrame:CGRectMake(189, 77, 80, 25)];
        wLabel9.textColor = [UIColor systemGreenColor];
        wLabel9.font = [UIFont systemFontOfSize:15.0];
        wLabel9.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[i][4] intValue]];
        [wView addSubview:wLabel9];
        
        UILabel *wLabel10 = [[UILabel alloc] initWithFrame:CGRectMake(271, 77, 80, 25)];
        wLabel10.textColor = [UIColor systemGreenColor];
        wLabel10.font = [UIFont systemFontOfSize:15.0];
        /*float mn = [arrayWorkouts[i][4] intValue]/60;
        if (mn < 1) wLabel10.text = [NSString stringWithFormat:@"< 1"];
        else wLabel10.text = [NSString stringWithFormat:@"%.2f", mn];*/
        
        wLabel10.text = [NSString stringWithFormat:@"%02d:%02d:%02d",([arrayWorkouts[i][2] intValue]/3600),(([arrayWorkouts[i][2] intValue]/60)%60),([arrayWorkouts[i][2] intValue]%60)];
        [wView addSubview:wLabel10];
        
        [self.viewMain addSubview:wView];
        coffset = coffset+118;
        dc--;
    }
}

-(void)clearMainView {
    for (UIView *subview in [self.viewMain subviews]) {
        [subview removeFromSuperview];
    }
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

- (IBAction)buttonSettingsAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationRewards"];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
