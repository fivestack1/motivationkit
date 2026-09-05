
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface HeartLogViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DBManager *dbManager;

@end
