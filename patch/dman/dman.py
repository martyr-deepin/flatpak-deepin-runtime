#!/usr/bin/python3 -OO
# -*- coding: utf-8 -*-

import os
import dbus

appid = os.environ['FLATPAK_APPID']

obj = dbus.SessionBus().get_object('com.deepin.dman', '/com/deepin/dman')

obj.ShowManual(appid, dbus_interface='com.deepin.dman')