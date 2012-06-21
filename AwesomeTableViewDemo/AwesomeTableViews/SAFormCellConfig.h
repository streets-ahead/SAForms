#import <Foundation/Foundation.h>

@class SAFormCell;

#define BACKGROUND_COLOR @"backgroundColor"
#define TEXT_COLOR @"textLabel.textColor"
#define TEXT_BACKGROUND @"textLabel.backgroundColor"

@class SAFormCellConfig;

typedef void (^ActionBlock)(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath);
typedef void (^ValueChangedBlock)(id value);
typedef void (^FormatBlock) (SAFormCell* cell);
typedef void (^FormControlFormat) (id formControl);

@interface SAFormCellConfig : NSObject
@property (assign) CGFloat height; 
@property (assign) Class cellClass;
@property (copy) ActionBlock selectedBlock;
@property (assign) UITableViewCellStyle cellStyle;
@property (strong) NSDictionary* cellProperties;
@property (strong) NSString* defaultLabel;
@property (assign) UITableViewCellSelectionStyle selectionStyle;
@property (strong) NSString* boundObjectKeyPath;
@property (strong) id boundObject;
@property (copy) ValueChangedBlock valueChangedBlock;
@property (copy) FormControlFormat formControlFormatBlock;

- (id)initWithCellClass:(Class)clazz;
- (id)initWithLabel:(NSString*)label;
- (UITableViewCell*) formatCell:(SAFormCell*)cell;
- (void) valueUpdated:(id)value;
- (id) boundValue; 
- (void) addFormatterBlock:(FormatBlock)block;

@end
