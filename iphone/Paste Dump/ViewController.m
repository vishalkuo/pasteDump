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
#import "ToastView.h"
#import "Reachability.h"

@interface ViewController ()

-(void)setHide:(BOOL)isHidden;
-(void)startSpinning;
-(void)stopSpinning;
-(void)fbMethod;
-(void)setButtonTitle;
-(void)copyToClipboard;
-(void)togglePaste;
-(void)fbLoginProcedure;
-(void)customAuthLoginProcedure:(BOOL)shouldBeCreated;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isInPasteState = NO;
    [_makePasteField setReturnKeyType:UIReturnKeySend];
    
    self.makePasteField.delegate = self;
    //=====UI DECLARATION=====//
    [self setPasteValue:@""];
    _loginManager = [[FBSDKLoginManager alloc] init];
    
    
    
    [_facebookButton addTarget:self
               action:@selector(actionSheetInitializer)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_clipboardButton addTarget:self action:@selector(copyToClipboard) forControlEvents:UIControlEventTouchUpInside];
    
    [_makeAPasteButton addTarget:self action:@selector(makeAPasteButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [_refreshButton addTarget:self action:@selector(refreshScreen) forControlEvents:UIControlEventTouchUpInside];
    
    
    //=====POST INFO=====//
    _url = [NSURL URLWithString:@"http://vishalkuo.com/pastebin.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    _req = [[NSMutableURLRequest alloc] initWithURL:_url];
    _req.HTTPMethod = @"POST";
    
    //=====STATE ADJUSTMENT=====//
    if ([FBSDKAccessToken currentAccessToken]) {
        [self fbLoginProcedure];
        _isLoggedIn = NO;
    }else if (_isLoggedIn){
        [self customAuthLoginProcedure:YES];
    }else{
        [self stopSpinning];
        [self setHide:YES];
    }
        [self setButtonTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setHide:(BOOL)isHidden{
    if (isHidden){
        _mostRecentPaste.text = @"";
        _loginStat.text = @"";
        [self stopSpinning];
    }else{
        _loginStat.alpha = 1.0f;
        _makeAPasteButton.alpha = 1.0f;
        _mostRecentPaste.alpha = 1.0f;
        _clipboardButton.alpha = 1.0f;
        _refreshButton.alpha = 1.0f;
    }

}
-(void)makeAPasteButtonMethod{
    if ([FBSDKAccessToken currentAccessToken]){
        [self togglePaste];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock Full Functionality" message:@"To make pastes and view your past pastes, log in with Facebook!"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log In", nil];
        
        [alert show];
    }
    
}
-(void)togglePaste{
    if ([FBSDKAccessToken currentAccessToken] || _isLoggedIn){
        if(!_isInPasteState){
            _mostRecentPaste.alpha = 0;
            _makePasteField.alpha = 1;
            _loginStat.alpha = 0;
            _refreshButton.alpha = 0;
            _makePasteField.text = @"";
            [_clipboardButton setTitle:@"Send" forState:UIControlStateNormal];
            [_makeAPasteButton setTitle:@"Back" forState:UIControlStateNormal];
        }else{
            _mostRecentPaste.alpha = 1;
            _makePasteField.alpha = 0;
            _loginStat.alpha = 1;
            _refreshButton.alpha = 1;
            [_clipboardButton setTitle:@"Copy to Clipboard" forState:UIControlStateNormal];
            [_makeAPasteButton setTitle:@"Make a Paste" forState:UIControlStateNormal];
        }
        _isInPasteState = !_isInPasteState;
    }

}


-(void)fadeOutAnimation:(UIView *)target{
    [UIView animateWithDuration:0.2 animations:^{target.alpha = 0.0;}];
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

-(void)fbLoginProcedure{
    //=====FACEBOOK AUTHENTICATION=====//
    if ([self isConnected]){
        [self startSpinning];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 _loginStat.text = [NSString stringWithFormat:@"Welcome, %@. \n Your most recent paste was: ", result[@"first_name"]];
                 _userId = result[@"id"];
                 //=====DECLARATION FOR POST REQUEST=====//
                 NSString *postString =  [NSString stringWithFormat:@"id=%@&code=0\n", _userId];
                 NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                 NSLog(postString);
                 if(!error){
                     _uploadTask = [_session uploadTaskWithRequest:_req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                         NSArray *paste = [_json valueForKey:@"paste"];
                         NSArray *res = [_json valueForKey:@"response"];
                         (dispatch_async(dispatch_get_main_queue(), ^{
                            [self setHide:NO];
                            _facebookButton.alpha = 1.0f;
                             _pasteValue = paste[0];
                             [self stopSpinning];
                             if([res[0] integerValue] == 100){
                                 _mostRecentPaste.text = @"No pastes found";
                             }else{
                                 _mostRecentPaste.text = _pasteValue;
                            }

                         }));
                     }];
                 }
                 [_uploadTask resume];
             }
         }];
    }else{
        [self setHide:NO];
        _loginStat.text = @"No internet connection.\n Please try again later.";
    }
            [self stopSpinning];


}

