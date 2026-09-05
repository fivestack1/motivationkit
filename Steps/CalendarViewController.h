
#import <UIKit/UIKit.h>
#import "SACalendar.h"
#import "DateUtil.h"
#import "GlobalState.h"

@interface CalendarViewController : UIViewController<SACalendarDelegate>

@property (weak, nonatomic) IBOutlet UIView *datesView;

@end
