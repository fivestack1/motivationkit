
#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = main_color1;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.buttonConvert.layer.masksToBounds = YES;
    self.buttonConvert.layer.cornerRadius = self.buttonConvert.frame.size.height / 5.0;
    
    self.textInput.layer.cornerRadius = self.textInput.frame.size.height / 5.0;
    self.textInput.layer.borderWidth = 1.0f;
    self.textInput.layer.borderColor = [light_color CGColor];
    
    self.textOutput.layer.cornerRadius = self.textOutput.frame.size.height / 5.0;
    self.textOutput.layer.borderWidth = 1.0f;
    self.textOutput.layer.borderColor = [light_color CGColor];
    
    [self setTextFont];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonConvertAction:(id)sender {
    if ([self.textInput.text length] > 0) {
        self.textOutput.text = [NSString stringWithFormat:@"%.2f", [self.textInput.text floatValue]*oztoml];
    }
}

-(void)setTextFont {
    self.labelSt1.font = [UIFont systemFontOfSize:24.0f];
    self.labelSt2.font = [UIFont systemFontOfSize:24.0f];
    self.textInput.font = [UIFont systemFontOfSize:45.0f];
    self.textOutput.font = [UIFont systemFontOfSize:45.0f];
    self.buttonConvert.titleLabel.font = [UIFont systemFontOfSize:22.0f];
}


@end
