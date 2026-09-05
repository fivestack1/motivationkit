
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface YogaActivityViewController : UIViewController{
    NSMutableArray *arrayWorkouts;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

- (IBAction)buttonSettingsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelEmpty;

@property (nonatomic, strong) DBManager *dbManager;

@end
