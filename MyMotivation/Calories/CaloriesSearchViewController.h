
#import <UIKit/UIKit.h>
#import "CaloriesDetailViewController.h"

@interface CaloriesSearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> 

@property (weak, nonatomic) IBOutlet UITextField *textSearch;
@property (strong, nonatomic) IBOutlet UITableView *mainTableMain;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonClear;
- (IBAction)buttonSearchAction:(id)sender;
- (IBAction)buttonClearAction:(id)sender;
- (IBAction)buttonBackAction:(id)sender;


@end
