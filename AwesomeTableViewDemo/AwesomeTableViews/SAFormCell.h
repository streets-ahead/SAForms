#import <UIKit/UIKit.h>

@class SAFormCellConfig;

typedef void (^FormControlFormatter) (UIControl* cell);

@interface SAFormCell : UITableViewCell
@property (weak) SAFormCellConfig* currentConfig;
@property (strong) id formControl;
- (void) setControlValue:(id) value;
- (void) valueChanged;
@end

@interface SATextCell : SAFormCell
@property (strong) UITextField* textField;
@end

@interface SASegmentedCell : SAFormCell
@property (strong) UISegmentedControl* segmentedControl;
- (void) setSegmentTitles:(NSArray*) segments;
- (void) setSegmentImages:(NSArray*) segments;
@end

@interface SAButtonCell : SAFormCell
@end

