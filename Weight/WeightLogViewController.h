
#import <UIKit/UIKit.h>
#import "MCLineChartView.h"
#import "GlobalState.h"
#import "DBManager.h"

@interface WeightLogViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MCLineChartViewDataSource, MCLineChartViewDelegate> 

@property (weak, nonatomic) IBOutlet UIView *viewGraph;
@property (weak, nonatomic) IBOutlet UITableView *tableMain;
@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;

@end
