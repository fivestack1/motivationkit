

#import <UIKit/UIKit.h>

@interface SACalendarCell : UICollectionViewCell

/**
 *  grey line above the label
 */
@property UIView *topLineView;

/**
 *  a circle that appears on the current date
 */
@property UIView *circleView;

/**
 *  a circle that appears on the selected date
 */
@property UIView *selectedView;

/**
 *  a circle that appears on the selected date
 */
@property UIView *markedView;

/**
 *  the label showing the cell's date
 */
@property UILabel *dateLabel;

@end
