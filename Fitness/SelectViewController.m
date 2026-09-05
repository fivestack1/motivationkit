
#import "SelectViewController.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    NSUInteger jsonReadingOptions = NSJSONReadingAllowFragments | NSJSONReadingMutableContainers;
    json = [[NSMutableArray alloc] init];
    json = [NSJSONSerialization JSONObjectWithData:data options:jsonReadingOptions error:nil];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [json count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[[json objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    //cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[cell.imageView setTintColor:orange_color];
    
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.textLabel.text = [[json objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.restorationIdentifier = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationWorkout"];
    WorkoutViewController *controller = (WorkoutViewController *)navController.topViewController;
    //controller.currentItem = [cell.restorationIdentifier intValue];
    controller.currentWorkout = (int)indexPath.row;
    //controller.workoutArray = [[json objectAtIndex:indexPath.row] objectForKey:@"exercises"];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
