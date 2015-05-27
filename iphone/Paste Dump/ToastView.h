//
//  ToastView.h
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-05-25.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (void)showToast: (UIView *)parentView withText:(NSString *)text withDuaration:(float)length;

@end