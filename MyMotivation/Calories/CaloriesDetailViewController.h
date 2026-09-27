
#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface CaloriesDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> 

@property (weak, nonatomic) IBOutlet UITextField *textCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
- (IBAction)buttonAddAction:(id)sender;
- (IBAction)buttonBackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic,strong) NSString * foodId;
@property (nonatomic, strong) DBManager *dbManager;

@end
