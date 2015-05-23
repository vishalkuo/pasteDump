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
-(void)startSpinning;
-(void)stopSpinning;
-(void)fbMethod;
-(void)setButtonTitle;

@end

@implementation ViewController  

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //=====UI DECLARATION=====//
    [self setHide:YES];
    [self setPasteValue:@""];
    
    _bgImage = [UIImage imageNamed:@"ButtonBg.png"];
    _fbBgImage = [UIImage imageNamed:@"ButtonBgFb.png"];
    _loginManager = [[FBSDKLoginManager alloc] init];
    
    [_facebookButton addTarget:self
               action:@selector(fbMethod)
     forControlEvents:UIControlEventTouchUpInside];
    
    //=====POST INFO=====//
    _url = [NSURL URLWithString:@"http://www.vishalkuo.com/pastebin.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    _req = [[NSMutableURLRequest alloc] initWithURL:_url];
    _req.HTTPMethod = @"POST";
    
    //=====STATE ADJUSTMENT=====//
    if ([FBSDKAccessToken currentAccessToken]) {
        [self loginProcedure];
        [self startSpinning];
    }else{
        [self stopSpinning];
    }
        [self setButtonTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    _loginStat.hidden = isHidden;
    _makeAPasteButton.hidden = isHidden;
    _mostRecentPaste.hidden = isHidden;
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [self setHide:YES];
    //_indicatorView.hidden = YES;
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [self setHide:NO];
    [self loginProcedure];
}

-(void)startSpinning{
    [_indicatorView startAnimating];
    _indicatorView.hidden = NO;
}

-(void)stopSpinning{
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}

-(void)setPasteValueField:(NSString *)val{
    _mostRecentPaste.text = val;
}

-(void)loginProcedure{
    //=====FACEBOOK AUTHENTICATION=====//
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 _loginStat.text = [NSString stringWithFormat:@"Welcome, %@ \n Your most recent paste was: ", result[@"first_name"]];
                 _userId = result[@"id"];
                 //=====DECLARATION FOR POST REQUEST=====//
                 NSString *postString = @"id=1&code=0";
                 NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
                 //_recentHeaderTitle.text = @"Your most recent paste was: \n";
                 if(!error){
                     _uploadTask = [_session uploadTaskWithRequest:_req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         NSArray *paste = [_json valueForKey:@"paste"];
                         (dispatch_async(dispatch_get_main_queue(), ^{
                            [self setHide:NO];
                             _pasteValue = paste[0];
                             [self stopSpinning];
                             _mostRecentPaste.text = _pasteValue;
                         }));
                     }];
                 }
                 [_uploadTask resume];
             }
         }];


}

-(void)setButtonTitle{
    if ([FBSDKAccessToken currentAccessToken]) {
        [_facebookButton setTitle:@"Logout" forState:UIControlStateNormal];
        [_facebookButton setBackgroundImage:_bgImage forState:UIControlStateNormal];
    }else{
        [_facebookButton setTitle:@"" forState:UIControlStateNormal];
        [_facebookButton setBackgroundImage:_fbBgImage forState:UIControlStateNormal];
    }
}

-(void)fbMethod{
    //Double declaration because of race conditions
    if ([FBSDKAccessToken currentAccessToken]){
        [_loginManager logOut];
        [self setHide:YES];
        [self setButtonTitle];
    }
    else{
        [_loginManager logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error){
            } else if (result.isCancelled){
            }else{
                [self loginProcedure];
                [self setButtonTitle];
            }
        }];
    }
    
    
}



@end
