//
//  ChangePasswordViewController.h
//  Club
//
//  Created by apple on 14-11-7.
//  Copyright (c) 2014年 martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardViewController.h"
@interface ChangePasswordViewController : UIViewController <UIKeyboardViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword2;
- (IBAction)go:(id)sender;

@end
