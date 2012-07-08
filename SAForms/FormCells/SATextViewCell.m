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


#import "SATextViewCell.h"
#import "SAFormCellConfig.h"
#import "SAFormTableViewController.h"

@implementation SATextViewCell
@synthesize textView = _textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];     
        _textView.scrollEnabled = YES;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.textColor = [UIColor colorWithWhite:.4 alpha:1];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        _textView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textView];
        self.formControl = _textView;
        NSLog(@"!!! %@", self.textLabel);
        self.textLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}
 
- (void) setTextFieldDelegate:(id)delegate {
    self.textView.delegate = delegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%@", self.textLabel.text);
    
    CGRect formRect = CGRectMake(5, 5, 
                                 self.contentView.bounds.size.width - 10, 
                                 self.contentView.bounds.size.height - 10);
    self.textView.frame = formRect;
    [self.contentView bringSubviewToFront:self.textView];
    self.textLabel.frame = formRect;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.currentConfig valueUpdated:self.textView.text];
}
 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    id supr = self.superview;
    if(supr != nil && [supr isKindOfClass:[UITableView class]]) {   
        if([[supr delegate] respondsToSelector:@selector(registerFirstResponder:)]) {
            [[supr delegate] registerFirstResponder:self];
        }
    }
    self.textLabel.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    id supr = self.superview;
    if(supr != nil && [supr isKindOfClass:[UITableView class]]) {   
        if([[supr delegate] respondsToSelector:@selector(deRegisterFirstResponder:)]) {
            [[supr delegate] deRegisterFirstResponder:self];
        }
    }
    if(self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        self.textLabel.hidden = NO;
    }
}

- (void) setControlValue:(id) value {
    self.textView.text = value;
}

@end
