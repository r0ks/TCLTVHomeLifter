#!/system/bin/sh

MODDIR=${0%/*}
logFile="${MODDIR}/Service.log"
echo "" > $logFile

# 写入日志的功能
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $logFile
}

# 记录开始执行的时间
log "Starting service script"

# 确保执行权限
chmod +x ${MODDIR}/tcl_tv_home_lifter.sh
log "Set executable permission for tcl_tv_home_lifter.sh"

# 执行脚本
log "Executing tcl_tv_home_lifter.sh"
${MODDIR}/tcl_tv_home_lifter.sh

# 记录脚本执行结束
log "tcl_tv_home_lifter.sh execution completed"
