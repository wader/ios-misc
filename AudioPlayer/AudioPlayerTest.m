#import "AudioPlayerTest.h"
#import "AudioPlayer.h"

#import <AVFoundation/AVFoundation.h>

// menu and ambience music will cross fade as they have the same name

NSString *const AudioVolumeMusic = @"music";
NSString *const AudioVolumeEffect = @"effect";

NSString *const AudioSettingMusicVolume = @"musicVolume";
NSString *const AudioSettingEffectVolume = @"effectVolume";

@implementation AudioPlayerTest

+ (void)init {
  [[AVAudioSession sharedInstance]
   setCategory:AVAudioSessionCategoryAmbient
   error:NULL];
  
  [AudioPlayer setVolumeForName:AudioVolumeMusic
                         volume:[[NSUserDefaults standardUserDefaults]
                                 floatForKey:AudioSettingMusicVolume]];
  [AudioPlayer setVolumeForName:AudioVolumeEffect
                         volume:[[NSUserDefaults standardUserDefaults]
                                 floatForKey:AudioSettingEffectVolume]];
}

+ (float)musicVolume {
  return [[NSUserDefaults standardUserDefaults]
	  floatForKey:AudioSettingMusicVolume];
}

+ (void)setMusicVolume:(float)volume {
  [AudioPlayer setVolumeForName:AudioVolumeMusic volume:volume];
  [[NSUserDefaults standardUserDefaults] setFloat:volume
                                           forKey:AudioSettingMusicVolume];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)effectVolume {
  return [[NSUserDefaults standardUserDefaults]
	  floatForKey:AudioSettingEffectVolume];
}

+ (void)setEffectVolume:(float)volume {
  [AudioPlayer setVolumeForName:AudioVolumeEffect volume:volume];
  [[NSUserDefaults standardUserDefaults] setFloat:volume
                                           forKey:AudioSettingEffectVolume];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSURL *)urlToResource:(NSString *)resource
                  ofType:(NSString *)type
             inDirectory:(NSString *)directory {
  return [[[NSURL alloc] initFileURLWithPath:
           [[NSBundle mainBundle] pathForResource:resource
                                           ofType:type
                                      inDirectory:directory]]
          autorelease];
}

+ (void)playMenuMusic {
  [AudioPlayer playWithURL:[[self class ] urlToResource:@"menu-music"
                                                 ofType:@"mp3"
                                            inDirectory:@"audio"]
                startDelay:0
              playDuration:0
                shouldLoop:YES
                      name:@"music"
                volumeName:AudioVolumeMusic
              fadeDuration:1.0f];
}

+ (void)playAmbinceMusic {
  [AudioPlayer playWithURL:[[self class ] urlToResource:@"ambience-music"
                                                 ofType:@"mp3"
                                            inDirectory:@"audio"]
                startDelay:0
              playDuration:0
                shouldLoop:YES
                      name:@"music"
                volumeName:AudioVolumeMusic
              fadeDuration:1.0f];
}

+ (void)playIceCollisionSound:(float)delay {
  [AudioPlayer playWithURL:[[self class ] urlToResource:@"collision"
                                                 ofType:@"wav"
                                            inDirectory:@"audio"]
                startDelay:delay
              playDuration:0
                shouldLoop:NO
                      name:nil
                volumeName:AudioVolumeEffect
              fadeDuration:0];
}

@end
