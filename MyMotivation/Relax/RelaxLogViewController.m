
#import "RelaxLogViewController.h"
#import "GlobalState.h"

@interface RelaxLogViewController ()

@end

@implementation RelaxLogViewController{
    NSMutableArray *arrAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrAll = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.topItem.title = @"HISTORY";
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    arrAll = [self.dbManager loadRelaxLogItems:@""];
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
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Date - %@", arrAll[indexPath.row][1]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    int goal = (fmod(fmod(([arrAll[indexPath.row][2] intValue]), 86400), 3600) / 60);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d minutes", goal];
    cell.tag = [arrAll[indexPath.row][0] intValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dbManager deleteRelaxDataItem:cell.tag];
        [arrAll removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


@end
