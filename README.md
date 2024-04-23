# TCLTVHomeLifter

该项目提供了一种变通方法来隐藏 TCL 电视的 `com.tcl.cyberui` 应用。

## 适用前提

- **设备要求**：TCL 电视，机芯 S48CT05
- **系统要求**：Android 8.0，已获取 root 权限
- **注意**：target-sdk 最低版本为 23，Android 8.0 以下版本不可用

## 背景

TCL 自带的 `cyberui` 系统界面魔改太多，直接删除或隐藏都会导致系统不稳定，因此选择保留。通过将该 APK 放置于 `/system/app/` 下，并在电视启动时监听系统启动完成的广播，执行以下功能：

1. **网络控制**：使用 iptables 禁止 uid=1000 的进程联网，以去除广告（不仅限于 `cyberui`）。
2. **Home 键重定向**：使用 cmd 命令设置 `emotnui` 为遥控器 Home 键的默认响应应用。
3. **自动启动**：（功能已注释未启用）自动拉起 `emotnui` 桌面。

## 当前存在的问题

由于我当前的能力限制，以下问题不打算进行修复：

1. **启动延迟**：Android 系统的启动完成广播要在 `cyberui` 界面展示约 1 分钟后才会接收到，因此在这一分钟内仍会展示 `cyberui` 桌面，并可能显示广告。
2. **Home 键绑定**：一旦绑定 Home 键后，进入 `emotnui` 就无法返回到 `cyberui`（这也算是达到了隐藏 `cyberui` 的目的）。
3. **网络控制泛化**：使用 uid=1000 的其它系统应用也会被 iptables 拦截。

## UPDATE 修改为使用magisk模块
开机监测com.tcl.cyberui状态，focus后等待2.3s后（暂未有更好的方法），强行拉起emotnui，同时iptables拒绝系统应用联网

## 贡献

欢迎通过 Pull Requests 或 Issues 提出改进建议或报告问题。
