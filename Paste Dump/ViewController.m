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

@end

@implementation ViewController  

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHide:YES];
    [self setPasteValue:@""];
    
    //=====FACEBOOK LOGIN BUTTON DECLARATION SECION=====//
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    CGPoint loginPos = self.view.center;
    loginPos.y += 200;
    loginButton.center = loginPos;
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
    
    //DECLARATION AREA
    _url = [NSURL URLWithString:@"http://www.vishalkuo.com/pastebin.php"];

    [self testMethod];
    
 
    
    
    if (![FBSDKAccessToken currentAccessToken]){
        _indicatorView.hidden = YES;
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    _loginStat.hidden = isHidden;
    _recentHeaderTitle.hidden = isHidden;
    _mostRecentPaste.hidden = isHidden;
}


-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    [self setHide:YES];
    _indicatorView.hidden = YES;
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    [self setHide:NO];
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

-(void)testMethod{
    //=====DECLARATION FOR POST REQUEST=====//

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:_url];
    req.HTTPMethod = @"POST";
    
    //NSString *postString = [NSString stringWithFormat:@"id=%@", _userId];
    NSString *postString = @"id=1";
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //=====FACEBOOK AUTHENTICATION=====//
    if ([FBSDKAccessToken currentAccessToken]) {
        [self startSpinning];
        [self setHide:NO];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 _loginStat.text = [NSString stringWithFormat:@"Welcome, %@", result[@"name"]];
                 _userId = result[@"id"];
                 NSLog(@"fetched user:%@", result);
                 _recentHeaderTitle.text = @"Your most recent paste was: \n";
                 if(!error){
                     _uploadTask = [session uploadTaskWithRequest:req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         NSArray *paste = [_json valueForKey:@"paste"];
                         
                         (dispatch_async(dispatch_get_main_queue(), ^{
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

}



@end
