
#import "StepsActivityViewController.h"

@implementation StepsActivityViewController{
    int total_workouts;
    long total_steps;
    long total_time;
    float total_distance;
    long total_floors;
    NSMutableArray *titles;
    NSMutableArray *subtitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    total_workouts = 0;
    total_steps = 0;
    total_distance = 0;
    total_floors = 0;
    
    self.dbManager = [[DBManager alloc] initDatabase];
    NSMutableArray *actArr = [[NSMutableArray alloc] init];
    actArr = [self.dbManager loadStepsDataItems];
    
    total_workouts = [actArr[0] intValue];
    total_time = [actArr[1] intValue];
    total_distance = [actArr[2] floatValue];
    total_steps = [actArr[3] intValue];
    total_floors = [actArr[4] intValue];
    
    self.labelWorkouts.text = [NSString stringWithFormat:@"%d",total_workouts];
    if (total_time) self.labelTime.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(total_time/3600),((total_time/60)%60),(total_time%60)];
    self.labelSteps.text = [NSString stringWithFormat:@"%ld",total_steps];
    
    if ([[Settings objectForKey:@"checkDistance"] isEqualToString:@"Mi"]) {
        //isMile = 0.621371;
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f mi",total_distance*0.000621371192];
    }
    else {
        self.labelDistance.text = [NSString stringWithFormat:@"%.2f km",total_distance*0.001];
    }
    
    self.labelFloors.text = [NSString stringWithFormat:@"%ld",total_floors];
    
    titles = [[NSMutableArray alloc] init];
    subtitles = [[NSMutableArray alloc] init];
    titles = [self.dbManager loadStepsLogTitles];
    subtitles = [self.dbManager loadStepsLogSubTitles];
    
    [self setTextFont];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    
    return cell;
}

-(void)setTextFont {
    
    self.labelSt1.font = [UIFont systemFontOfSize:19.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:19.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:19.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:19.0f];
    self.labelSt5.font = [UIFont systemFontOfSize:19.0f];
    
    self.labelTime.font = [UIFont systemFontOfSize:22.0f];
    self.labelWorkouts.font = [UIFont systemFontOfSize:22.0f];
    self.labelFloors.font = [UIFont systemFontOfSize:22.0f];
    self.labelDistance.font = [UIFont systemFontOfSize:22.0f];
    self.labelSteps.font = [UIFont systemFontOfSize:22.0f];
}

@end
