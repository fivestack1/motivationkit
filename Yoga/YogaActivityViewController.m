
#import "YogaActivityViewController.h"

@interface YogaActivityViewController ()

@end

@implementation YogaActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrayWorkouts = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    arrayWorkouts = [self.dbManager loadYogaAllItems:@""];
    if ((int)[arrayWorkouts count] > 0) {
        self.labelEmpty.hidden = TRUE;
        [self refreshActivityView];
    }
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
        wView.backgroundColor = [UIColor whiteColor];
        wView.layer.masksToBounds = YES;
        wView.layer.cornerRadius = 10.0f;
        
        UIView *wleftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 95, 110)];
        if ([arrayWorkouts[i][1] intValue] == 0) wleftView.backgroundColor = main_color2;
        else wleftView.backgroundColor = main_color2;
        [wView addSubview:wleftView];
        
        UILabel *wLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, wleftView.frame.size.width-8, 40)];
        wLabel1.textColor = [UIColor labelColor];
        wLabel1.font = [UIFont systemFontOfSize:18.0];
        wLabel1.text = [NSString stringWithFormat:@"Yoga #%d",dc];
        [wleftView addSubview:wLabel1];
        
        UILabel *wLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 50, wleftView.frame.size.width-8, 26)];
        wLabel2.textColor = [UIColor labelColor];
        wLabel2.font = [UIFont systemFontOfSize:14.0];
        wLabel2.text = [NSString stringWithFormat:@"%@", arrayWorkouts[i][3]];
        [wleftView addSubview:wLabel2];
        
        UILabel *wLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(8, 77, wleftView.frame.size.width-8, 26)];
        wLabel3.textColor = [UIColor labelColor];
        wLabel3.font = [UIFont systemFontOfSize:14.0];
        wLabel3.text = [NSString stringWithFormat:@"%@", arrayWorkouts[i][9]];
        [wleftView addSubview:wLabel3];
        
        UILabel *wLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(108, 8, wView.frame.size.width-116, 40)];
        wLabel4.textColor = [UIColor labelColor];
        wLabel4.font = [UIFont systemFontOfSize:18.0];
        wLabel4.text = arrayWorkouts[i][8];
        [wView addSubview:wLabel4];
        
        
        UILabel *wLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(108, 50, 80, 25)];
        wLabel5.textColor = [UIColor labelColor];
        wLabel5.font = [UIFont systemFontOfSize:14.0];
        wLabel5.text = @"Energies";
        [wView addSubview:wLabel5];
        
        UILabel *wLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(189, 50, 80, 25)];
        wLabel6.textColor = [UIColor labelColor];
        wLabel6.font = [UIFont systemFontOfSize:14.0];
        wLabel6.text = @"Happiness";
        [wView addSubview:wLabel6];
        
        UILabel *wLabel7 = [[UILabel alloc] initWithFrame:CGRectMake(271, 50, 80, 25)];
        wLabel7.textColor = [UIColor labelColor];
        wLabel7.font = [UIFont systemFontOfSize:14.0];
        wLabel7.text = @"Minutes";
        [wView addSubview:wLabel7];
        
        
        UILabel *wLabel8 = [[UILabel alloc] initWithFrame:CGRectMake(108, 77, 80, 25)];
        wLabel8.textColor = [UIColor systemGreenColor];
        wLabel8.font = [UIFont systemFontOfSize:14.0];
        wLabel8.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[i][6] intValue]];
        [wView addSubview:wLabel8];
        
        UILabel *wLabel9 = [[UILabel alloc] initWithFrame:CGRectMake(189, 77, 80, 25)];
        wLabel9.textColor = [UIColor systemGreenColor];
        wLabel9.font = [UIFont systemFontOfSize:14.0];
        wLabel9.text = [NSString stringWithFormat:@"%d%%", [arrayWorkouts[i][5] intValue]*10];
        [wView addSubview:wLabel9];
        
        UILabel *wLabel10 = [[UILabel alloc] initWithFrame:CGRectMake(271, 77, 80, 25)];
        wLabel10.textColor = [UIColor systemGreenColor];
        wLabel10.font = [UIFont systemFontOfSize:14.0];
        wLabel10.text = [NSString stringWithFormat:@"%d", [arrayWorkouts[i][4] intValue]/60];
        [wView addSubview:wLabel10];
        
        [self.viewMain addSubview:wView];
        coffset = coffset+118;
        dc--;
    }
}



- (IBAction)buttonSettingsAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationSettings"];
    //SettingsViewController *controller = (SettingsViewController *)navController.topViewController;
    [self presentViewController:navController animated:YES completion:nil];
}


@end
