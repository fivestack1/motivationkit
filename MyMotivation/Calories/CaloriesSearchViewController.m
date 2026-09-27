
#import "CaloriesSearchViewController.h"
#import "GlobalState.h"

@interface CaloriesSearchViewController ()

@end

@implementation CaloriesSearchViewController{
    NSMutableArray *arrAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonSearch.layer.masksToBounds = YES;
    self.buttonSearch.layer.cornerRadius = self.buttonSearch.frame.size.width / 10.0;
    
    self.buttonClear.layer.masksToBounds = YES;
    self.buttonClear.layer.cornerRadius = self.buttonClear.frame.size.width / 10.0;
    
    arrAll = [[NSMutableArray alloc] init];
    
    [self setTextFont];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAll count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    if ([arrAll count] > 0){
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.textColor = [UIColor labelColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[arrAll objectAtIndex:indexPath.row] objectForKey:@"description"]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor = [UIColor labelColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[arrAll objectAtIndex:indexPath.row] objectForKey:@"foodCategory"]];
        //cell.tag = [[[arrAll objectAtIndex:indexPath.row] objectForKey:@"fdcId"] intValue];
        cell.restorationIdentifier = [NSString stringWithFormat:@"%@", [[arrAll objectAtIndex:indexPath.row] objectForKey:@"fdcId"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"ShowNavigationDetailsCalories"];
    CaloriesDetailViewController *controller = (CaloriesDetailViewController *)navController.topViewController;
    //controller.foodId = [NSString stringWithFormat:@"%ld", (long)cell.tag];
    controller.foodId = [NSString stringWithFormat:@"%@", cell.restorationIdentifier];
    [self presentViewController:navController animated:YES completion:nil];
}


- (IBAction)buttonBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonClearAction:(id)sender {
    if ([arrAll count] > 0) {
        [arrAll removeAllObjects];
        [self.mainTableMain reloadData];
        self.mainTableMain.hidden = TRUE;
    }
    
}

- (IBAction)buttonSearchAction:(id)sender {
    if ([self.textSearch.text length] > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.nal.usda.gov/fdc/v1/foods/search?format=json&query=%@&sort=n&pageSize=100&pageNumber=0&api_key=%@", self.textSearch.text, usda_api_key]]];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {

                // Option 2 (if getting JSON data)
                NSError *jsonError = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                self->arrAll = [[dictionary objectForKey:@"foods"] mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mainTableMain.hidden = FALSE;
                    [self.mainTableMain reloadData];
                });
            }
            else {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        [task resume];
    }

}

-(void)setTextFont {
    self.buttonClear.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.buttonSearch.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.textSearch.font = [UIFont systemFontOfSize:13.0f];
}

@end
