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
@property (assign) NSInteger boundIndex;
@property (copy) ValueChangedBlock valueChangedBlock;
@property (copy) FormControlFormat formControlFormatBlock;

- (id)initWithCellClass:(Class)clazz;
- (id)initWithLabel:(NSString*)label;
- (UITableViewCell*) formatCell:(SAFormCell*)cell;
- (void) valueUpdated:(id)value;
- (id) boundValue; 
- (void) addFormatterBlock:(FormatBlock)block;

@end
