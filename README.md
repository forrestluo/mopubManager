# mopubManager
采用mopub为mediation，集成admob和穿山甲的广告。

## 一、功能
* 采用mopub为mediation，集成admob和穿山甲的激励视频广告。（未来有更多广告network或者更多广告类型的聚合需求的话，再进行添加）
* 针对iOS平台

## 二、iOS端的集成

### 1.集成Admob和mopub的SDK

1）利用cocoaPods，在podfile中添加下列语句来进行集成：

```
pod 'MoPub-AdMob-Adapters', '7.43.0.0'
```

2）在工程的info.plist里添加Admob的appID。Info中的key为：GADApplicationIdentifier。Info中的value为：在admob后台创建的app对应的id。

### 2.集成穿山甲的SDK

利用cocoaPods，在podfile中添加下列语句来进行集成：

```
pod 'Bytedance-UnionAD', '~> 2.0.1.2'
```

### 3.集成mopubManager

1）将mopubManager拖动到工程里，勾选“Copy items if needed”。

2）在MopubAdManagerConfig.h中修改填入自己的mopub后台建立的ad unit id，以及穿山甲的AppKey和SlotID。其中，穿山甲的SlotID只是备选项，实际使用时优先从mopub后台的item line配置中获取，只有当后台没有填写时才会用代码里填入的这个slotID。

3）在Application Delegate的application:didFinishLaunchingWithOptions:方法里进行初始化：

```objc
#import "MopubAdManager.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[MopubAdManager sharedInstance] initManager];
}
```

4）在需要播放广告的时候，调用MopubAdManager中的playVideoAdInViewController:方法进行广告播放。例如：

```objc
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [[MopubAdManager sharedInstance] playVideoAdInViewController:rootVC];
```

5）如果需要判断当前是否有广告可以播放，则使用下面的方法：

```objc
    BOOL isVideoReady = [[MopubAdManager sharedInstance] hasVideoAdsNow];
```

6）视频广告播放的回调通知，在游戏初始化后的某个位置（比如主viewController里），设置MopubAdManager的回调代理，实现MopubAdManagerRewardedVideoDelegate代理方法，来接收回调信息并在游戏端进行处理。

```objc
    [MopubAdManager sharedInstance].delegate = self;
    
    //视频被关闭了，可能是播放完成关闭，也可能是播放中途退出而关闭。
    - (void)rewardedVideoAdClosed
    {
    }
    //视频中途退出然后关闭，不应该给玩家奖励
    - (void)rewardedVideoAdFailed
    {
    }
    //视频成功播放完毕并且关闭，此时需要给玩家发放奖励
    - (void)rewardedVideoAdSucess
    {
    }
```

## 三、Mopub后台的配置

1. 后台的Networks需要添加Admob和穿山甲的配置。其中穿山甲使用Custom SDK的配置。在**Custom event class**里需要填入**ToutiaoMopub_RewardedVideoCustomEvent**。

2. Orders设置里，增加需要的Admob和穿山甲视频line item。Admob要override其Network AdUnit ID。穿山甲的Custom event data里请填入Json字典值"slotId":"XXXX"。

3. 按需在Apps模块的ad sources里配置CPM，Priority等内容，来控制waterfall。
