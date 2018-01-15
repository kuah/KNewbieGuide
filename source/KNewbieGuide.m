//
//  KNewbieGuide.m
//  KNewbieGuide
//
//  Created by 陈世翰 on 2018/1/9.
//  Copyright © 2018年 Kuah. All rights reserved.
//

#import "KNewbieGuide.h"
#import <SCMapCatch/SCMapCatch.h>

NSString *const kNewbieGuideNotification = @"kNewbieGuideNotification";
NSString *const kNewbieGuideUserDefaultRoot = @"kNewbieGuideUserDefaultRoot";


@interface KNewbieGuide(){
    NSInteger _index;
}
/**
 *   当前还剩下没播放的
 */
@property (nonatomic,strong)NSMutableArray *views;
/**
 *   当前显示的view
 */
@property (nonatomic,strong)UIView <KNewbieGuideDelegate> *showingView;
/**
 *   当前显示的key
 */
@property (nonatomic,strong)NSString *showingKey;
@end

@implementation KNewbieGuide
#pragma mark -public

+(instancetype)shared{
    static KNewbieGuide *_coreManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreManager = [[KNewbieGuide alloc] init];
        [_coreManager _clear];
    });
    return _coreManager;
}
/**
 *  @brief 判断是否需要显示新手引导
 *  @param key 新手引导页的key
 *  @return 是否 YES/NO
 */
+(BOOL)isNewbie:(NSString *)key{
    return ([NSUserDefaults mc_objectForKey:@[kNewbieGuideUserDefaultRoot,key] separatedString:nil]==nil);
}
/**
 *  @brief 针对key消除新手引导(某些用户的新手引导是保存到服务器的,登录后，可以将状态通过这个方法导入)
 *  @param keys 键值数组
 */
+(void)removeNewbieForKeys:(NSArray *)keys{
    for (NSString * key in keys) {
        NSCAssert(key&&[key isKindOfClass:NSString.class]&&key.length>0, @"NewbieGuide : key %@ is not a NSString", key);
        [self _record:key];
    }
}
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesName 图片名,必须以nil结尾
 */
+(void)show:(NSString *)key withImageName:(NSString *)imagesName,...{
    if(![self isNewbie:key]) return;
    NSMutableArray * registerImageNames = [NSMutableArray array];
    NSCAssert(key&&key.length>0 , @"NewbieGuide : Argument couldn't be nil && length must >0");
    va_list args;
    va_start(args, imagesName);
    for (NSString * currentImageName = imagesName; currentImageName != nil; currentImageName = va_arg(args, id)) {
        NSCAssert([currentImageName isKindOfClass:NSString.class], @"NewbieGuide : Argument %@ is not a NSString", currentImageName);
        [registerImageNames addObject:currentImageName];
    }
    va_end(args);
    [self show:key withImageNames:registerImageNames];
}

/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesName 图片名,必须以nil结尾
 */
-(void)show:(NSString *)key withImageName:(NSString *)imagesName,...{
    if(![[self class] isNewbie:key]) return;
    NSMutableArray * registerImageNames = [NSMutableArray array];
    NSCAssert(key&&key.length>0 , @"NewbieGuide : Argument couldn't be nil && length must >0");
    va_list args;
    va_start(args, imagesName);
    for (NSString * currentImageName = imagesName; currentImageName != nil; currentImageName = va_arg(args, id)) {
        NSCAssert([currentImageName isKindOfClass:NSString.class], @"NewbieGuide : Argument %@ is not a NSString", currentImageName);
        [registerImageNames addObject:currentImageName];
    }
    va_end(args);
    [self show:key withImageNames:registerImageNames];
}

/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesNames 图片名集合
 */
+(void)show:(NSString *)key withImageNames:(NSArray *)imagesNames{
    [[self shared] show:key withImageNames:imagesNames];
}
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param imagesNames 图片名集合
 */
-(void)show:(NSString *)key withImageNames:(NSArray *)imagesNames{
    if(![[self class] isNewbie:key]) return;
    self.showingKey = key;
    NSMutableArray *views = MArray();
    for (NSString * imageName  in imagesNames) {
        UIImage * image = [UIImage imageNamed:imageName];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
        imageView.image = image;
        imageView.userInteractionEnabled  = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playNext)]];
        [views addObject:imageView];
    }
    self.views = views;
    [self playNext];
}


