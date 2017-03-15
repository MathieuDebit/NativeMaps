//
//  AudioModule.m
//  NativeMaps
//
//  Created by Mathieu Débit on 15/03/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AudioModule.h"

@implementation AudioModule

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(init,
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

  if (true) {
    resolve(@"true");
  } else {
    reject(@"get_error", @"Error", nil);
  }

}

@end
