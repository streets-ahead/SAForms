//
// Copyright (c) 2012 Streets Ahead LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
// Software, and to permit persons to whom the Software is furnished to do so, subject 
// to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR 
// A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

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
@synthesize boundIndex = _boundIndex;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)init {
    self = [super init];
    if (self) {
        self.cellClass = [SAFormCell class];
        self.cellStyle = UITableViewCellStyleDefault;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.height = 44;
        self.boundIndex = -1;
        self.reuseIdentifier = @"";
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
    } else if([self.boundObject isKindOfClass:[NSMutableArray class]]) {
        @try {
            [self.boundObject replaceObjectAtIndex:self.boundIndex withObject:value];   
        } @catch (NSException *exception) { 
            NSLog(@"undefined keypath %d", self.boundIndex); 
        }
    } else {
        self.boundObject = value;
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
    }else if([self.boundObject isKindOfClass:[NSMutableArray class]]) {
        @try {
            boundValue = [self.boundObject objectAtIndex:self.boundIndex];
        } @catch (NSException *exception) { 
            NSLog(@"undefined keypath %@", self.boundObjectKeyPath); 
        } 
    }else if (self.boundObject != nil) {
        boundValue = self.boundObject;
    }
    return boundValue;
}

- (UITableViewCell*) formatCell:(SAFormCell*)cell {
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
    
    if([self boundValue] != nil) {
        [cell setControlValue:[self boundValue]];   
    }
        
    if(self.formControlFormatBlock != nil && cell.formControl != nil) {
        self.formControlFormatBlock(cell.formControl);
    }
    
    return cell;
}
@end
