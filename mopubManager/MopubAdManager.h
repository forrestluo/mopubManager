//
//  MopubAdManager.h
//  kAdsTest
//
//  Created by Luo on 2019/5/24.
//  Copyright © 2019 Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MopubAdManagerRewardedVideoDelegate <NSObject>

@optional
//视频被关闭了，可能是播放完成关闭，也可能是播放中途退出而关闭。
- (void)rewardedVideoAdClosed;
//视频中途退出然后关闭，不应该给玩家奖励
- (void)rewardedVideoAdFailed;
//视频成功播放完毕并且关闭，此时需要给玩家发放奖励
- (void)rewardedVideoAdSucess;

@end

@interface MopubAdManager : NSObject

/**
 获得MopubAdManager的单例，这个Manager用来整合Mopub来提供各广告network的mediation工作。通过在mopub的后台进行配置，控制广告的瀑布流规则。

 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 激励视频回调的delegate
 */
@property (nonatomic, weak) id<MopubAdManagerRewardedVideoDelegate> delegate;

/**
 初始化manager，会初始化mopub以及其中集成的各个ad network，初始化需要的部分参数位于MopubAdManagerConfig.h中，AdMob的应用ID在Info.plist中配置
 */
- (void)initManager;

/**
 在某个viewController中播放广告

 @param controller 用来呈现广告的viewController
 */
- (void)playVideoAdInViewController:(UIViewController *)controller;

/**
 当前是否有激励视频广告

 @return YES-有广告；NO-无广告
 */
- (BOOL)hasVideoAdsNow;
@end

NS_ASSUME_NONNULL_END
