
#import "CaloriesLogViewController.h"
#import "GlobalState.h"

@interface CaloriesLogViewController ()

@end

@implementation CaloriesLogViewController{
    NSMutableArray *arrAll;
    //NSMutableArray *subtitles;
    //NSMutableArray *ids;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    //titles = [[NSMutableArray alloc] init];
    //subtitles = [[NSMutableArray alloc] init];
    //ids = [[NSMutableArray alloc] init];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrAll = [[NSMutableArray alloc] init];
    //subtitles = [[NSMutableArray alloc] init];
    //titles = [self.dbManager loadHeartLogTitles];
    
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    arrAll = [self.dbManager loadCaloriesLogItems:@""];
    [self.tableMain reloadData];
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
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Date - %@", arrAll[indexPath.row][1]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%2.f Kcal", [arrAll[indexPath.row][2] floatValue]];
    cell.tag = [arrAll[indexPath.row][0] intValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dbManager deleteCaloriesDataItem:cell.tag];
        [arrAll removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


@end
