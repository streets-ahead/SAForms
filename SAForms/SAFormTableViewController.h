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

@class SAFormCell;
@class SAFormCellConfig;
@class SAFormSection;

@interface SAFormTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, readonly) NSMutableArray* sections;
@property (strong) UIToolbar* keyboardAccessoryBar;
@property (assign) BOOL addKeyboardAccessroy;
@property (strong, readonly) SAFormCell* currentFirstResponder;

- (SAFormSection*) addSection:(SAFormSection*) section;
- (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation;

- (SAFormSection*) removeSection:(SAFormSection*) section;
- (SAFormSection*) removeSectionAtIndex:(NSInteger) ind;

- (void) removeSectionAtIndex:(NSInteger)ind withAnimation:(BOOL)animate;

- (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection;
- (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection;

- (void) keyboardWillShow:(NSNotification*)notification;

- (void) registerFirstResponder:(SAFormCell*)cell;
- (void) deRegisterFirstResponder:(SAFormCell*)cell;
- (void) doneEditing;
- (SAFormCell*) cellForView:(UIView*)view;
@end
