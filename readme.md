# 大作业-望界新闻

## 小组成员

组长：221250147吕炳蓁

组员：221250142顾益铭，221250143孟昭辰，221250148黄瑞申，221250149山雨冬

## 功能介绍

本应用是一个新闻浏览软件，采用服务器-客户端模式开发。

服务器使用 Spring Boot 架构进行开发，实现了作业要求。1.UserController、NewsController等提供了 RESTful API 接口，与移动端进行通信。2.实现了用户的注册与登录，必须登录后才能使用新闻浏览等功能。3.使用MySQL数据库进行数据存储，采用JPA框架与数据库进行交互。4.提供错误处理机制，便于客户端能够有效处理。

移动端使用ArkTS语言进行开发。用户首先进入登录页，可以登录或前往注册页注册；登录成功后，首先从服务器加载数据，然后呈现给用户；加载数据时采用taskpool同时加载不同的数据，提高加载速度。页面采用 `Tab` 布局，“首页”主要用来浏览新闻，“我的”用来查看收藏点赞或浏览历史、退出登录等。首页利用 `Tab` 展现新闻栏目，并展示新闻条目。新闻条目是一个个可点击组件，使用 `Navigation` 进行导航，点击后可以利用 `Webview` 预览查看具体的新闻。新闻预览界面可以对本条新闻进行收藏和点赞，随后可在“我的”界面中查看。此外，在浏览新闻的过程中，应用还会自动记录浏览历史，方便用户进行回看。

## 功能实现

### 应用结构

- 使用 `Navigation` 进行导航，将各个页面封装成组件，实现主页面和子页面的导航。

  ![Screen Shot 2024-11-09 at 4.05.54 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.05.54%20PM.png)

  ![Screen Shot 2024-11-09 at 4.04.32 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.04.32%20PM-1139485.png)
- 使用鸿蒙原生的控件，例如列表、按钮、`Row/Column` 等
  `<img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.11.06%20PM.png" alt="Screen Shot 2024-11-09 at 4.11.06 PM" style="zoom:33%;" />`

  ![Screen Shot 2024-11-09 at 4.07.50 PM](./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.07.50%20PM.png)
- 子页面可以通过 `WebView` 组件来浏览新闻
  `<img src="./%E4%BD%9C%E4%B8%9A1.assets/Screen%20Shot%202024-11-09%20at%204.12.04%20PM.png" alt="Screen Shot 2024-11-09 at 4.12.04 PM" style="zoom: 33%;" />`

### 导航与**Tab**功能

- 通过 `Navigation` 来实现页面之间的导航功能
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

## 代码仓库与团队协作

- 客户端：[2024_fall_mobile_internet / Harmony_Homework_Client · 极狐GitLab](https://git.nju.edu.cn/2024_fall_mobile_internet/harmony_homework_client)
- 服务端：[2024_fall_mobile_internet / Harmony_Homework_Server · 极狐GitLab](https://git.nju.edu.cn/2024_fall_mobile_internet/harmony_homework_backend)
- git提交记录：TODO
- 会议记录：TODO
