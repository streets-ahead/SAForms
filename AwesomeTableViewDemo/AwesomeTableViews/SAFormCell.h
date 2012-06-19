#import <UIKit/UIKit.h>

typedef enum {
	SAFormCellBorderNone,
    SAFormCellBorderTop = 1 << 0,
    SAFormCellBorderRight = 1 << 1,
    SAFormCellBorderBottom = 1 << 2,
    SAFormCellBorderLeft = 1 << 3,
    SAFormCellBorderAll = 0xfff
} SAFormCellBorder;

@class SAFormCellConfig;

typedef void (^FormControlFormatter) (UIControl* cell);

@interface SAFormCell : UITableViewCell
@property (weak) SAFormCellConfig* currentConfig;
@property (strong) id formControl;
@property (assign) BOOL clearBackground;
@property (assign) int border;
@property (strong) UIColor* borderColor;
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

