//
//  MopubAdManager.m
//  kAdsTest
//
//  Created by Luo on 2019/5/24.
//  Copyright © 2019 Luo. All rights reserved.
//

#import "MopubAdManager.h"
#import "MoPub.h"
#import "MPRewardedVideo.h"
#import "MopubAdManagerConfig.h"
#import "MPLogging.h"

#define kReloadTime 5

@interface MopubAdManager () <MPRewardedVideoDelegate>

//用来标记是否成功播放完毕了整个视频
@property (assign, nonatomic) BOOL isVideoAdsPlaySuccessful;

@end

@implementation MopubAdManager

#pragma mark - Class Method

+ (instancetype)sharedInstance
{
    static MopubAdManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MopubAdManager alloc] init];
        sharedInstance.isVideoAdsPlaySuccessful = NO;
    });
    return sharedInstance;
}

#pragma mark - private method

- (void)setupRewardedVideo
{
    //Admob测试广告
//     NSDictionary *localExtras = @{@"contentUrl" : @"www.example.com", @"testDevices" : @"c77a314d2ce76cf8ef2bff260dad26ed"};
    
    [MPRewardedVideo setDelegate:self forAdUnitId:MopubADUnitID];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:MopubADUnitID withMediationSettings:nil];
//    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:MopubADUnitID keywords:nil userDataKeywords:nil location:nil customerId:@"testCustomerId" mediationSettings:@[] localExtras:localExtras];
}

- (void)loadVideoAd
{
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:MopubADUnitID withMediationSettings:nil];
}

#pragma mark - public method

- (void)initManager
{
    //Init Mopub
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:MopubADUnitID];
    
    NSMutableDictionary *networkConfig = [NSMutableDictionary dictionaryWithCapacity:2];
    //Admob
    NSDictionary * npaConfig = @{ @"npa" : @"1"};
    NSDictionary *admobConfig = @{@"GoogleAdMobAdapterConfiguration" : npaConfig};
    
    //TouTiao
    NSDictionary *toutiaoInitConfig = @{@"appKey": vToutiaoAppKey, @"slotId": vToutiaoRewardedVideoSlotId};
    NSDictionary *toutiaoConfig = @{@"ToutiaoAdapterConfiguration":toutiaoInitConfig};
    
    [networkConfig addEntriesFromDictionary:admobConfig];
    [networkConfig addEntriesFromDictionary:toutiaoConfig];
    
    Class<MPAdapterConfiguration> TouTiaoAdapterConfig = NSClassFromString(@"ToutiaoAdapterConfiguration");
    sdkConfig.additionalNetworks = @[TouTiaoAdapterConfig];
    sdkConfig.mediatedNetworkConfigurations = networkConfig;
    sdkConfig.globalMediationSettings = @[];
    sdkConfig.loggingLevel = MPBLogLevelInfo;
    
    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
        NSLog(@"SDK initialization complete");
        // SDK initialization complete. Ready to make ad requests.
        static dispatch_once_t onceToken2;
        dispatch_once(&onceToken2, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupRewardedVideo];
            });
        });
    }];
}

- (void)playVideoAdInViewController:(UIViewController *)controller
{
    BOOL isvalid = [MPRewardedVideo hasAdAvailableForAdUnitID:MopubADUnitID];
    if (isvalid) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MPRewardedVideo presentRewardedVideoAdForAdUnitID:MopubADUnitID fromViewController:controller withReward:nil];
        });
    }
}

- (BOOL)hasVideoAdsNow
{
    BOOL rtn = NO;
    rtn = [MPRewardedVideo hasAdAvailableForAdUnitID:MopubADUnitID];
    return rtn;
}

#pragma mark - MPRewardedVideoDelegate

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]DidLoad：%@",adUnitID);
}


- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    MPLogInfo(@"[广告]DidFailToLoad：%@; Error:%@",adUnitID,error.localizedDescription);
    //加载失败，隔几秒再加载，防止反复加载的卡死问题
    [self performSelector:@selector(loadVideoAd) withObject:nil afterDelay:kReloadTime];
}


- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]DidLoad：%@",adUnitID);
}


- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    MPLogInfo(@"[广告]DidFailToPlay：%@; Error:%@",adUnitID,error.localizedDescription);
}


- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]WillAppear：%@",adUnitID);
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]DidAppear：%@",adUnitID);
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]WillDisappear：%@",adUnitID);
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]DidDisappear：%@",adUnitID);
    //广告关闭后重新加载下一个
    [self loadVideoAd];
    if (self.isVideoAdsPlaySuccessful) {
        self.isVideoAdsPlaySuccessful = NO;
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rewardedVideoAdSucess)]) {
            [self.delegate rewardedVideoAdSucess];
        }
    } else {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rewardedVideoAdFailed)]) {
            [self.delegate rewardedVideoAdFailed];
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rewardedVideoAdClosed)]) {
        [self.delegate rewardedVideoAdClosed];
    }
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]DidReceiveTapEvent：%@",adUnitID);
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
    MPLogInfo(@"[广告]WillLeaveApplication：%@",adUnitID);
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    MPLogInfo(@"[广告]ShouldRewardFor：%@",adUnitID);
    self.isVideoAdsPlaySuccessful = YES;
}

@end
