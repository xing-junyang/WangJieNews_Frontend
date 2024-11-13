# 望界新闻：作业一

## 功能介绍

本应用是一个**新闻浏览软件**，采用服务器-客户端模式开发，本鸿蒙 APP 相当于客户端。服务器使用 Spring Boot 架构进行开发，首先在指定的网站上获取新闻数据，并存入数据库，然后接受客户端的 HTTP 请求，以 JSON 数据的格式返回给客户端。客户端加载数据，并显示新闻。

进入客户端，首先从服务器加载数据，然后呈现给用户。使用动态布局，当屏幕宽（使用情景：如平板）时使用分栏，当屏幕窄时（使用情景：如手机）使用单栏。下方有一个 `Tab` 导航栏，“**首页**”主要用来**浏览新闻**，“**我的**”用来查看**收藏点赞、浏览历史、个人资料和账号管理**（未开发）。首页利用 `Tab` 展现新闻栏目，并展示新闻条目。新闻条目是一个个可点击组件，使用 `Navigation` 进行导航，点击后可以利用 `Webview` 预览查看具体的新闻。新闻预览界面可以对本条新闻进行收藏和点赞，随后可在“我的”界面中查看。此外，在浏览新闻的过程中，应用还会自动记录浏览历史，方便用户进行回看。

> **重要提示：默认的后端服务器部署于境外，较不稳定。复现时，如果后端服务器挂掉，可以自行部署后端服务器（见下面的 Git 仓库）并手动修改 `harmony_homework_client-main/entry/src/main/resources/base/profile/ip_config.json` 文件中的 `backend_ip_address` 键值，否则可能无法正常载入新闻。如有疑问，可以随时联系本人。**

## 代码仓库

- **客户端（本作业）**：https://git.nju.edu.cn/34_2024_fall_devops/harmony_homework_client

- 后端（附属性工作，可检查或部署）：https://git.nju.edu.cn/xingjunyang/harmony_homework_backend

## 功能实现

### 应用结构

- 使用 `Navigation` 进行导航，将各个页面封装成组件，实现主页面和子页面的导航。

  ![Screen Shot 2024-11-09 at 4.05.54 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.05.54%20PM.png)

  ![Screen Shot 2024-11-09 at 4.04.32 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.04.32%20PM-1139485.png)

- 使用鸿蒙原生的控件，例如列表、按钮、`Row/Column` 等
  <img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.11.06%20PM.png" alt="Screen Shot 2024-11-09 at 4.11.06 PM" style="zoom:33%;" />

  ![Screen Shot 2024-11-09 at 4.07.50 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.07.50%20PM.png)

- 子页面可以通过 `WebView` 组件来浏览新闻
  <img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.12.04%20PM.png" alt="Screen Shot 2024-11-09 at 4.12.04 PM" style="zoom: 33%;" />

### 导航与**Tab**功能

- 通过 `Navigation` 来实现⻚面之间的导航功能

- 包含两个 `Tab` 页面，一个来**我的**和**首页**进行切换，另外一个用于新闻的**筛选分类浏览**。
  ![Screen Shot 2024-11-09 at 4.15.09 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.15.09%20PM.png)


![Screen Shot 2024-11-09 at 4.15.19 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.15.19%20PM.png)

### 网络通信

- 通过 **HTTP** 请求与后端服务器进行通信，关于后端，可阅读相关代码仓库。

  ![Screen Shot 2024-11-09 at 4.16.29 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.16.29%20PM.png)

- 对收到的 JSON 数据进行解析处理，形成 `NewsItem` 对象。

  ![Screen Shot 2024-11-09 at 4.16.58 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.16.58%20PM.png)

### 数据存储

- 将处理后的数据存储在本地数据库。使用关系型数据库进行存储。
  ![Screen Shot 2024-11-09 at 4.18.41 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.18.41%20PM.png)

  ![Screen Shot 2024-11-09 at 4.19.20 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.19.20%20PM.png)

### **ArkTS**与**WebView**交互

- `ArkTS` 将访问的 URL 传递给 Webview，而 Webview 还可以对修改数据库的函数进行调用（如点赞和收藏）。

### 界面的要求

- 美观大方。

  <img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.21.40%20PM.png" alt="Screen Shot 2024-11-09 at 4.21.40 PM" style="zoom:33%;" />

- 针对不同屏幕尺寸和分辨率进行基本适配。如平板：
  ![Screenshot_2024-11-09T162311](./%E4%BD%9C%E4%B8%9A1.assets/Screenshot_2024-11-09T162311.png)

## 创新点

### 多语言

利用 `resource` 中多语言功能，支持中文和英文

<img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.27.19%20PM.png" alt="Screen Shot 2024-11-09 at 4.27.19 PM" style="zoom:33%;" />