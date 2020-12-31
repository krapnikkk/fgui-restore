## 快捷创建初始化项目
```
fgui-cli create [project] -version [verison]
```

## 快捷打开工程 
```
fgui-cli open []
```

## 查找未使用资源
```
fgui-cli check
```

## 快捷浏览fgui发布后的资源文件[仅支持大部分H5平台的特性]
```
fgui-cli view [fileName]
```

## 还原fgui发布文件成原始资源文件
```
fgui-cli restore [fileName]
```

### 还原程度
 - 将合并的纹理图片还原成碎图【统一png格式】
 - 将碎图和package.xml关联绑定
 - 将组件xml和package.xml关联绑定
 - 将动画Movieclip还原成jta文件【动画设置以帧频：24为基准进行还原】
 - 将位图字体文件还原成fnt文件【二进制格式资源包统一还原成UIBuilder默认格式】
 
  
### 无法还原项
 - 骨骼动画资源还原
 - 分支还原
 - 项目设置中的默认设置项
 - 不被打包合并的资源或者不支持的资源【比如.swf,仅单纯放置到包内】

### 资源文件内容一览
 - package.xml
 - sprites.bytes
 - .xml
 - .fnt
 - .jta

## xml解析流程
 - 解析发布出来的资源文件
 - 根据文件格式版本分布解析二进制和压缩描述文件
 - 将发布的资源文件解析还原为xml
 - 【image】图片资源根据id还原name 和 文件路径 packageDescription.resources[0].image
 - 【movieclip】packageDescription.resources[0].movieclip
 - 【sound】packageDescription.resources[0].sound

## 二进制格式解析流程
 - createObject 【UIPackage】
 - constructFromResource【component】
 - controller.setup【controller】
 - setup_beforeAdd 【component-child-GObject】
 - relations.setup【relations】
 - setup_afterAdd 【component-child-GObject】
 - trans.setupp 【transion】
 - constructExtension 【extension】

## 细节优化
 - 是否显示调试结果
 - 异常事件处理机制


## 工程结构目录
├── utlis // 工具函数
├── tpl // 模板文件
├── view // 预览工程
├── 