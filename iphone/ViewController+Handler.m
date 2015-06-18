//
//  ViewController+Handler.m
//  Paste Dump
//
//  Created by Vishal Kuo on 2015-06-17.
//  Copyright (c) 2015 VishalKuo. All rights reserved.
//

#import "ViewController+Handler.h"
#import "ToastView.h"

@implementation ViewController (Handler)

/*-(void)confirmNewUser:(NSArray*)jsonVal{
    NSDictionary *dict = jsonVal[0];
    NSInteger *responseInt = [[dict valueForKey:@"COUNT(1)"] integerValue];
    if (responseInt == 0){
        [ToastView showToast:self withText:@"Success!" withDuaration:1.0];
    }
}*/

-(void)confirmNewUser:(NSArray *)jsonVal :(UIView *)view{
    NSDictionary *dict = jsonVal[0];
    NSString *response = [dict valueForKey:@"COUNT(1)"];
    if ([response isEqualToString:@"0"]){
        
        [ToastView showToast:view withText:@"Success!" withDuaration:1.0];
    }
}

@end
