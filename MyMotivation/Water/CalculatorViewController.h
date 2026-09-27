
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UITextField *textOutput;
@property (weak, nonatomic) IBOutlet UIButton *buttonConvert;
- (IBAction)buttonConvertAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelSt1;
@property (weak, nonatomic) IBOutlet UILabel *labelSt2;

@end

