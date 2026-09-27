
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface RunHistoryViewController : UIViewController{
    NSMutableArray *arrayWorkouts;
    float isMile;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (nonatomic, strong) DBManager *dbManager;

@end
