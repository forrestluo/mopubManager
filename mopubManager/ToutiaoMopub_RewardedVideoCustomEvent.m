//
//  ToutiaoMopub_RewardedVideoCustomEvent.m
//  kAdsTest
//
//  Created by Luo on 2019/5/23.
//  Copyright © 2019 Luo. All rights reserved.
//

#import "ToutiaoMopub_RewardedVideoCustomEvent.h"
#import "ToutiaoMopub_RewardedVideoCEDelegate.h"
#import "MopubAdManagerConfig.h"
#import <BUAdSDK/BUAdSDK.h>
#import "ToutiaoAdapterConfiguration.h"

@interface ToutiaoMopub_RewardedVideoCustomEvent ()

@property (nonatomic, strong) BURewardedVideoAd *rewardVideoAd;
@property (nonatomic, strong) ToutiaoMopub_RewardedVideoCEDelegate *customEventDelegate;

@end

@implementation ToutiaoMopub_RewardedVideoCustomEvent

- (void)requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info
{
    //info是在mopub后台的item line里配置的，以后台配置的为优先
    NSString *slotIDString = [info objectForKey:@"slotId"];
    
    // Cache the network initialization parameters
    [ToutiaoAdapterConfiguration updateInitializationParameters:info];
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *uuidStr = [NSString stringWithFormat:@"%@", string];
    model.userId = uuidStr;
    model.isShowDownloadBar = YES;
    
    if (slotIDString == nil) {
        //如果从后台没有拿到，则用代码里配置的。
        slotIDString = vToutiaoRewardedVideoSlotId;
    }
    
    BURewardedVideoAd *RewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:slotIDString rewardedVideoModel:model];
    RewardedVideoAd.delegate = self.customEventDelegate;
    self.rewardVideoAd = RewardedVideoAd;
    [RewardedVideoAd loadAdData];
}

- (BOOL)hasAdAvailable
{
    return self.rewardVideoAd.isAdValid;
}

- (void)presentRewardedVideoFromViewController:(UIViewController *)viewController
{
    [self.rewardVideoAd showAdFromRootViewController:viewController];
}

-(BOOL)enableAutomaticImpressionAndClickTracking {
    return NO;
}

- (ToutiaoMopub_RewardedVideoCEDelegate *)customEventDelegate
{
    if (!_customEventDelegate) {
        _customEventDelegate = [[ToutiaoMopub_RewardedVideoCEDelegate alloc] init];
        _customEventDelegate.customEvent = self;
    }
    return _customEventDelegate;
}

@end
