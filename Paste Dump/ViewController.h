//
//  ViewController.h
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-05-10.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController : UIViewController <FBSDKLoginButtonDelegate>{
    NSString *mostRecentPaste;
    NSString *username;
}

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginStat;
@property (weak, nonatomic) IBOutlet UILabel *mostRecentPaste;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

-(void)startSpinning;
-(void)stopSpinning;

@end

