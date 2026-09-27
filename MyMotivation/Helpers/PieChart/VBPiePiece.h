

#import <QuartzCore/QuartzCore.h>

@interface VBPiePiece : CAShapeLayer

@property (nonatomic) float innerRadius;
@property (nonatomic) float outerRadius;

@property (nonatomic) double value;
@property (nonatomic, strong) NSString *pieceName;

/*
 Actual angle of segment
 */
@property (nonatomic, readonly) float angle;

/*
 Start angle for segment
 */
@property (nonatomic, readonly) float startAngle;

// Default is NO
@property (nonatomic, readonly) BOOL accent;

// Default is 0.1 (i.e. 10%) of innerRadius
@property (nonatomic) float accentPrecent;


- (BOOL) animateToAccent:(float)accentPrecent;

- (void) pieceAngle:(float)angle start:(float)startAngle;


@end
