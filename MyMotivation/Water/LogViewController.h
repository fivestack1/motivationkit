
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface LogViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource> 

@property (nonatomic, strong) DBManager *dbManager;

@end
