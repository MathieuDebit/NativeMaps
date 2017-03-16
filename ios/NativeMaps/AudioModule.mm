//
//  AudioModule.m
//  NativeMaps
//
//  Created by Mathieu Débit on 15/03/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AudioModule.h"
#import <AVFoundation/AVAudioSession.h>
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredSimple.h"
#import <stdlib.h>

#define HEADROOM_DECIBEL 3.0f
static const float headroom = powf(10.0f, -HEADROOM_DECIBEL * 0.025);


@implementation AudioModule {
  SuperpoweredAdvancedAudioPlayer *playerA, *playerB;
  SuperpoweredIOSAudioIO *output;
  unsigned char activeFx;
  float *stereoBuffer, crossValue, volA, volB;
  unsigned int lastSamplerate;
}

void playerEventCallbackA(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->playerA->setBpm(126.0f);
    self->playerA->setFirstBeatMs(353);
    self->playerA->setPosition(self->playerA->firstBeatMs, false, false);
  };
}

void playerEventCallbackB(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->playerB->setBpm(123.0f);
    self->playerB->setFirstBeatMs(40);
    self->playerB->setPosition(self->playerB->firstBeatMs, false, false);
  };
}

static bool audioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
  __unsafe_unretained AudioModule *self = (__bridge AudioModule *)clientdata;
  if (samplerate != self->lastSamplerate) {
    self->lastSamplerate = samplerate;
    self->playerA->setSamplerate(samplerate);
    self->playerB->setSamplerate(samplerate);
  };
  
  bool masterIsA = (self->crossValue <= 0.5f);
  float masterBpm = masterIsA ? self->playerA->currentBpm : self->playerB->currentBpm;
  double msElapsedSinceLastBeatA = self->playerA->msElapsedSinceLastBeat;
  bool silence = !self->playerA->process(self->stereoBuffer, false, numberOfSamples, self->volA, masterBpm, self->playerB->msElapsedSinceLastBeat);
  if (self->playerB->process(self->stereoBuffer, !silence, numberOfSamples, self->volB, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples);
  return !silence;
}

RCT_REMAP_METHOD(init,
                 initResolver:(RCTPromiseResolveBlock)resolve
                 initRejecter:(RCTPromiseRejectBlock)reject)
{
  lastSamplerate = activeFx = 0;
  crossValue = volA = volB = 0.0f;
  if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
  
  playerA = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackA, 44100, 0);
  playerA->open([[[NSBundle mainBundle] pathForResource:@"lycka" ofType:@"mp3"] fileSystemRepresentation]);
  playerB = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackB, 44100, 0);
  playerB->open([[[NSBundle mainBundle] pathForResource:@"nuyorica" ofType:@"m4a"] fileSystemRepresentation]);
  
  playerA->syncMode = playerB->syncMode = SuperpoweredAdvancedAudioPlayerSyncMode_TempoAndBeat;
  
  output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
  
  if (output) {
    [output start];
    resolve(@"true");
  } else {
    reject(@"get_error", @"Error with output", nil);
  }
}

RCT_REMAP_METHOD(playPause,
                 playPauseResolver:(RCTPromiseResolveBlock)resolve
                 playPauseRejecter:(RCTPromiseRejectBlock)reject)
{
  bool isPlaying = false;
  
  if (playerA->playing) {
    playerA->pause();
    playerB->pause();
    isPlaying = true;
  } else {
    bool masterIsA = (crossValue <= 0.5f);
    playerA->play(!masterIsA);
    playerB->play(masterIsA);
    isPlaying = true;
  };
  
  if (isPlaying) {
    resolve(@"true");
  } else {
    reject(@"get_error", @"Error while playPause", nil);
  }
}

RCT_EXPORT_METHOD(toggleSample:(NSInteger)sampleId)
{
  switch (sampleId) {
    case 1:
      if (volA == 1.0f * headroom) {
        volA = 0;
      } else {
        volA = 1.0f * headroom;
      };
      break;
    case 2:
      if (volB == 1.0f * headroom) {
        volB = 0;
      } else {
        volB = 1.0f * headroom;
      };
      break;
    default:
      break;
  };
}

- (void)dealloc {
  delete playerA;
  delete playerB;
  free(stereoBuffer);
#if !__has_feature(objc_arc)
  [output release];
  [super dealloc];
#endif
}

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}

- (void)interruptionEnded { // If a player plays Apple Lossless audio files, then we need this. Otherwise unnecessary.
  playerA->onMediaserverInterrupt();
  playerB->onMediaserverInterrupt();
}

//static inline float floatToFrequency(float value) {
//  static const float min = logf(20.0f) / logf(10.0f);
//  static const float max = logf(20000.0f) / logf(10.0f);
//  static const float range = max - min;
//  return powf(10.0f, value * range + min);
//}
//
//RCT_EXPORT_METHOD(fxValue:(NSInteger)activeFx value:(float)value)
//{
//  switch (activeFx) {
//    case 1:
//      filter->setResonantParameters(floatToFrequency(1.0f - value), 0.1f);
//      filter->enable(true);
//      flanger->enable(false);
//      roll->enable(false);
//      break;
//    case 2:
//      if (value > 0.8f) roll->beats = 0.0625f;
//      else if (value > 0.6f) roll->beats = 0.125f;
//      else if (value > 0.4f) roll->beats = 0.25f;
//      else if (value > 0.2f) roll->beats = 0.5f;
//      else roll->beats = 1.0f;
//      roll->enable(true);
//      filter->enable(false);
//      flanger->enable(false);
//      break;
//    default:
//      flanger->setWet(value);
//      flanger->enable(true);
//      filter->enable(false);
//      roll->enable(false);
//  };
//}
//
//RCT_EXPORT_METHOD(crossFader:(float)crossValue)
//{
//  if (crossValue < 0.01f) {
//    volA = 1.0f * headroom;
//    volB = 0.0f;
//  } else if (crossValue > 0.99f) {
//    volA = 0.0f;
//    volB = 1.0f * headroom;
//  } else {
//    volA = cosf(M_PI_2 * crossValue) * headroom;
//    volB = cosf(M_PI_2 * (1.0f - crossValue)) * headroom;
//  };
//}

RCT_EXPORT_MODULE();

@end
