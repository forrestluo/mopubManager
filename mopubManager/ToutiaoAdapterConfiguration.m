//
//  ToutiaoAdapterConfiguration.m
//  kAdsTest
//
//  Created by Luo on 2019/5/23.
//  Copyright © 2019 Luo. All rights reserved.
//

#import "ToutiaoAdapterConfiguration.h"
#import <BUAdSDK/BUAdSDK.h>

@interface ToutiaoAdapterConfiguration ()
@property (class, nonatomic, copy, readwrite) NSString * appKey;
@end

// Initialization configuration keys
static NSString * const kTouTiaoAppKey = @"appKey";
static NSString * gAppKeyString = nil;

@implementation ToutiaoAdapterConfiguration

#pragma mark - Class method
+ (void)updateInitializationParameters:(NSDictionary *)parameters
{   
    if (parameters != nil) {
        [ToutiaoAdapterConfiguration setCachedInitializationParameters:parameters];
    }
}

#pragma mark - Instance method
- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> *)configuration complete:(void(^)(NSError *))complete
{
    NSString *appkeyString = configuration[kTouTiaoAppKey];
    if (appkeyString == nil || [appkeyString isKindOfClass:[NSString class]] == NO) {
        NSError *theError = [NSError errorWithDomain:@"com.kunpo.ToutiaoAdapterConfiguration" code:1 userInfo:@{NSLocalizedDescriptionKey:@"头条广告SDK的appKey传入的不对。正确的应该是以appKey为键，以字符串为值的一个字典。"}];
        if (complete != nil) {
            complete(theError);
        }
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [BUAdSDKManager setAppID:appkeyString];
                [BUAdSDKManager setIsPaidApp:NO];
                [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
                if (complete != nil) {
                    complete(nil);
                }
            });
        });
    }
}

#pragma mark - MPAdapterConfiguration
- (NSString *)adapterVersion
{
    return @"2.0.1.0";
}

- (NSString *)biddingToken
{
    return nil;
}

- (NSString *)moPubNetworkName
{
    return @"BUAd";
}

- (NSString *)networkSdkVersion
{
    return @"2.0.1.2";
}

+ (NSString *)appKey
{
    return gAppKeyString;
}

+ (void)setAppKey:(NSString *)string
{
    gAppKeyString = string;
}

@end
