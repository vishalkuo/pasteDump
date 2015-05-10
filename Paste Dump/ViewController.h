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

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailDisplayLabel;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;

@end

