
#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController{
    NSMutableArray *titles;
    NSMutableArray *subtitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.dbManager = [[DBManager alloc] initDatabase];
    titles = [[NSMutableArray alloc] init];
    subtitles = [[NSMutableArray alloc] init];
    titles = [self.dbManager loadLogTitles];
    subtitles = [self.dbManager loadLogSubtitles];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles count];
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
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    return cell;
}


@end
