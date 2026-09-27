
#import "CaloriesDetailViewController.h"

@interface CaloriesDetailViewController()

@end
@implementation CaloriesDetailViewController{
    NSMutableArray *arrDetails;
    NSString *foodName;
    int foodVal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonAdd.layer.masksToBounds = YES;
    self.buttonAdd.layer.cornerRadius = self.buttonAdd.frame.size.height / 10.0;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrDetails = [[NSMutableArray alloc] init];
    
    foodName = @"";
    foodVal = 0;
    
    [self loadFoodDetails];
    [self setTextFont];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)loadFoodDetails{
    if ([self.foodId length] > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.nal.usda.gov/fdc/v1/food/%@?api_key=%@", self.foodId, usda_api_key]]];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                // Option 1 (from answer above):
                //NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                //NSLog(@"%@", string);

                // Option 2 (if getting JSON data)
                NSError *jsonError = nil;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                self->arrDetails = [[dictionary objectForKey:@"foodNutrients"] mutableCopy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.mainTable.hidden = FALSE;
                    [self.mainTable reloadData];
                });
            }
            else {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        [task resume];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSString *cnm = @"";
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    if ([arrDetails count] > 0){
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor labelColor];
        cnm = [NSString stringWithFormat:@"%@", [[[arrDetails objectAtIndex:indexPath.row] objectForKey:@"nutrient"] objectForKey:@"unitName"]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[arrDetails objectAtIndex:indexPath.row] objectForKey:@"nutrient"] objectForKey:@"name"]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.textColor = [UIColor labelColor];
        if ([[arrDetails objectAtIndex:indexPath.row] objectForKey:@"amount"] == NULL) cell.detailTextLabel.text = [NSString stringWithFormat:@"- %@", cnm];
        else cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [[arrDetails objectAtIndex:indexPath.row] objectForKey:@"amount"], cnm];
        if ([cnm isEqualToString:@"kcal"]) {
            foodName = cnm;
            foodVal = [[[arrDetails objectAtIndex:indexPath.row] objectForKey:@"amount"] intValue];
        }
    }
    return cell;
}

- (IBAction)buttonBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonAddAction:(id)sender {
    int ct = 1;
    if ([self.textCount.text length] > 0) ct = [self.textCount.text intValue];
    if ([foodName length] > 0) [self.dbManager saveCaloriesDataItem:(foodVal*ct) onval:foodName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setTextFont {
    self.buttonAdd.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.textCount.font = [UIFont systemFontOfSize:13.0f];
}

@end