-(void)setButtonTitle{
    if ([FBSDKAccessToken currentAccessToken]) {
        [_facebookButton setTitle:@"Logout" forState:UIControlStateNormal];
    }else{
        [_facebookButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

-(void)fbMethod{
    //Double declaration because of race condition

    if ([FBSDKAccessToken currentAccessToken] || _isLoggedIn){
        _isInPasteState = YES;
        [self togglePaste];
        [self setHide:YES];
        [_loginManager logOut];
        [self setButtonTitle];
    }
    else if ([self isConnected]){
        [_loginManager logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error){
            } else if (result.isCancelled){
            }else{
                [self fbLoginProcedure];
                [self setButtonTitle];
            }
        }];
    }else{
        [ToastView showToast:self.view withText:@"No Internet!" withDuaration:1.0];
    }
}

-(void)actionSheetInitializer{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How do you want to login?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook", @"I Have An Account", @"Create An Account", nil];
    actionSheet.tag = 1;
    
    UIActionSheet *logoutSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to logout?"delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
    logoutSheet.tag = 2;

    if ([FBSDKAccessToken currentAccessToken] || _isLoggedIn){
        [logoutSheet showInView:self.view];
    }else{
        [actionSheet showInView:self.view];
    }
}
-(void)initHide{
    _loginStat.alpha = 0;
    _makeAPasteButton.alpha = 0;
    _mostRecentPaste.alpha = 0;
    _clipboardButton.alpha = 0;
    _refreshButton.alpha = 0;
}

-(void)copyToClipboard{
    if ([FBSDKAccessToken currentAccessToken]){
        if (!_isInPasteState){
            NSString *copyValue = _mostRecentPaste.text;
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
            [pasteBoard setString:copyValue];
            [ToastView showToast:self.view withText:@"Copied to Clipboard!" withDuaration:0.75];
        }else{
            [self sendPasteWithText:_makePasteField.text];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unlock Full Functionality" message:@"To make pastes and view your past pastes, log in with Facebook!"  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log In", nil];
        
        [alert show];
    }

   
}

- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendPasteWithText:textField.text];
    return YES;
}

-(void)sendPasteWithText:(NSString *)sendValue{
    NSString *postString = [NSString stringWithFormat:@"id=%@&code=1&paste=%@", _userId, sendValue];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    _pasteTask = [_session uploadTaskWithRequest:_req fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        (dispatch_async(dispatch_get_main_queue(), ^{
            [ToastView showToast:self.view withText:@"Sent!" withDuaration:0.75];
        }));
    }];
    if ([self isConnected]){
        [_pasteTask resume];
        _makePasteField.text = @"";
    }else{
        [ToastView showToast:self.view withText:@"No Internet!" withDuaration:1.0];
    }
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if(motion == UIEventSubtypeMotionShake && [FBSDKAccessToken currentAccessToken]){
        [self refreshScreen];
    }
}

-(void)refreshScreen{
    if ([self isConnected] && [FBSDKAccessToken currentAccessToken]){
        [ToastView showToast:self.view withText:@"Refreshing!" withDuaration:0.75];
            [self fbLoginProcedure];
    }
}

-(BOOL)isConnected{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus stat = [networkReachability currentReachabilityStatus];
    if (stat == NotReachable){
        return NO;
    }else{
        return YES;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Log In"]){
        if ([self isConnected]){
            [_loginManager logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                if (error){
                } else if (result.isCancelled){
                }else{
                    [self fbLoginProcedure];
                    [self setButtonTitle];
                }
            }];
        }else{
            [ToastView showToast:self.view withText:@"No Internet!" withDuaration:1.0];
        }
    }else if ([title isEqualToString:@"Sign Up"]){
        UITextField *username = [alertView textFieldAtIndex:0];
        UITextField *password = [alertView textFieldAtIndex:1];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(actionSheet.tag){
        case 1:
            switch(buttonIndex){
                case 0:
                    [self fbMethod];
                    break;
                case 1:
                    [self customAuthLoginProcedure:false];
                    break;
                case 2:
                    [self customAuthLoginProcedure:true];
                    break;
            }
            break;
        case 2:
            switch(buttonIndex){
                case 0:
                    [self fbMethod];
                    break;
            }
    }
}

-(void)customAuthLoginProcedure:(BOOL)shouldBeCreated{
    if (!shouldBeCreated){
        [self oldUserLogin];
    }else{
        [self newUserSetup];
    }
}

-(void)newUserSetup{
    UIAlertView *setup = [[UIAlertView alloc] initWithTitle:@"Sign Up" message:@"Enter your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign Up", nil];
    setup.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [setup textFieldAtIndex:0].delegate = self;
    [setup show];
}

-(void)oldUserLogin{
    UIAlertView *login = [[UIAlertView alloc] initWithTitle:@"Welcome Back" message:@"Enter your username and password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
    login.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [login textFieldAtIndex:0].delegate = self;
    [login show];
    
}



@end
