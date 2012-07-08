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

#import "SAFormTableViewController.h"
#import "SAFormCellConfig.h"
#import "SAFormCell.h"
#import "SAFormSection.h"
#import "SAFormHeaderFooter.h"

@implementation SAFormTableViewController 

@synthesize sections = _sections;
@synthesize currentFirstResponder = _currentFirstResponder;
@synthesize keyboardAccessoryBar = _keyboardAccessoryBar;
@synthesize addKeyboardAccessroy = _addKeyboardAccessroy;

- (void)viewDidLoad {
    [super viewDidLoad];
    _sections = [NSMutableArray array];
    
    self.keyboardAccessoryBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.keyboardAccessoryBar sizeToFit];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    [self.keyboardAccessoryBar setItems:[NSArray arrayWithObjects:space, done, nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will apear");
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did dissapear");
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil];
}

- (void) keyboardWillShow:(NSNotification*)notification {
    
}

- (void) doneEditing {
    [self.currentFirstResponder.formControl resignFirstResponder];
}

// TODO: this is implemented as non-standard setter becuaes I'm not sure of the implementation
// I may want to change it later so I made the api a little abstracted.
- (void) registerFirstResponder:(SAFormCell*)cell {
    _currentFirstResponder = cell;
    if(self.addKeyboardAccessroy && [_currentFirstResponder.formControl respondsToSelector:@selector(setInputAccessoryView:)]) {
        [_currentFirstResponder.formControl setInputAccessoryView:self.keyboardAccessoryBar];
    }
}

- (void) deRegisterFirstResponder:(SAFormCell*)cell {
    if(cell == self.currentFirstResponder) {
        _currentFirstResponder = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"number of sections, %d", [self.sections count]);
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.sections objectAtIndex:section] cells] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* cellsInSection = [[self.sections objectAtIndex:indexPath.section] cells];
    return [[cellsInSection objectAtIndex:indexPath.row] height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] header].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] footer].height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] footer].title;    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] header].title;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] footer].view;    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] header].view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFormCellConfig* formCell = [[[self.sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
    NSString* reuseIdent = [NSString stringWithFormat:@"%@%@%@", formCell.cellClass, formCell.cellStyle, formCell.reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdent];
    
    if(cell == nil) {
        cell = [[formCell.cellClass alloc] initWithStyle:formCell.cellStyle reuseIdentifier:reuseIdent];
        [(SAFormCell*)cell setTextFieldDelegate:self];
    }
    
    [formCell formatCell:(SAFormCell*)cell];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFormCellConfig* formCell = [[[self.sections objectAtIndex:indexPath.section] cells] objectAtIndex:indexPath.row];
    if(formCell.selectedBlock) {
        formCell.selectedBlock(self.tableView, [self.tableView cellForRowAtIndexPath:indexPath], indexPath);   
    }
}


// TODO: revisit
// the following objects set a reference to this tableviewon the section when is added
// and remove the reference when removed.  This feels a little dirty, but its the best
// I came up with right now... will revist later.
- (SAFormSection*) addSection:(SAFormSection*) section {
    [self.sections addObject:section];
    if(section.tableView == nil) {
        section.tableView = self.tableView;
        section.sectionNumber = self.sections.count-1;
    }
    return section;
}

- (SAFormSection*) addSection:(SAFormSection*) section withAnimation:(BOOL)animation {
    [self addSection:section];
    NSIndexSet* index = [NSIndexSet indexSetWithIndex:self.sections.count-1];
    if(animation) {
        [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView insertSections:index withRowAnimation:UITableViewRowAnimationNone];  
    }
    return section;
}

- (void) replaceSection:(SAFormSection*)oldSection withSection:(SAFormSection*)newSection {
    NSInteger ind = [self.sections indexOfObject:oldSection];
    [self replaceSectionAtIndex:ind withSection:newSection];
}

- (void) replaceSectionAtIndex:(NSInteger)ind withSection:(SAFormSection*)newSection {
    [self.sections replaceObjectAtIndex:ind withObject:newSection];
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:ind];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (SAFormSection*) removeSectionAtIndex:(NSInteger) ind {
    SAFormSection* obj = [self.sections objectAtIndex:ind];
    [self.sections removeObjectAtIndex:ind];
    obj.tableView = nil;
    return obj;
}

- (SAFormSection*) removeSection:(SAFormSection*) section {
    [self.sections removeObject:section];
    section.tableView = nil;
    [self.tableView reloadData];
    return section;
}

- (void) removeSectionAtIndex:(NSInteger)ind withAnimation:(BOOL)animate{
    [self removeSectionAtIndex:ind];
    if(animate) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:ind] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:ind] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (SAFormCell*) cellForView:(UIView*)view {
    UIView* superView = view.superview;
    while (superView != nil && ![superView isKindOfClass:[SAFormCell class]]) {
        superView = superView.superview;
    }
    if(superView != nil) {
        return (SAFormCell*)superView;
    } else {
        return nil;
    }
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIView* superView = [self cellForView:textField];
    if(superView != nil) {
        [self registerFirstResponder:(SAFormCell*)superView];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIView* superView = [self cellForView:textField];
    if(superView != nil) {
        [self deRegisterFirstResponder:(SAFormCell*)superView];
    }
}

// These are implemented because I may use them later and I want my subclasses 
// to be able to call [super ...]
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    UIView* superView = [self cellForView:textView];
    if(superView != nil) {
        [self registerFirstResponder:(SAFormCell*)superView];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    UIView* superView = [self cellForView:textView];
    if(superView != nil) {
        [self deRegisterFirstResponder:(SAFormCell*)superView];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}


@end

