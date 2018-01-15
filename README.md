# KNewbieGuide
快速编写新手引导页工具

## Install
```
pod 'KNewbieGuide'

```

## Usage
### KNewbieGuide
```
//不需要看的新手引导页的key
[KNewbieGuide removeNewbieForKeys:@[@"new"]];

//debug状态下，始终显示新手引导页
[KNewbieGuide showInDebugMode:@"new"];

//用图片来做新手引导
[KNewbieGuide show:@"new" withImageName:@"登录_填写手机号",@"个人中心_展商中心_重置授权码",nil];

//用自定义的view做新手引导页
[KNewbieGuide show:@"new" withView:[FirstView new],[SecondView new],nil];

```

See the demo for detailed usage.
