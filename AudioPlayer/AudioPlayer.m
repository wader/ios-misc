/*
 * AudioPlayer, AVAudioPlayer based audio player with loop, cross fade,
 * duration and delay support.
 *
 * Copyright (c) 2010 <mattias.wadman@gmail.com>
 *
 * MIT License:
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "AudioPlayer.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#ifndef CLAMP
#define CLAMP(v, min, max) (((v) < (min) ? (min) : (v) > (max) ? (max) : v))
#endif

// forward declaration
@protocol AudioInstanceDelegate;

@interface AudioInstance : NSObject <AVAudioPlayerDelegate>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) float volume;
@property(nonatomic, copy) NSString *volumeName;
@property(nonatomic, retain) NSTimer *startDelayTimer;
@property(nonatomic, retain) NSTimer *playDurationTimer;
@property(nonatomic, retain) NSTimer *fadeDurationTimer;
@property(nonatomic, assign) BOOL isFadingUp;
@property(nonatomic, assign) NSTimeInterval fadeDuration;
@property(nonatomic, copy) NSDate *fadeStart;
@property(nonatomic, retain) AVAudioPlayer *player;
@property(nonatomic, assign) id<AudioInstanceDelegate> delegate;

- (void)cancel;

@end

@protocol AudioInstanceDelegate

- (void)audioInstanceCanceled:(AudioInstance *)instance;

@end


@implementation AudioInstance

@synthesize name;
@synthesize volume;
@synthesize volumeName;
@synthesize startDelayTimer;
@synthesize playDurationTimer;
@synthesize fadeDurationTimer;
@synthesize isFadingUp;
@synthesize fadeDuration;
@synthesize fadeStart;
@synthesize player;
@synthesize delegate;

- (id)initWithURL:(NSURL *)url
       startDelay:(NSTimeInterval)startDelay
     playDuration:(NSTimeInterval)playDuration
       shouldLoop:(BOOL)shouldLoop
             name:(NSString *)aName
       volumeName:(NSString *)aVolumeName
     fadeDuration:(NSTimeInterval)aFadeDuration {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.name = aName;
  self.volumeName = aVolumeName;
  self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error: nil]
                 autorelease];
  self.player.delegate = self;
  [self.player prepareToPlay];
  if (shouldLoop) {
    self.player.numberOfLoops = -1;
  }
  
  if (aFadeDuration != 0) {
    self.fadeDuration = aFadeDuration;
    self.isFadingUp = YES;
    self.fadeStart = [NSDate date];
    self.player.volume = 0;
    self.fadeDurationTimer = [NSTimer
                              scheduledTimerWithTimeInterval:0.2f
                              target:self
                              selector:@selector(fadeDurationCallback:)
                              userInfo:nil
                              repeats:YES];
  }
  
  if (playDuration != 0) {
    self.playDurationTimer = [NSTimer
                              scheduledTimerWithTimeInterval:(startDelay +
                                                              playDuration)
                              target:self
                              selector:@selector(playDurationCallback:)
                              userInfo:nil
                              repeats:NO];
  }
  
  if (startDelay != 0) {
    self.startDelayTimer = [NSTimer
                            scheduledTimerWithTimeInterval:startDelay
                            target:self
                            selector:@selector(startDelayCallback:)
                            userInfo:nil
                            repeats:NO];
  } else {
    [self.player play];
  }
  
  return self;
}

- (void)dealloc {  
  self.name = nil;
  self.volumeName = nil;
  self.fadeStart = nil;
  self.player.delegate = nil;
  self.player = nil;
  
  [super dealloc];  
}

- (void)cancelAndTellDelegate {
  [self cancel];
  if (self.delegate != nil) {
    [self.delegate audioInstanceCanceled:self];
  }
}

- (void)cancelWithFadeDuration:(float)aFadeDuration {  
  if (self.fadeDurationTimer != nil) {
    [self.fadeDurationTimer invalidate];
    self.fadeDurationTimer = nil;
  }
  
  if (self.startDelayTimer != nil) {
    [self.startDelayTimer invalidate];
    self.startDelayTimer = nil;
  }
  if (self.playDurationTimer != nil) {
    [self.playDurationTimer invalidate];
    self.playDurationTimer = nil;
  }
  
  if (aFadeDuration == 0) {
    if (self.player != nil) {
      [self.player stop];
    }
  } else {
    self.fadeDuration = aFadeDuration;
    self.isFadingUp = NO;
    self.fadeStart = [NSDate date];
    self.fadeDurationTimer = [NSTimer
                              scheduledTimerWithTimeInterval:0.1f
                              target:self
                              selector:@selector(fadeDurationCallback:)
                              userInfo:nil
                              repeats:YES];
  }
}

- (void)cancel {
  [self cancelWithFadeDuration:0];
}

- (void)startDelayCallback:(NSTimer *)timer {
  [self.player play];
}

- (void)playDurationCallback:(NSTimer *)timer {
  [self cancelAndTellDelegate];
}

- (void)fadeDurationCallback:(NSTimer *)timer {
  NSTimeInterval v = ([[NSDate date] timeIntervalSinceDate:self.fadeStart] /
                      self.fadeDuration);
  if (!self.isFadingUp) {
    v = 1.0f - v;
  }
  
  v = self->volume * v;
  self.player.volume = CLAMP(v, 0, self->volume);
  
  if (v <= 0.0f || v >= self->volume) {
    // instance is only held by timer, dealloc will be called after this
    [self.fadeDurationTimer invalidate];
    self.fadeDurationTimer = nil;
    
    if (!self.isFadingUp) {
      [self.player stop];
    }
  }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
  [self cancelAndTellDelegate];
}

- (void)setVolume:(float)aVolume {
  if (self.player.numberOfLoops == -1) {
    if (aVolume == 0 && self.player.volume != 0) {
      [self.player pause];
    } else if (aVolume != 0 && self.player.volume == 0) {
      [self.player play];
    }
  }
  
  if (self.fadeDurationTimer == nil) {
    self.player.volume = aVolume;
  }
  
  self->volume = aVolume;
}

- (float)volume {
  return self->volume;
}

@end

@interface AudioPlayer () <AudioInstanceDelegate>

@property(nonatomic, retain) NSMutableArray *instances;
@property(nonatomic, retain) NSMutableDictionary *volumes;

@end

@implementation AudioPlayer

@synthesize instances;
@synthesize volumes;

+ (AudioPlayer *)shared {
  static AudioPlayer *shared = nil;
  
  @synchronized(self) {
    if (shared == nil) {
      shared = [[AudioPlayer alloc] init];
    }
  }
  
  return shared;
}

+ (void)playWithURL:(NSURL *)url
         startDelay:(NSTimeInterval)startDelay
       playDuration:(NSTimeInterval)playDuration
         shouldLoop:(BOOL)shouldLoop
               name:(NSString *)name
         volumeName:(NSString *)volumeName
       fadeDuration:(NSTimeInterval)fadeDuration {
  [[AudioPlayer shared] playWithURL:url
                         startDelay:startDelay
                       playDuration:playDuration
                         shouldLoop:shouldLoop
                               name:name
                         volumeName:volumeName
                       fadeDuration:fadeDuration];
}

+ (void)setVolumeForName:(NSString *)volumeName
                  volume:(float)volume {
  [[AudioPlayer shared] setVolumeForName:volumeName
                                  volume:volume];
}

- (AudioInstance *)findInstanceWithName:(NSString *)name {
  for (AudioInstance *instance in self.instances) {
    if (instance.name != nil &&
        [instance.name isEqualToString:name]) {
      return instance;
    }
  }
  
  return nil;
}

- (id)init {
  self = [super init];
  if (self == nil) {
    return nil;
  }
  
  self.instances = [NSMutableArray array];
  self.volumes = [NSMutableDictionary dictionary];
  
  return self;
}

- (void)dealloc {
  for (AudioInstance *instance in self.instances) {
    [instance cancel];
  }
  self.instances = nil;
  self.volumes = nil;
  
  [super dealloc];
}

- (void)audioInstanceCanceled:(AudioInstance *)instance {
  [self.instances removeObject:instance];
}

- (void)playWithURL:(NSURL *)url
         startDelay:(NSTimeInterval)startDelay
       playDuration:(NSTimeInterval)playDuration
         shouldLoop:(BOOL)shouldLoop
               name:(NSString *)name
         volumeName:(NSString *)volumeName
       fadeDuration:(NSTimeInterval)fadeDuration {
  if (name != nil) {
    AudioInstance *current = [self findInstanceWithName:name];
    if (current != nil) {
      
      if ([current.player.url isEqual:url]) {
        return;
      }
      
      [current cancelWithFadeDuration:fadeDuration];
      [self.instances removeObject:current];
    }
  }
  
  AudioInstance *instance = [[[AudioInstance alloc]
                              initWithURL:url
                              startDelay:startDelay
                              playDuration:playDuration
                              shouldLoop:shouldLoop
                              name:name
                              volumeName:volumeName
                              fadeDuration:fadeDuration]
                             autorelease];
  instance.delegate = self;
  [self.instances addObject:instance];
  
  NSNumber *volume = [self.volumes objectForKey:volumeName];
  if (volume != nil) {
    instance.volume = [volume floatValue];
  }
}

- (void)setVolumeForName:(NSString *)volumeName
                  volume:(float)volume {
  for (AudioInstance *instance in self.instances) {
    if (![instance.volumeName isEqualToString:volumeName]) {
      continue;
    }
    
    instance.volume = volume;
  }
  
  [self.volumes setObject:[NSNumber numberWithFloat:volume]
                   forKey:volumeName];
}

@end
