//
//  SpinnerPlugin.m
//  IMG Cinema
//
//  Created by Andrea Maschio on 24/12/13.
//
//
//

#import "SpinnerPlugin.h"
#import <Cordova/CDV.h>
#define PARAM_SHOW_OVERLAY @"overlay"
#define PARAM_AUTO_HIDE_TIMEOUT @"timeout"
#define PARAM_BACKGROUND_COLOR_HEX @"color"
#define PARAM_SPINNER_SIZE @"size"

@implementation SpinnerPlugin
- (void)pluginInitialize{
    //params init
    showOverlay = YES;
    connectionTimeout = 0;
    backgroundColorHex = @"#FFFFFF";
    spinnerSize = @"large";
}
-(void)show:(CDVInvokedUrlCommand*)options{
    NSMutableDictionary* params = [options.arguments objectAtIndex:0];

    ;
    
    if([params objectForKey:PARAM_AUTO_HIDE_TIMEOUT]){
        id connectiontimeout =[params objectForKey:PARAM_AUTO_HIDE_TIMEOUT];
        
        if([connectiontimeout isKindOfClass:[NSString class]]){
            NSScanner*scan = [NSScanner scannerWithString:(NSString*)connectiontimeout];
            [scan scanInt:&connectionTimeout];
        }else if([connectiontimeout isKindOfClass:[NSNumber class]]){
            connectionTimeout = [connectiontimeout intValue];
        }
    }
    
    if([params objectForKey:PARAM_SPINNER_SIZE]){
        if([[params objectForKey:PARAM_SPINNER_SIZE] isKindOfClass:[NSString class]]){
            spinnerSize = [params objectForKey:PARAM_SPINNER_SIZE];
        }
    }
    
    if([params objectForKey:PARAM_BACKGROUND_COLOR_HEX]){
        if([[params objectForKey:PARAM_SPINNER_SIZE] isKindOfClass:[NSString class]]){
            backgroundColorHex = [params objectForKey:PARAM_BACKGROUND_COLOR_HEX];
        }
    }
    
    id overlayParam = [params objectForKey:PARAM_SHOW_OVERLAY];
    
    if ([overlayParam isKindOfClass:[NSString class]])
    {
        if ([overlayParam isEqualToString:@"false"])
            showOverlay = NO;
    }
    else if (![overlayParam boolValue])
        showOverlay = NO;
    else
        showOverlay = YES;
    
    if(!indicator){
        indicator = [[UIActivityIndicatorView alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    }else{
        [indicator removeFromSuperview];
    }
    
    if ([spinnerSize  isEqual: @"small"]) {
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    } else {
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    [indicator setColor:[self colorFromHexString:backgroundColorHex]];
    
    if(connectionTimeout>0){
        NSTimer *timer __attribute__((unused))= [NSTimer scheduledTimerWithTimeInterval:connectionTimeout target:self selector:@selector(hideAfterTimeout:) userInfo:Nil repeats:NO];
    }
    
    if(!background) {
        background = [[UIView alloc]initWithFrame:[UIScreen  mainScreen].bounds];
    }
    
    [background setBackgroundColor:[UIColor blackColor]];
//    [background setAlpha:0.0f];
    background.userInteractionEnabled=NO;
    
    
    if(showOverlay){
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.0];
        [background setAlpha:0.4];
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:NULL context:NULL];
        [UIView setAnimationDuration:0.0];
        [background setAlpha:0.0];
        [UIView commitAnimations];
    }
    
    [self.viewController.view addSubview:background];
    [self.viewController.view addSubview:indicator];
[indicator startAnimating];
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void)hideAfterTimeout:(NSTimer*)timer{
    //NSLog(@"Hiding");
    [timer invalidate];
    [self hide:nil];
}
-(void)hide:(CDVInvokedUrlCommand*)options{
    //NSLog(@"Hiding2");
    [indicator stopAnimating];
    [background removeFromSuperview];
    [indicator removeFromSuperview];

}
-(void)dispose{
    [super dispose];
    //NSLog(@"disposing plugin");
    indicator=nil;
    background = nil;
}
@end
