//
//  ToutiaoMopub_RewardedVideoCEDelegate.h
//  kAdsTest
//
//  Created by Luo on 2019/5/24.
//  Copyright © 2019 Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import "ToutiaoMopub_RewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToutiaoMopub_RewardedVideoCEDelegate : NSObject<BURewardedVideoAdDelegate>
@property (nonatomic, weak) ToutiaoMopub_RewardedVideoCustomEvent *customEvent;
@end

NS_ASSUME_NONNULL_END
