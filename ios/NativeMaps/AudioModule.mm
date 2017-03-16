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
  SuperpoweredAdvancedAudioPlayer *sampleKick, *sampleLead, *sampleBass, *sampleRimshot, *sampleWhell, *sampleWood, *sampleWood2;
  SuperpoweredIOSAudioIO *output;
  unsigned char activeFx;
  float *stereoBuffer, crossValue, volKick, volLead, volBass, volRimshot, volWhell, volWood, volWood2;
  unsigned int lastSamplerate;
}

void playerEventCallbackA(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleKick->setBpm(123.0f);
    self->sampleKick->setPosition(self->sampleKick->firstBeatMs, false, false);
  };
}

void playerEventCallbackB(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleLead->setBpm(123.0f);
    self->sampleLead->setPosition(self->sampleLead->firstBeatMs, false, false);
  };
}

void playerEventCallbackC(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleBass->setBpm(123.0f);
    self->sampleBass->setPosition(self->sampleBass->firstBeatMs, false, false);
  };
}

void playerEventCallbackD(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleRimshot->setBpm(123.0f);
    self->sampleRimshot->setPosition(self->sampleRimshot->firstBeatMs, false, false);
  };
}

void playerEventCallbackE(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleWhell->setBpm(123.0f);
    self->sampleWhell->setPosition(self->sampleWhell->firstBeatMs, false, false);
  };
}

void playerEventCallbackF(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleWood->setBpm(123.0f);
    self->sampleWood->setPosition(self->sampleWhell->firstBeatMs, false, false);
  };
}

void playerEventCallbackG(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
  if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
    AudioModule *self = (__bridge AudioModule *)clientData;
    self->sampleWood2->setBpm(123.0f);
    self->sampleWood2->setPosition(self->sampleWhell->firstBeatMs, false, false);
  };
}


