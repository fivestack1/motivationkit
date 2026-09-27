
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"

@interface HistoryViewController : UIViewController{
    NSMutableArray *arrayWorkouts;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (nonatomic, strong) DBManager *dbManager;

@end
