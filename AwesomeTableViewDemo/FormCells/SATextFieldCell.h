//
//  SATextFieldCell.h
//  eventBum2
//
//  Created by sam mussell on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATextFieldCell : UITableViewCell {
    @private
    UIControl* _textField;
}

@property (nonatomic, retain) UIControl *textField;

@end
