
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "ZZCircleProgress.h"
#import "DBManager.h"

@interface WeightViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;

@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;
- (IBAction)buttonPlusAction:(id)sender;

@property (strong, nonatomic) ZZCircleProgress *progressView;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelSt1;

@end
