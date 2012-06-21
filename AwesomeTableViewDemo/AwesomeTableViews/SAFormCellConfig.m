#import "SAFormCellConfig.h"
#import "SAFormCell.h"

@implementation SAFormCellConfig {
    NSMutableArray* _cellFormatterBlocks;
}
@synthesize height = _height; 
@synthesize cellClass = _cellClass;
@synthesize selectedBlock = _actionBlock;
@synthesize cellStyle = _cellStyle;
@synthesize cellProperties = _cellProperties;
@synthesize selectionStyle = _selectionStyle;
@synthesize defaultLabel = _defaultLabel;
@synthesize boundObjectKeyPath = _boundObjectKeyPath;
@synthesize boundObject = _boundObject;
@synthesize valueChangedBlock = _valueChangedBlock;
@synthesize formControlFormatBlock = _formControlFormatBlock;

- (id)init {
    self = [super init];
    if (self) {
        self.cellClass = [SAFormCell class];
        self.cellStyle = UITableViewCellStyleDefault;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.height = 44;
    }
    return self;
}

- (id)initWithCellClass:(Class)clazz {
    self = [self init];
    if (self) {
        self.cellClass = clazz;
    }
    return self;
}

- (id)initWithLabel:(NSString*)label {
    self = [self init];
    if (self) {
        self.defaultLabel = label;
    }
    return self;
}

- (id)initWithCellClass:(Class)clazz boundObject:(id)boundedObject boundPath:(NSString*)path {
    self = [self initWithCellClass:clazz];
    if (self) {
        self.boundObject = boundedObject;
        self.boundObjectKeyPath = path;
    }
    return self;
}

- (void) addFormatterBlock:(FormatBlock)block {
    if(_cellFormatterBlocks == nil) {
        _cellFormatterBlocks = [NSMutableArray array];
    }
    //TODO: investigate if the copy is needed, from what I've read it may be
    [_cellFormatterBlocks addObject:[block copy]];
}

- (void) valueUpdated:(id)value {    
    if(self.boundObject != nil && self.boundObjectKeyPath != nil) {
        @try {
            [self.boundObject setValue:value forKey:self.boundObjectKeyPath];   
        } @catch (NSException *exception) { 
            NSLog(@"undefined keypath %@", self.boundObjectKeyPath); 
        }
    }
    
    if(self.valueChangedBlock != nil) {
        self.valueChangedBlock(value);
    }
}

- (id) boundValue {
    id boundValue = nil;
    if(self.boundObject != nil && self.boundObjectKeyPath != nil) {    
        @try {
            boundValue = [self.boundObject valueForKeyPath:self.boundObjectKeyPath];
        } @catch (NSException *exception) { 
            NSLog(@"undefined keypath %@", self.boundObjectKeyPath); 
        }    
    }
    return boundValue;
}

- (UITableViewCell*) formatCell:(SAFormCell*)cell {
    NSLog(@"formatting cell %@", self.defaultLabel);
    cell.textLabel.text = self.defaultLabel;
    cell.selectionStyle = self.selectionStyle;
    cell.currentConfig = self;
    if(self.cellProperties != nil) {
        [self.cellProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [cell setValue:obj forKeyPath:key];
        }];
    }
    
    if(_cellFormatterBlocks != nil) {
        for (FormatBlock formatter in _cellFormatterBlocks) {
            formatter(cell);
        }
    }
    
    if(self.boundObject != nil && self.boundObjectKeyPath != nil) {    
        @try {
            [cell setControlValue: [self.boundObject valueForKeyPath:self.boundObjectKeyPath]];
        } @catch (NSException *exception) { 
            NSLog(@"undefined keypath %@", self.boundObjectKeyPath); 
        }    
    }
    
    if(self.formControlFormatBlock != nil && cell.formControl != nil) {
        self.formControlFormatBlock(cell.formControl);
    }
    
    return cell;
}
@end
