
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "HcdProcessView.h"
#import "DBManager.h"

@interface WaterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;

- (IBAction)buttonPlusAction:(id)sender;
- (IBAction)buttonMinusAction:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


@end
