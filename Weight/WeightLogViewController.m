
#import "WeightLogViewController.h"

@interface WeightLogViewController ()

@property (strong, nonatomic) NSArray *titles1;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) MCLineChartView *lineChartView;

@end

@implementation WeightLogViewController{
    NSMutableArray *arrWeight;
    int max;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.dbManager = [[DBManager alloc] initDatabase];
    arrWeight = [[NSMutableArray alloc] init];
    arrWeight = [self.dbManager loadWeightLogData:@""];
    NSMutableArray *tit = [[NSMutableArray alloc] init];
    NSMutableArray *vl = [[NSMutableArray alloc] init];
    max = 0;
    for (int i = 0; i < [arrWeight count]; i++) {
        NSString *dt = [NSString stringWithFormat:@"%@", [[arrWeight objectAtIndex:i] objectAtIndex:1]];
        int v = [[[arrWeight objectAtIndex:i] objectAtIndex:2] intValue];
        if (v >= max) max = v;
        [tit addObject:[dt substringToIndex:10]];
        [vl addObject:[NSNumber numberWithInteger:v]];
    }
    _titles1 = [tit copy];
    _dataSource = [vl copy];
    
    [self createLineChart];
    [self setTextFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)createLineChart {
    
    _lineChartView = [[MCLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.viewGraph.frame.size.width, self.viewGraph.frame.size.height)];
    _lineChartView.dotRadius = 4;
    _lineChartView.dataSource = self;
    _lineChartView.delegate = self;
    _lineChartView.minValue = @10;
    _lineChartView.maxValue = [NSNumber numberWithInt:(max+10)];
    _lineChartView.solidDot = YES;
    _lineChartView.numberOfYAxis = 7;
    _lineChartView.colorOfXAxis = [UIColor lightGrayColor];
    _lineChartView.colorOfXText = [UIColor lightGrayColor];
    _lineChartView.colorOfYAxis = [UIColor lightGrayColor];
    _lineChartView.colorOfYText = [UIColor lightGrayColor];
    [self.viewGraph addSubview:_lineChartView];
    
    [_lineChartView reloadDataWithAnimate:YES];
    //[self refreshData];
}

- (void)refreshData {
    arrWeight = [self.dbManager loadWeightLogData:@""];
    NSMutableArray *tit = [[NSMutableArray alloc] init];
    NSMutableArray *vl = [[NSMutableArray alloc] init];
    if (vl.count > 0) {
        [tit removeAllObjects];
        [vl removeAllObjects];
    }
    max = 0;
    for (int i = 0; i < [arrWeight count]; i++) {
        NSString *dt = [NSString stringWithFormat:@"%@", [[arrWeight objectAtIndex:i] objectAtIndex:1]];
        int v = [[[arrWeight objectAtIndex:i] objectAtIndex:2] intValue];
        if (v >= max) max = v;
        [tit addObject:[dt substringToIndex:10]];
        [vl addObject:[NSNumber numberWithInteger:v]];
    }
    _titles1 = [tit copy];
    _dataSource = [vl copy];
    [_lineChartView reloadDataWithAnimate:YES];
    [self.tableMain reloadData];
}

- (NSUInteger)numberOfLinesInLineChartView:(MCLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(MCLineChartView *)lineChartView lineCountAtLineNumber:(NSInteger)number {
    return [_dataSource count];
}

- (id)lineChartView:(MCLineChartView *)lineChartView valueAtLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    return _dataSource[lineNumber == 0 ? index : [_dataSource count] - index - 1];
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView titleAtLineNumber:(NSInteger)number {
    return _titles1[number];
}

- (UIColor *)lineChartView:(MCLineChartView *)lineChartView lineColorWithLineNumber:(NSInteger)lineNumber {
    if (lineNumber == 0) {
        return main_color2;
    } else if (lineNumber == 1) {
        return main_color2;
    } else if (lineNumber == 2) {
        return main_color2;
    } else {
        return main_color2;
    }
}

- (NSString *)lineChartView:(MCLineChartView *)lineChartView informationOfDotInLineNumber:(NSInteger)lineNumber index:(NSInteger)index {
    //if (index == 0 || index == _dataSource.count - 1) {
        return [NSString stringWithFormat:@"%@", _dataSource[index]];
    //}
    //return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrWeight count];
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
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.text = [NSString stringWithFormat:@"Date - %@", [[arrWeight objectAtIndex:indexPath.row] objectAtIndex:1]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Weight - %@", [[arrWeight objectAtIndex:indexPath.row] objectAtIndex:2]];
    cell.tag = [[[arrWeight objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dbManager deleteWeightDataItem:cell.tag];
        [arrWeight removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self refreshData];
    }
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont systemFontOfSize:18.0f];
}

@end
