
#import "YogaExercisesViewController.h"

@interface YogaExercisesViewController ()

@end

@implementation YogaExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"ydata" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    json = [[NSMutableArray alloc] init];
    json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
    [self refreshExercisesView];
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

- (void) refreshExercisesView {
    self.viewMain.frame = CGRectMake(0, 0, self.scrollMain.frame.size.width, (([json count] * 98)+8));
    [self.scrollMain setScrollEnabled:YES];
    [self.scrollMain setContentSize:CGSizeMake(self.scrollMain.frame.size.width, self.viewMain.frame.size.height)];
    
    int coffset = 8;
    for (int i = 0; i < [json count]; i++) {
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(8, coffset, self.viewMain.frame.size.width-16, 90)];
        wView.backgroundColor = [UIColor clearColor];
        wView.layer.masksToBounds = YES;
        wView.layer.cornerRadius = 10.0f;
        
        UIImageView *pic =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,90,90)];
        pic.image=[UIImage imageNamed:[[json objectAtIndex:i] objectForKey:@"picture"]];
        [wView addSubview:pic];
        
        UILabel *wLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 20, wView.frame.size.width-8, 50)];
        wLabel.textColor = [UIColor labelColor];
        wLabel.font = [UIFont systemFontOfSize:20.0];
        wLabel.text = [[json objectAtIndex:i] objectForKey:@"name"];
        [wView addSubview:wLabel];
        
        UIButton *wButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wButton addTarget:self action:@selector(buttonStartExercise:) forControlEvents:UIControlEventTouchUpInside];
        [wButton setTitle:@"" forState:UIControlStateNormal];
        wButton.frame = CGRectMake(0, 0, wView.frame.size.width, wView.frame.size.height);
        wButton.restorationIdentifier = [NSString stringWithFormat:@"%d",i];
        [wView addSubview:wButton];
        
        [self.viewMain addSubview:wView];
        coffset = coffset+98;
    }
    
}

- (void) buttonStartExercise:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationYogaWorkout"];
    YogaWorkoutViewController *controller = (YogaWorkoutViewController *)navController.topViewController;
    controller.isMeditation = FALSE;
    controller.currentItem = [resultButton.restorationIdentifier intValue];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
