
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "WorkoutViewController.h"

@interface SelectViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *json;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
