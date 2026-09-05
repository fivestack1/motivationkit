
#import "HeartActivityViewController.h"

@interface HeartActivityViewController ()

@end

@implementation HeartActivityViewController{
    NSMutableArray *titles;
    NSMutableArray *subtitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    arrayChart = [[NSMutableArray alloc] init];
    
    self.dbManager = [[DBManager alloc] initDatabase];
    
    [self setTextFont];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    arrayChart = [self.dbManager loadHeartLastActivityItems];
    [bar removeFromSuperview];
    [self showBarChart];
    
    
    total_rates = [self.dbManager countHeartTotalItems];
    min_rate = [self.dbManager countHeartMinItems];
    max_rate = [self.dbManager countHeartMaxItems];
    
    self.labelTotal.text = [NSString stringWithFormat:@"%d",total_rates];
    self.labelAvg.text = [NSString stringWithFormat:@"%d bpm",(int)(min_rate+max_rate)/2];
    self.labelMin.text = [NSString stringWithFormat:@"%d bpm",min_rate];
    self.labelMax.text = [NSString stringWithFormat:@"%d bpm",max_rate];
    
    titles = [[NSMutableArray alloc] init];
    subtitles = [[NSMutableArray alloc] init];
    titles = [self.dbManager loadHeartLogTitles];
    subtitles = [self.dbManager loadHeartLogSubTitles];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showBarChart {
    NSArray *color1 = @[[self colorWithHexString:@"#5677fc" alpha:0.6],[self colorWithHexString:@"#5677fc" alpha:0.8]];
    NSArray *color2 = @[[self colorWithHexString:@"#dd191d" alpha:0.6],[self colorWithHexString:@"#dd191d" alpha:0.8]];
    NSArray *color3 = @[[self colorWithHexString:@"#8e24aa" alpha:0.6],[self colorWithHexString:@"#8e24aa" alpha:0.8]];
    NSArray *color4 = @[[self colorWithHexString:@"#3f51b5" alpha:0.6],[self colorWithHexString:@"#3f51b5" alpha:0.8]];
    NSArray *color5 = @[[self colorWithHexString:@"#d81b60" alpha:0.6],[self colorWithHexString:@"#d81b60" alpha:0.8]];
    NSArray *color6 = @[[self colorWithHexString:@"#2baf2b" alpha:0.6],[self colorWithHexString:@"#2baf2b" alpha:0.8]];
    NSArray *color7 = @[[self colorWithHexString:@"#b0bec5" alpha:0.6],[self colorWithHexString:@"#b0bec5" alpha:0.8]];
    
    bar = [[HXBarChart alloc] initWithFrame:CGRectMake(0, 30, self.chartViewBlock.frame.size.width-20, self.chartViewBlock.frame.size.height-30) withMarkLabelCount:8 withOrientationType:OrientationVertical];
    
    NSString *nm1 = @"";
    NSString *nm2 = @"";
    NSString *nm3 = @"";
    NSString *nm4 = @"";
    NSString *nm5 = @"";
    NSString *nm6 = @"";
    NSString *nm7 = @"";
    NSString *vl1 = @"";
    NSString *vl2 = @"";
    NSString *vl3 = @"";
    NSString *vl4 = @"";
    NSString *vl5 = @"";
    NSString *vl6 = @"";
    NSString *vl7 = @"";
    if ([arrayChart count] > 0) { /*nm1 = arrayChart[0][3];*/ vl1 = [NSString stringWithFormat:@"%d", [arrayChart[0][2] intValue]]; }
    if ([arrayChart count] > 1) { /*nm2 = arrayChart[1][3];*/ vl2 = [NSString stringWithFormat:@"%d", [arrayChart[1][2] intValue]]; }
    if ([arrayChart count] > 2) { /*nm3 = arrayChart[2][3];*/ vl3 = [NSString stringWithFormat:@"%d", [arrayChart[2][2] intValue]]; }
    if ([arrayChart count] > 3) { /*nm4 = arrayChart[3][3];*/ vl4 = [NSString stringWithFormat:@"%d", [arrayChart[3][2] intValue]]; }
    if ([arrayChart count] > 4) { /*nm5 = arrayChart[4][3];*/ vl5 = [NSString stringWithFormat:@"%d", [arrayChart[4][2] intValue]]; }
    if ([arrayChart count] > 5) { /*nm6 = arrayChart[5][3];*/ vl6 = [NSString stringWithFormat:@"%d", [arrayChart[5][2] intValue]]; }
    if ([arrayChart count] > 6) { /*nm7 = arrayChart[6][3];*/ vl7 = [NSString stringWithFormat:@"%d", [arrayChart[6][2] intValue]]; }
    
    bar.titleArray = @[nm1, nm2, nm3, nm4, nm5, nm6, nm7];
    bar.valueArray = @[vl1, vl2, vl3, vl4, vl5, vl6, vl7];
    bar.colorArray = @[color1,color2,color3,color4,color5,color6,color7];
    //bar.locations = @[@0.15,@.85];
    bar.backgroundLineColor = [self colorWithHexString:@"#ffffff" alpha:1];
    
    [self.chartViewBlock addSubview:bar];
    
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
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
    tableView.separatorColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.textColor = [UIColor labelColor];
    cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];

    return cell;
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt3.font = [UIFont systemFontOfSize:18.0f];
    self.labelSt4.font = [UIFont systemFontOfSize:18.0f];
    
    self.labelMin.font = [UIFont systemFontOfSize:20.0f];
    self.labelMax.font = [UIFont systemFontOfSize:20.0f];
    self.labelAvg.font = [UIFont systemFontOfSize:20.0f];
    self.labelTotal.font = [UIFont systemFontOfSize:20.0f];
}

@end
