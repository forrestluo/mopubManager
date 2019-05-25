//
//  ToutiaoMopub_RewardedVideoCEDelegate.m
//  kAdsTest
//
//  Created by Luo on 2019/5/24.
//  Copyright © 2019 Luo. All rights reserved.
//

#import "ToutiaoMopub_RewardedVideoCEDelegate.h"
#import "MPRewardedVideoReward.h"

@implementation ToutiaoMopub_RewardedVideoCEDelegate

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    [self.customEvent.delegate rewardedVideoDidLoadAdForCustomEvent:self.customEvent];
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    [self.customEvent.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self.customEvent error:error];
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [self.customEvent.delegate rewardedVideoWillAppearForCustomEvent:self.customEvent];
    [self.customEvent.delegate trackImpression];
}

- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd {
    [self.customEvent.delegate rewardedVideoDidAppearForCustomEvent:self.customEvent];
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    [self.customEvent.delegate rewardedVideoDidDisappearForCustomEvent:self.customEvent];
}

- (void)rewardedVideoAdDidClickDownload:(BURewardedVideoAd *)rewardedVideoAd {
    [self.customEvent.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self.customEvent];
    [self.customEvent.delegate trackClick];
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        [self.customEvent.delegate rewardedVideoDidFailToPlayForCustomEvent:self.customEvent error:error];
    }
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    MPRewardedVideoReward *moPubReward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:[NSNumber numberWithInt:1]];
    [self.customEvent.delegate rewardedVideoShouldRewardUserForCustomEvent:self.customEvent reward:moPubReward];
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    //TODO:需要返回给游戏说播放完毕但是不给奖励
}

@end
