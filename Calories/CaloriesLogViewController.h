
#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CaloriesLogViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> 

@property (strong, nonatomic) IBOutlet UITableView *tableMain;

@property (nonatomic, strong) DBManager *dbManager;

@end
