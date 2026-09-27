
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "DBManager.h"

@interface WeightNewViewController : UIViewController{
    NSMutableArray *pickerData;
    double cval;
}

@property (weak, nonatomic) IBOutlet UILabel *labelAward;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
@property (weak, nonatomic) IBOutlet UITextField *textWeightValue;
- (IBAction)buttonOkAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)buttonBackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (nonatomic, strong) DBManager *dbManager;


@end
