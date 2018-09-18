#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2017/8/30 13:49
# @Author  : TangZhiFeng
# @File    : VPN.py
# @Software: PyCharm Community Edition

import os


class VPNHelper(object):
    def __init__(self, _vpnIP, _userName, _passWord, WinDir=r"C:\windows\system32", RasDialFileName=r'\rasdial.exe'):
        self.IPToPing = _vpnIP
        self._VPNName = _vpnIP
        self._UserName = _userName
        self._PassWord = _passWord
        self._WinDir = WinDir
        self._RasDialFileName = RasDialFileName
        self._VPNPROCESS = self._WinDir + self._RasDialFileName

    def connectVPN(self):
        try:
            command = '"' + self._VPNName + '" ' + self._UserName + " " + self._PassWord
            print(self._VPNPROCESS + " " + command)
            os.system(self._VPNPROCESS + " " + command)
        except:
            print("VPN连接失败!")

    def disConnectVPN(self):
        try:
            command = '"' + self._VPNName + '" ' + " /d"
            print(self._VPNPROCESS + " " + command)
            os.system(self._VPNPROCESS + " " + command)
        except:
            print("VPN断开失败!")

    def Restart(self, waitingTime=0):
        import time
        self.connectVPN()
        time.sleep(waitingTime)
        self.disConnectVPN()


if __name__ == "__main__":
    vpn = VPNHelper("VPN设置的名称", "账号", "密码")
    # vpn.disConnectVPN()
    # vpn.connectVPN()
    vpn.Restart(20)

# 作者：大大大大峰哥
# 链接：https://www.jianshu.com/p/50b7dbd4848e
# 來源：简书
# 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。