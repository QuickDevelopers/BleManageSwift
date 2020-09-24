# BleManageSwift
 This is BleManageSwift

### new version 1.0.5
*目前不支持oc版本

 非常感谢 cesarferreira https://github.com/cesarferreira/SwiftEventBus/commits?author=cesarferreira 提供的 SwiftEventBus

快速度开发蓝牙工具

安装介绍 只能支持 ios10.0以上版本

```java
--------------------------------------------------------------------------------
 🎉  Congrats

 🚀  BleManageSwift (current version) successfully published
 📅  September 23rd, 01:51
 🌎  https://cocoapods.org/pods/BleManageSwift
 👍  Tell your friends!
--------------------------------------------------------------------------------
```

Installation Guide for BleManageSwift

```java
target 'MyApp' do
  pod 'BleManageSwift', '~> current version'
end

```

如果你使用的时候报以下的错误

```java
[!] CocoaPods could not find compatible versions for pod "BleManageSwift":
  In Podfile:
    BleManageSwift (~> current version)

None of your spec sources contain a spec satisfying the dependency: `BleManageSwift (~> current version)`.

You have either:
 * out-of-date source repos which you can update with `pod repo update` or with `pod install --repo-update`.
 * mistyped the name or version.
 * not added the source repo that hosts the Podspec to your Podfile.

```

运行 pod repo update 或者 pod install --repo-update

Then run a pod install inside your terminal, or from CocoaPods.app.

Alternatively to give it a test run, run the command:

pod try BleManageSwift

### 更新日期 2020/9/23

1.0.5版本一直维持在 返回列表选项 1.0.6将取消返回列表

版本 1.0.5 delete don't need BleExtension 删除不要的额外扩展

版本更改为v1.0.3 v1.0.4

版本1.0.1紧急处理了不能调用方法的bug

版本1.0.0初始版本

相应的功能如下:

1. 能够快速的连接多台蓝牙设备
2. 代码相当的简单使用起来方便
3. 支持蓝牙扫描，可以任意自定义自己想要的连接


### 使用介绍



    ！代码在使用过程中出现bug属于正常现象，我会经常的维护此库

使用也非常的简单如果你觉得源代码写的不好可以参与我的代码更改！欢迎你的加入

效果图

![image](https://img-blog.csdnimg.cn/20200923143016211.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ExOTg5MjE0,size_16,color_FFFFFF,t_70)

![image](https://img-blog.csdnimg.cn/20200923143038852.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ExOTg5MjE0,size_16,color_FFFFFF,t_70)

![image](https://img-blog.csdnimg.cn/20200923143103894.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ExOTg5MjE0,size_16,color_FFFFFF,t_70)


首先导入

```java

import BleManageSwift

```


开始扫描设备

```swift

    override func viewDidLoad() {
        super.viewDidLoad()
        BleManage.shared.startScan()
    }
    

```

停止扫描设备

```swift
    BleManage.shared.stopScan()

```


使用扫描过来的设备

```swift

    BleEventBus.onMainThread(self, name: "bleEvent"){
            result in
            self.refresh.endRefreshing()
            let model = result?.object as! BleModel
            //可以自定义判断蓝牙为空的时候不能添加进去直接排除
            if model.name != nil && model.name != ""{
                self.changeTableView(model: model)
            }
        }

```

连接蓝牙设备

```swift

// model为蓝牙设备的model model:BleModel
BleManage.shared.connect(model)

```

#### BleEventBus 介绍

BleEventBus 使用非常简单 想要的数据可以通过任何一个界面去调用

发送数据为  名称+任意的数据类型

```swift

BleEventBus.post("xxxx",sender:Any)

```

接收数据 name为你post的名称

```swift

 BleEventBus.onMainThread(self, name: "xxxx"){
    result in
    //执行你的操作
 }

```

取消使用的时候

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    BleEventBus.unregister(self)
}

```

或者

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    BleEventBus.unregister("xxxx")
}

```

#### BleManage 接收类型介绍

发送设备连接成功的事件

BleEventBus.post("connectEvent", sender: self.successList)

发送扫描设备的事件

BleEventBus.post("bleEvent",sender: model)

断开蓝牙连接的事件

BleEventBus.post("disconnectEvent",sender: model)

蓝牙连接中出现错误事件 这个为字符串类型

BleEventBus.post("connectBleFailEvent",sender: "xxx")

蓝牙读取数据错误事件

BleEventBus.post("readValueError",sender: "xxxx")

蓝牙写入数据错误

BleEventBus.post("writeValueError",sender: "write data \(error)")


接收数据的时候按照去接收

```swift
BleEventBus.onMainThread(self, name: "bleEvent"){
    result in

}
```
