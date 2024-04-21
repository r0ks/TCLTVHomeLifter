#!/system/bin/sh

MODDIR=${0%/*}
logFile="${MODDIR}/TCLTVHomeLifter.log"
echo "" > $logFile

# 定义日志函数
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $logFile
}

# 检查桌面是否已启动
check_desktop_resumed() {
    dumpsys activity activities | grep mResumedActivity | grep -E "com.tcl.cyberui/.MainActivity|com.tcl.cyberui/com.tcl.cyberui.MainActivity"
    return $?
}

# 检查桌面是否已fucus
check_desktop_current_focus() {
    dumpsys window windows | grep mCurrentFocus | grep -E "com.tcl.cyberui/.MainActivity|com.tcl.cyberui/com.tcl.cyberui.MainActivity"
    return $?
}

# 拒绝cyberui联网
reject_cyberui_network() {
    su -c "iptables -A OUTPUT -m owner --uid-owner 1000 -j REJECT" >> $logFile 2>&1
    su -c "iptables -A INPUT -m owner --uid-owner 1000 -j REJECT" >> $logFile 2>&1
}

# 启动emotnui
pull_up_emotnui() {
    # home键绑定emotnui
    su -c "cmd package set-home-activity 'com.oversea.aslauncher/.ui.main.MainActivity'" >> $logFile 2>&1
    # 拉起emotnui
    su -c "am start -n com.oversea.aslauncher/.ui.main.MainActivity" >> $logFile 2>&1
}

# 输出dumpsys结果的函数（已停用，保留方便以后使用）
dumpsys_to_log() {
    log "Current Focus:"
    dumpsys window windows | grep mCurrentFocus >> $logFile 2>&1
    log "Focused App:"
    dumpsys window windows | grep mFocusedApp >> $logFile 2>&1
    log "Resumed Activity:"
    dumpsys activity activities | grep mResumedActivity >> $logFile 2>&1
    log "Top Activity in the stack:"
    dumpsys activity | grep top-activity >> $logFile 2>&1
}

i=0
# 循环检查直到桌面启动
while true; do
    i=$((i + 1))
    if [ $i -gt 30 ]; then
        log "----------------------MAIN TOO MUCH LOOPS-----------------------"
        break;
    fi
    log "----------------------MAIN START-----------------------"
    log "Checking if desktop has resumed..."
    if check_desktop_resumed; then
        log "Desktop is resumed, performing actions..."
        reject_cyberui_network
        ii=0
        while true; do
            ii=$((ii + 1))
            if [ $ii -gt 60 ]; then
                log "----------------------SUB TOO MUCH LOOPS-----------------------"
                break;
            fi
            log "----------------------SUB START-----------------------"
            log "Checking if desktop has been focused..."
            if check_desktop_current_focus; then
                # 延迟不够就加这个
                sleep 2.3
                log "Desktop is focused, performing actions..."
                pull_up_emotnui
                break;
            else
                log "Desktop not focused, waiting..."
            fi
            sleep 0.2
            log "----------------------SUB END-----------------------"
        done
        log "Actions completed and desktop setup is finalized."
        break
    else
        log "Desktop not resumed, waiting..."
    fi
    # 等待400ms再检查一次
    sleep 0.4
    log "-----------------------MAIN END------------------------"
done
