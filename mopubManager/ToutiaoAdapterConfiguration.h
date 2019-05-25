//
//  ToutiaoAdapterConfiguration.h
//  kAdsTest
//
//  Created by Luo on 2019/5/23.
//  Copyright © 2019 Luo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPBaseAdapterConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToutiaoAdapterConfiguration : MPBaseAdapterConfiguration

+ (void)updateInitializationParameters:(NSDictionary *)parameters;

@property (nonatomic, copy, readonly) NSString * adapterVersion;
@property (nonatomic, copy, readonly) NSString * biddingToken;
@property (nonatomic, copy, readonly) NSString * moPubNetworkName;
@property (nonatomic, copy, readonly) NSString * networkSdkVersion;

@property (class, nonatomic, copy, readonly) NSString * appKey;

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration complete:(void(^ _Nullable)(NSError * _Nullable))complete;

@end

NS_ASSUME_NONNULL_END
