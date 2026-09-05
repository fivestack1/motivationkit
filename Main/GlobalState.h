#import <sqlite3.h>

#define Settings [NSUserDefaults standardUserDefaults]
static NSString *databasePath;
static sqlite3 *myappDB;

/*#define blue_color [UIColor colorWithRed:(53/255.0) green:(153/255.0) blue:(219/255.0) alpha:1]//3599db
#define orange_color [UIColor colorWithRed:(255/255.0) green:(175/255.0) blue:(65/255.0) alpha:1]//ffaf41
#define green_color [UIColor colorWithRed:(91/255.0) green:(220/255.0) blue:(101/255.0) alpha:1]//5bdc65
#define red_color [UIColor colorWithRed:(232/255.0) green:(78/255.0) blue:(60/255.0) alpha:1]//e84e3c
#define purple_color [UIColor colorWithRed:(155/255.0) green:(89/255.0) blue:(181/255.0) alpha:1]
#define pink_color [UIColor colorWithRed:(202/255.0) green:(112/255.0) blue:(210/255.0) alpha:1]
#define yellow_color [UIColor colorWithRed:(243/255.0) green:(228/255.0) blue:(97/255.0) alpha:1]
#define dark_purple_color [UIColor colorWithRed:(165/255.0) green:(142/255.0) blue:(255/255.0) alpha:1]
#define dark_pink_color [UIColor colorWithRed:(255/255.0) green:(81/255.0) blue:(156/255.0) alpha:1]*/
#define light_color [UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1]
#define ultra_light_color [UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1]

#define main_color1 [UIColor colorWithRed:(111/255.0) green:(207/255.0) blue:(151/255.0) alpha:1]//00b3be
#define main_color2 [UIColor colorWithRed:(131/255.0) green:(139/255.0) blue:(197/255.0) alpha:1]//838bc5
#define main_color3 [UIColor colorWithRed:(103/255.0) green:(192/255.0) blue:(144/255.0) alpha:1]//838bc5

#define accent_color1 [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]//353735
#define accent_color2 [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1]//b7b8b8

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONEX ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIScreen.mainScreen.nativeBounds.size.height == 2436)
#define IS_IPHONEXR ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIScreen.mainScreen.nativeBounds.size.height == 1792)
#define IS_IPHONEXSMAX ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIScreen.mainScreen.nativeBounds.size.height == 2688)

static NSString * const award1 = @"First workout";
static NSString * const award2 = @"Well done";
static NSString * const award3 = @"You look good";
static NSString * const award4 = @"Perfect body";
static NSString * const award5 = @"Clean mind";
static NSString * const award6 = @"Better than yesterday";
static NSString * const award7 = @"Nothing is impossible";
static NSString * const award8 = @"Super level";
static NSString * const award9 = @"Happy body";
static NSString * const award10 = @"Master";

static float oztoml = 29.5735296875;
static float lbtokg = 0.45359237;

static int const meditation_energies = 10;
static int const yoga_energies = 20;

static float const speak_speed = 0.5;

static int const free_limit = 20;

// App link for rating
static NSString * const rate_id = @"https://itunes.apple.com/us/app/";
static NSString * const terms_url = @"https://sites.google.com/view/iterms/";
static NSString * const privacy_url = @"https://sites.google.com/view/ipprivacy-policy/";

// Share string
static NSString * const share_string = @"Time for motivation!";

static NSString * const usda_api_key = @"gMAT6QjrDlTI1AgISJbOf2fVBedzhcscE7cMuPNF";

#if TARGET_IPHONE_SIMULATOR
static BOOL const test_device = TRUE;
#else
static BOOL const test_device = FALSE;
#endif
