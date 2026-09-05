
#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.322 green:0.514 blue:0.831 alpha:1.00];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};*/
    
    SACalendar *calendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 0, self.datesView.frame.size.width, self.datesView.frame.size.height) scrollDirection:ScrollDirectionVertical pagingEnabled:NO];
    
    calendar.delegate = self;
    
    [self.datesView addSubview:calendar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Delegate method : get called when a date is selected
 */
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    //NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

@end
