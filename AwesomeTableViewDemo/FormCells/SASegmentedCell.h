#import "SAFormCell.h"

@interface SASegmentedCell : SAFormCell
@property (strong) UISegmentedControl* segmentedControl;
- (void) setSegmentTitles:(NSArray*) segments;
- (void) setSegmentImages:(NSArray*) segments;
@end
