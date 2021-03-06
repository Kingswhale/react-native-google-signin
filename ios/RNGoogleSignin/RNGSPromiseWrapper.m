//
//  PromiseWrapper.m
//  RNGoogleSignin
//
//  Created by Vojtech Novak on 26/07/2018.
//  Copyright © 2018 Apptailor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNGSPromiseWrapper.h"


@interface RNGSPromiseWrapper ()

@property (nonatomic, strong) RCTPromiseResolveBlock promiseResolve;
@property (nonatomic, strong) RCTPromiseRejectBlock promiseReject;
@property (readwrite, assign) NSString *nameOfCallInProgress;

@end

@implementation RNGSPromiseWrapper

-(BOOL)setPromiseWithInProgressCheck: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject fromCallSite:(NSString *) callsite {
  if (self.promiseResolve) {
    return NO;
  }
  self.promiseResolve = resolve;
  self.promiseReject = reject;
  self.nameOfCallInProgress = callsite;
  return YES;
}

-(void)resolve: (id) result {
  RCTPromiseResolveBlock resolver = self.promiseResolve;
  if (resolver == nil) {
    NSLog(@"cannot resolve promise because it's null");
    return;
  }
  [self resetMembers];
  resolver(result);
}

-(void)reject:(NSString *)message withError:(NSError *)error {
  RCTPromiseRejectBlock rejecter = self.promiseReject;
  if (rejecter == nil) {
    NSLog(@"cannot resolve promise because it's null");
    return;
  }
  NSString* errorCode = [NSString stringWithFormat:@"%ld", error.code];
  NSString* errorMessage = [NSString stringWithFormat:@"RNGoogleSignInError: %@, %@", message, error.description];
  
  [self resetMembers];
  rejecter(errorCode, errorMessage, error);
}

-(void)resetMembers {
  self.promiseResolve = nil;
  self.promiseReject = nil;
  self.nameOfCallInProgress = nil;
}


@end
