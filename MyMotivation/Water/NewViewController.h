
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface NewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *pickerData;
    double cval;
}

@property (weak, nonatomic) IBOutlet UITableView *tableMain;
@property (weak, nonatomic) IBOutlet UILabel *labelAward;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
- (IBAction)buttonOkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)buttonBackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
