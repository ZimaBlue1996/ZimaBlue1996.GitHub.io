#! /usr/bin/env python
#coding=utf-8
import os
import time
from ctypes import *
import numpy as np 

class USBI2C():
    ch341 = windll.LoadLibrary("C:/WCH.CN/CH341PAR/CH341DLLA64.dll")
    def __init__(self, usb_dev = 0, i2c_dev = 0):
        self.usb_id   = usb_dev
        self.dev_addr = i2c_dev
        if USBI2C.ch341.CH341OpenDevice(self.usb_id) != -1:
            USBI2C.ch341.CH341SetStream(self.usb_id, 0x80)
            USBI2C.ch341.CH341CloseDevice(self.usb_id)
        else:
            print("USB CH341 Open Failed!")

    def read(self, addr,len):
        if USBI2C.ch341.CH341OpenDevice(self.usb_id) != -1:
            obuf = (c_byte * 2)()
            ibuf = (c_byte * len)()
            obuf[0] = self.dev_addr
            obuf[1] = addr
            USBI2C.ch341.CH341StreamI2C(self.usb_id, 2, obuf, len, ibuf)
            USBI2C.ch341.CH341CloseDevice(self.usb_id)
            # return ibuf[0] & 0xff
            return ibuf
        else:
            print("USB CH341 Open Failed!")
            return 0

    def write(self, addr, dat):
        if USBI2C.ch341.CH341OpenDevice(self.usb_id) != -1:
            obuf = (c_byte * 3)()
            ibuf = (c_byte * 1)()
            obuf[0] = self.dev_addr
            obuf[1] = addr
            obuf[2] = dat & 0xff
            USBI2C.ch341.CH341StreamI2C(self.usb_id, 3, obuf, 0, ibuf)
            USBI2C.ch341.CH341CloseDevice(self.usb_id)
        else:
            print("USB CH341 Open Failed!")

if __name__ == '__main__':
    
    regs_add = [0x0b,0x0f,0x24,0x25,0x26,0x2e,0x2f]
    for i in range(len(regs_add)):
        i2cDevice = USBI2C(0,0x32)
        buf = i2cDevice.read(regs_add[i],1)
        print(hex(regs_add[i]),hex(c_uint8(buf[0]).value))
