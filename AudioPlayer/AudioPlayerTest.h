@interface AudioPlayerTest : NSObject

+ (void)init;
+ (float)musicVolume;
+ (void)setMusicVolume:(float)volume;
+ (float)effectVolume;
+ (void)setEffectVolume:(float)volume;
+ (void)playMenuMusic;
+ (void)playAmbinceMusic;
+ (void)playIceCollisionSound:(float)delay;

@end
