package com.github.r0ks.tcltvhomelifter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class StartupReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        if (Intent.ACTION_BOOT_COMPLETED == intent?.action) {
            try {
                val commands = arrayOf(
                    "/system/bin/iptables -A OUTPUT -m owner --uid-owner 1000 -j REJECT",
                    "/system/bin/iptables -A INPUT -m owner --uid-owner 1000 -j REJECT",
                    "/system/bin/cmd package set-home-activity \"com.oversea.aslauncher/.ui.main.MainActivity\"",
//                    "/system/bin/am start -n com.oversea.aslauncher/.ui.main.MainActivity"
                )
                val logFilePath = "/tmp/TCLTVHomeLifter.log"
                for (command in commands) {
                    Runtime.getRuntime()
                        .exec(arrayOf("su", "-c", "sh -c '$command >> $logFilePath 2>&1'"))
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}