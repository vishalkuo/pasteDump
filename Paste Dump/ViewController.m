//
//  ViewController.m
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-05-10.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ViewController ()

-(void)setHide:(BOOL)isHidden;

@end

@implementation ViewController  

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHide:YES];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    CGPoint loginPos = self.view.center;
    loginPos.y += 150;
    loginButton.center = loginPos;
    [self.view addSubview:loginButton];
    
    
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.delegate = self;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self setHide:NO];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *output = [NSString stringWithFormat:@"Welcome, %@", result[@"name"]];
                 self.loginStat.text = output;
                 NSLog(@"fetched user:%@", result);
                 [self setHide:NO];
             }
         }];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    self.loginStat.hidden = isHidden;
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [self setHide:YES];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [self setHide:NO];
}


@end
