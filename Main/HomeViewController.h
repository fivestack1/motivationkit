
#import <UIKit/UIKit.h>
#import "GlobalState.h"
#import "RESideMenu.h"
#import "DBManager.h"
#import "SFProgressCircle.h"

#import "LSLDatePickerDialog.h"
//#import "DGExpandMenuButton.h"
//#import "DCPathButton.h"
#import "MCLineChartView.h"

#import "MCCircleChartView.h"

@interface HomeViewController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate, MCLineChartViewDataSource, MCLineChartViewDelegate, MCCircleChartViewDataSource, MCCircleChartViewDelegate> {
    NSArray *themes;
    NSInteger cursor;
    CFTimeInterval startTime;
    NSNumber *fromNumber;
    NSNumber *toNumber;
    long totalValue1;
    long totalValue2;
    long totalValue3;
    double totalValue4;
    long totalValue5;
    double totalValue6;
    double totalValue7;
    
    double todayValue1;
    double todayValue2;
    double todayValue3;
    double todayValue4;
    double todayValue5;
    double todayValue6;
    double todayValue7;
    
    float isMile;
    NSString *dateString;
    NSMutableArray *arrLineChart;
    int max;
    BOOL isloaded;
}
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollLaunsh;
//@property (weak, nonatomic) IBOutlet UIView *viewLaunch;
//@property (weak, nonatomic) IBOutlet UIPageControl *pagerLaunch;

@property (weak, nonatomic) IBOutlet UIView *viewSlide1;
@property (weak, nonatomic) IBOutlet UIView *viewSlide2;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollMain;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIView *viewProgress;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet UIButton *buttonNav;
- (IBAction)buttonNavAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDateDialog;
- (IBAction)showDateDialog:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topProgressView1;
@property (weak, nonatomic) IBOutlet UIView *topProgressView2;
@property (weak, nonatomic) IBOutlet UIView *topProgressView3;
@property (weak, nonatomic) IBOutlet UIView *topProgressView4;
@property (weak, nonatomic) IBOutlet UIView *topProgressView5;
@property (weak, nonatomic) IBOutlet UIView *topProgressView6;
@property (weak, nonatomic) IBOutlet UIView *topProgressView7;
@property (nonatomic) SFCircleGradientView *progressView1;
@property (nonatomic) SFCircleGradientView *progressView2;
@property (nonatomic) SFCircleGradientView *progressView3;
@property (nonatomic) SFCircleGradientView *progressView4;
@property (nonatomic) SFCircleGradientView *progressView5;
@property (nonatomic) SFCircleGradientView *progressView6;
@property (nonatomic) SFCircleGradientView *progressView7;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subTitleLabel;



@property (weak, nonatomic) IBOutlet UIView *messageSetup;
@property (weak, nonatomic) IBOutlet UITextField *inputName;
@property (weak, nonatomic) IBOutlet UITextField *inputWeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stepWeight;
- (IBAction)stepWeightChange:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *inputHeight;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stepHeight;
- (IBAction)stepHeightChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
- (IBAction)buttonStartAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewValues;

@property (weak, nonatomic) IBOutlet UILabel *labelTp1;
@property (weak, nonatomic) IBOutlet UILabel *labelTp2;
@property (weak, nonatomic) IBOutlet UILabel *labelTp3;
@property (weak, nonatomic) IBOutlet UILabel *labelTp4;
@property (weak, nonatomic) IBOutlet UILabel *labelTp5;
@property (weak, nonatomic) IBOutlet UILabel *labelTp6;
@property (weak, nonatomic) IBOutlet UILabel *labelTp7;

@property (weak, nonatomic) IBOutlet UILabel *labelPer1;
@property (weak, nonatomic) IBOutlet UILabel *labelPer2;
@property (weak, nonatomic) IBOutlet UILabel *labelPer3;
@property (weak, nonatomic) IBOutlet UILabel *labelPer4;
@property (weak, nonatomic) IBOutlet UILabel *labelPer5;
@property (weak, nonatomic) IBOutlet UILabel *labelPer6;
@property (weak, nonatomic) IBOutlet UILabel *labelPer7;

@property (weak, nonatomic) IBOutlet UILabel *labelVal1;
@property (weak, nonatomic) IBOutlet UILabel *labelVal2;
@property (weak, nonatomic) IBOutlet UILabel *labelVal3;
@property (weak, nonatomic) IBOutlet UILabel *labelVal4;
@property (weak, nonatomic) IBOutlet UILabel *labelVal5;
@property (weak, nonatomic) IBOutlet UILabel *labelVal6;
@property (weak, nonatomic) IBOutlet UILabel *labelVal7;

@property (weak, nonatomic) IBOutlet UIView *viewOverMenu;
@property (weak, nonatomic) IBOutlet UIButton *buttonOver;
- (IBAction)buttonOverAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewOverButtons;

@property (weak, nonatomic) IBOutlet UIButton *buttonBottom1;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom2;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom3;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom4;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom5;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom6;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom7;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottom8;
- (IBAction)buttonBottomAction1:(id)sender;
- (IBAction)buttonBottomAction2:(id)sender;
- (IBAction)buttonBottomAction3:(id)sender;
- (IBAction)buttonBottomAction4:(id)sender;
- (IBAction)buttonBottomAction5:(id)sender;
- (IBAction)buttonBottomAction6:(id)sender;
- (IBAction)buttonBottomAction7:(id)sender;
- (IBAction)buttonBottomAction8:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewGraph;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFilter;
- (IBAction)segmentFilterAction:(id)sender;

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UILabel *labelOverButton1;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton2;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton3;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton4;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton5;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton6;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton7;
@property (weak, nonatomic) IBOutlet UILabel *labelOverButton8;

@property (weak, nonatomic) IBOutlet UILabel *labelST;
@property (weak, nonatomic) IBOutlet UILabel *labelSN;
@property (weak, nonatomic) IBOutlet UILabel *labelSW;
@property (weak, nonatomic) IBOutlet UILabel *labelSH;
@property (weak, nonatomic) IBOutlet UILabel *labelSD;

@end
