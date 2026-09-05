
#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    arrayWorkouts = [self.dbManager loadAllItems:@""];
    if ((int)[arrayWorkouts count] > 0) {
        [self refreshActivityView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
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
    /*if (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXSMAX) {
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
        switch ([arrayWorkouts[i][2] intValue]) {
            case 0:
                wleftView.backgroundColor = main_color2;
                break;
            case 1:
                wleftView.backgroundColor = main_color2;
                break;
            case 2:
                wleftView.backgroundColor = main_color2;
                break;
            case 3:
                wleftView.backgroundColor = main_color2;
                break;
            case 4:
                wleftView.backgroundColor = main_color2;
                break;
            case 5:
                wleftView.backgroundColor = main_color2;
                break;
            case 6:
                wleftView.backgroundColor = main_color2;
                break;
            default:
                wleftView.backgroundColor = main_color2;
                break;
        }
        [wView addSubview:wleftView];
        
        UILabel *wLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, wleftView.frame.size.width-8, 40)];
        wLabel1.textColor = [UIColor labelColor];
        wLabel1.font = [UIFont systemFontOfSize:13.0];
        wLabel1.text = [NSString stringWithFormat:@"Workout #%d",dc];
        [wleftView addSubview:wLabel1];
        
        UILabel *wLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, wleftView.frame.size.width-8, 26)];
        wLabel2.textColor = [UIColor labelColor];
        wLabel2.font = [UIFont systemFontOfSize:13.0];
        wLabel2.text = [NSString stringWithFormat:@"%@", arrayWorkouts[i][4]];
        [wleftView addSubview:wLabel2];
        
        UILabel *wLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(108, 8, wView.frame.size.width-116, 40)];
        wLabel4.textColor = [UIColor labelColor];
        wLabel4.font = [UIFont systemFontOfSize:18.0];
        wLabel4.text = arrayWorkouts[i][3];
        [wView addSubview:wLabel4];
        
        UILabel *wLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(108, 50, 80, 25)];
        wLabel5.textColor = [UIColor labelColor];
        wLabel5.font = [UIFont systemFontOfSize:14.0];
        wLabel5.text = @"Exercises";
        [wView addSubview:wLabel5];
        
        UILabel *wLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(189, 50, 80, 25)];
        wLabel6.textColor = [UIColor labelColor];
        wLabel6.font = [UIFont systemFontOfSize:14.0];
        wLabel6.text = @"Calories";
        [wView addSubview:wLabel6];
        
        UILabel *wLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(271, 50, 80, 25)];
        wLabel7.textColor = [UIColor labelColor];
        wLabel7.font = [UIFont systemFontOfSize:14.0];
        wLabel7.text = @"Minutes";
        [wView addSubview:wLabel7];
        
        
        UILabel *wLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(108, 77, 80, 25)];
        wLabel8.textColor = [UIColor systemGreenColor];
        wLabel8.font = [UIFont systemFontOfSize:14.0];
        wLabel8.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[i][5] intValue]];
        [wView addSubview:wLabel8];
        
        UILabel *wLabel9 = [[UILabel alloc] initWithFrame:CGRectMake(189, 77, 80, 25)];
        wLabel9.textColor = [UIColor systemGreenColor];
        wLabel9.font = [UIFont systemFontOfSize:14.0];
        wLabel9.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[i][6] intValue]];
        [wView addSubview:wLabel9];
        
        UILabel *wLabel10 = [[UILabel alloc] initWithFrame:CGRectMake(271, 77, 80, 25)];
        wLabel10.textColor = [UIColor systemGreenColor];
        wLabel10.font = [UIFont systemFontOfSize:14.0];
        float mn = [arrayWorkouts[i][7] intValue]/60;
        if (mn < 1) wLabel10.text = [NSString stringWithFormat:@"< 1"];
        else wLabel10.text = [NSString stringWithFormat:@"%.2f", mn];
        [wView addSubview:wLabel10];
        
        [self.viewMain addSubview:wView];
        coffset = coffset+118;
        dc--;
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


@end
