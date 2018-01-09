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


@interface KNewbieGuide()
/**
 *   当前还剩下没播放的
 */
@property (nonatomic,strong)NSMutableArray *imageNames;
/**
 *   当前显示的view
 */
@property (nonatomic,strong)UIImageView *showingView;
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
    self.imageNames = MArray_(imagesNames);
    if([NSThread isMainThread]){
         [self _playNext];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _playNext];
        });
    }
}



#pragma mark -private
/**
 *  @brief 播放下一个引导页
 */
-(void)_playNext{
    if (self.imageNames.count == 0) {
        [[self class] _record:self.showingKey];
        [self _clear];
        return;
    }
    if (!self.showingView.superview) {
        self.showingView.image = [UIImage imageNamed:self.imageNames.firstObject];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.showingView];
        [[[UIApplication sharedApplication].delegate window] bringSubviewToFront:self.showingView];
    }else{
        self.showingView.image = [UIImage imageNamed:self.imageNames.firstObject];
    }
    [self.imageNames removeObjectAtIndex:0];
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
    _imageNames = nil;
}

#pragma mark -懒加载

-(UIImageView *)showingView{
    if (!_showingView) {
        _showingView = [[UIImageView  alloc]initWithFrame:[[UIApplication sharedApplication].delegate window].bounds];
        _showingView.userInteractionEnabled=  YES;
        [_showingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_playNext)]];
    }
    return _showingView;
}

-(NSMutableArray *)imageNames{
    if (!_imageNames) {
        _imageNames = MArray();
    }
    return _imageNames;
}

@end
