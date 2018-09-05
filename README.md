# viper-project 

VIPER的全称是View-Interactor-Presenter-Entity-Router。
相比之前的MVX架构，VIPER多出了两个东西：Interactor（交互器）和Router（路由）。

各部分职责如下：

View
提供完整的视图，负责视图的组合、布局、更新
向Presenter提供更新视图的接口
将View相关的事件发送给Presenter
Presenter
接收并处理来自View的事件
向Interactor请求调用业务逻辑
向Interactor提供View中的数据
接收并处理来自Interactor的数据回调事件
通知View进行更新操作
通过Router跳转到其他View
Router
提供View之间的跳转功能，减少了模块间的耦合
初始化VIPER的各个模块
Interactor
维护主要的业务逻辑功能，向Presenter提供现有的业务用例
维护、获取、更新Entity
当有业务相关的事件发生时，处理事件，并通知Presenter
Entity
和Model一样的数据模型
和MVX的区别
VIPER把MVC中的Controller进一步拆分成了Presenter、Router和Interactor。和MVP中负责业务逻辑的Presenter不同，VIPER的Presenter的主要工作是在View和Interactor之间传递事件，并管理一些View的展示逻辑，主要的业务逻辑实现代码都放在了Interactor里。Interactor的设计里提出了"用例"的概念，也就是把每一个会出现的业务流程封装好，这样可测试性会大大提高。而Router则进一步解决了不同模块之间的耦合。所以，VIPER和上面几个MVX相比，多总结出了几个需要维护的东西：

View事件管理
数据事件管理
事件和业务的转化
总结每个业务用例
模块内分层隔离
模块间通信
而这里面，还可以进一步细分一些职责。VIPER实际上已经把Controller的概念淡化了，这拆分出来的几个部分，都有很明确的单一职责，有些部分之间是完全隔绝的，在开发时就应该清晰地区分它们各自的职责，而不是将它们视为一个Controller。


快速搭建viper项目的基础框架， App的框架，如大楼之根基，好的框架对于开发，拓展和维护可以起到事半功倍的效果，其重要性不言而喻。 


本基础框架融合了以下几点
- 全局无痕埋点配置 ：UIView / UIControl / UIViewController / NSNotifationCenter / UIApplication / UITableview / UIScrollvieww / UICollectionView
- webviewBridge交互事件注入与维护；
- viper架构的搭建；
- 工具类的集成。
- 源文件分层处理思想
- 多点登录RAC
- 登录监听RAC

著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处！！！


