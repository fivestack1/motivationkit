
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "SFProgressCircle.h"
#import "DBManager.h"

@interface CaloriesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *labelCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelPercent;
@property (weak, nonatomic) IBOutlet UIView *viewPercent;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)buttonMinusAction:(id)sender;
- (IBAction)buttonPlusAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topProgressView;
@property (nonatomic) SFCircleGradientView *progressView;
@property (nonatomic) UILabel *titleLabel;

@property (nonatomic, strong) DBManager *dbManager;
@property (weak, nonatomic) IBOutlet UILabel *labelSt1;


@end