static bool audioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime)
{
  __unsafe_unretained AudioModule *self = (__bridge AudioModule *)clientdata;
  
  if (samplerate != self->lastSamplerate) {
    self->lastSamplerate = samplerate;
    self->sampleKick->setSamplerate(samplerate);
    self->sampleLead->setSamplerate(samplerate);
    self->sampleBass->setSamplerate(samplerate);
    self->sampleRimshot->setSamplerate(samplerate);
    self->sampleWhell->setSamplerate(samplerate);
    self->sampleWood->setSamplerate(samplerate);
    self->sampleWood2->setSamplerate(samplerate);
  };
  
  bool masterIsA = (self->crossValue <= 0.5f);
  
  float masterBpm = masterIsA ? self->sampleKick->currentBpm : self->sampleLead->currentBpm;
  
  double msElapsedSinceLastBeatA = self->sampleKick->msElapsedSinceLastBeat;
  
  bool silence = !self->sampleKick->process(self->stereoBuffer, false, numberOfSamples, self->volKick, masterBpm, self->sampleLead->msElapsedSinceLastBeat);
  
  if (self->sampleLead->process(self->stereoBuffer, !silence, numberOfSamples, self->volLead, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (self->sampleBass->process(self->stereoBuffer, !silence, numberOfSamples, self->volBass, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (self->sampleRimshot->process(self->stereoBuffer, !silence, numberOfSamples, self->volRimshot, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (self->sampleWhell->process(self->stereoBuffer, !silence, numberOfSamples, self->volWhell, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (self->sampleWood->process(self->stereoBuffer, !silence, numberOfSamples, self->volWood, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (self->sampleWood2->process(self->stereoBuffer, !silence, numberOfSamples, self->volWood2, masterBpm, msElapsedSinceLastBeatA)) silence = false;
  
  if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples);
 
  return !silence;
}

RCT_REMAP_METHOD(init,
                 initResolver:(RCTPromiseResolveBlock)resolve
                 initRejecter:(RCTPromiseRejectBlock)reject)
{
  lastSamplerate = activeFx = 0;
  crossValue = 0.0f;
  volKick = volLead = volBass = volRimshot = volWhell = volWood = volWood2 = 0.0f;
  if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory, aligned to 16.
  
  sampleKick = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackA, 44100, 0);
  sampleKick->open([[[NSBundle mainBundle] pathForResource:@"samples/kick" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleLead = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackB, 44100, 0);
  sampleLead->open([[[NSBundle mainBundle] pathForResource:@"samples/lead" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleBass = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackC, 44100, 0);
  sampleBass->open([[[NSBundle mainBundle] pathForResource:@"samples/bass" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleRimshot = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackD, 44100, 0);
  sampleRimshot->open([[[NSBundle mainBundle] pathForResource:@"samples/rimshot" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleWhell = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackE, 44100, 0);
  sampleWhell->open([[[NSBundle mainBundle] pathForResource:@"samples/whell" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleWood = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackF, 44100, 0);
  sampleWood->open([[[NSBundle mainBundle] pathForResource:@"samples/wood" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleWood2 = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackG, 44100, 0);
  sampleWood2->open([[[NSBundle mainBundle] pathForResource:@"samples/wood2" ofType:@"wav"] fileSystemRepresentation]);
  
  sampleKick->syncMode = sampleLead->syncMode = sampleBass->syncMode = sampleRimshot->syncMode = sampleWhell->syncMode = sampleWood->syncMode = sampleWood2->syncMode = SuperpoweredAdvancedAudioPlayerSyncMode_TempoAndBeat;
  
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
  
  if (sampleKick->playing) {
    sampleKick->pause();
    sampleLead->pause();
    sampleBass->pause();
    sampleRimshot->pause();
    sampleWhell->pause();
    sampleWood->pause();
    sampleWood2->pause();
    isPlaying = true;
  } else {
    bool masterIsA = (crossValue <= 0.5f);
    sampleKick->play(!masterIsA);
    sampleLead->play(masterIsA);
    sampleBass->play(masterIsA);
    sampleRimshot->play(masterIsA);
    sampleWhell->play(masterIsA);
    sampleWood->play(masterIsA);
    sampleWood2->play(masterIsA);
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
      if (volKick == 1.0f * headroom) {
        volKick = 0;
      } else {
        volKick = 1.0f * headroom;
      };
      break;
    case 2:
      if (volLead == 1.0f * headroom) {
        volLead = 0;
      } else {
        volLead = 1.0f * headroom;
      };
      break;
    case 3:
      if (volBass == 1.0f * headroom) {
        volBass = 0;
      } else {
        volBass = 1.0f * headroom;
      };
      break;
    case 4:
      if (volRimshot == 1.0f * headroom) {
        volRimshot = 0;
      } else {
        volRimshot = 1.0f * headroom;
      };
      break;
    case 5:
      if (volWhell == 1.0f * headroom) {
        volWhell = 0;
      } else {
        volWhell = 1.0f * headroom;
      };
      break;
    case 6:
      if (volWood == 1.0f * headroom) {
        volWood = 0;
      } else {
        volWood = 1.0f * headroom;
      };
      break;
    case 7:
      if (volWood2 == 1.0f * headroom) {
        volWood2 = 0;
      } else {
        volWood2 = 1.0f * headroom;
      };
      break;
    default:
      break;
  };
}

- (void)dealloc {
  delete sampleKick;
  delete sampleLead;
  delete sampleBass;
  delete sampleRimshot;
  delete sampleWhell;
  delete sampleWood;
  delete sampleWood2;
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
  sampleKick->onMediaserverInterrupt();
  sampleLead->onMediaserverInterrupt();
  sampleBass->onMediaserverInterrupt();
  sampleRimshot->onMediaserverInterrupt();
  sampleWhell->onMediaserverInterrupt();
  sampleWood->onMediaserverInterrupt();
  sampleWood2->onMediaserverInterrupt();
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
//    volKick = 1.0f * headroom;
//    volLead = 0.0f;
//  } else if (crossValue > 0.99f) {
//    volKick = 0.0f;
//    volLead = 1.0f * headroom;
//  } else {
//    volKick = cosf(M_PI_2 * crossValue) * headroom;
//    volLead = cosf(M_PI_2 * (1.0f - crossValue)) * headroom;
//  };
//}

RCT_EXPORT_MODULE();

@end