/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param view view
 */
+(void)show:(NSString *)key withView:(UIView <KNewbieGuideDelegate>*)view,...{
    if(![self isNewbie:key]) return;
    NSMutableArray * viewArray = [NSMutableArray array];
    NSCAssert(key&&key.length>0 , @"NewbieGuide : Argument couldn't be nil && length must >0");
    va_list args;
    va_start(args, view);
    for (UIView * currentView = view; currentView != nil; currentView = va_arg(args, id)) {
        NSCAssert([currentView isKindOfClass:UIView.class], @"NewbieGuide : Argument %@ is not a UIView", currentView);
        [viewArray addObject:currentView];
    }
    va_end(args);
    [self show:key withViews:viewArray];
}
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param views views
 */
+(void)show:(NSString *)key withViews:(NSArray *)views{
    [[self shared] show:key withViews:views];
}

/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param view view
 */
-(void)show:(NSString *)key withView:(UIView <KNewbieGuideDelegate>*)view,...{
    if(![[self class] isNewbie:key]) return;
    NSMutableArray * viewArray = [NSMutableArray array];
    NSCAssert(key&&key.length>0 , @"NewbieGuide : Argument couldn't be nil && length must >0");
    va_list args;
    va_start(args, view);
    for (UIView * currentView = view; currentView != nil; currentView = va_arg(args, id)) {
        NSCAssert([currentView isKindOfClass:UIView.class], @"NewbieGuide : Argument %@ is not a UIView", currentView);
        [viewArray addObject:currentView];
    }
    va_end(args);
    [self show:key withImageNames:viewArray];
}
/**
 *  @brief 显示新手引导页
 *  @param key 新手引导页的标致
 *  @param views views
 */
-(void)show:(NSString *)key withViews:(NSArray *)views{
    if(![[self class] isNewbie:key]) return;
    self.showingKey = key;
    self.views = MArray_(views);
    [self playNext];
}

/**
 *  @brief 播放下一个引导页
 */
+(void)playNext{
    [[self shared] playNext];
}
/**
 *  @brief 播放下一个引导页
 */
-(void)playNext{
    if([NSThread isMainThread]){
        [self _playNext];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _playNext];
        });
    }
}
-(void)_playNext{
    if (!self.views||self.views.count==0)return;
    if (self.views.count!=0 && _index+1==self.views.count) {
        [[self class] _record:self.showingKey];
        [self _clear];
        return;
    }else{
        UIView <KNewbieGuideDelegate>*view = _showingView;
        if ([view respondsToSelector:@selector(dismiss)]) {
            [view dismiss];
        }else{
            [view removeFromSuperview];
        }
    }
    self.showingView = self.views[_index+1];
    _index++;
}

/**
 *  @brief 播放完对key做记录
 *  @param key key
 */
+(void)_record:(NSString *)key{
    [NSUserDefaults mc_setObject:@1 forKey:@[kNewbieGuideUserDefaultRoot,key] separatedString:nil];
}
/**
 *  @brief 清除当前的播放信息
 */
-(void)_clear{
    [_showingView removeFromSuperview];
    _showingView = nil;;
    _showingKey = nil;
    _views = nil;
    _index = -1;
}

#pragma mark -懒加载


-(void)setShowingView:(UIView <KNewbieGuideDelegate>*)showingView{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    if ([showingView respondsToSelector:@selector(originFrame)]) {
       showingView.frame = [showingView originFrame];
    }else{
        showingView.frame = [[UIApplication sharedApplication].delegate window].bounds;
    }
    if (![showingView superview]) {
       [window insertSubview:showingView atIndex:window.subviews.count];
    }
    if ([showingView respondsToSelector:@selector(didEnter)]) {
        [showingView didEnter];
    }
  
    [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:showingView];
    _showingView  = showingView;
}
-(NSMutableArray *)views{
    if (!_views) {
        _views = MArray();
    }
    return _views;
}

/**
 *  @brief 始终显示
 *  @param key key
 */
+(void)showInDebugMode:(NSString *)key{
#if DEBUG
    [NSUserDefaults mc_setObject:nil forKey:@[kNewbieGuideUserDefaultRoot,key] separatedString:nil];
#endif
}

@end
