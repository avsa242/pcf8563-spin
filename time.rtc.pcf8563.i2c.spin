{
    --------------------------------------------
    Filename: time.rtc.pcf8563.i2c.spin
    Author: Jesse Burt
    Description: Driver for the PCF8563 Real Time Clock
    Copyright (c) 2020
    Started Sep 6, 2020
    Updated Sep 6, 2020
    See end of file for terms of use.
    --------------------------------------------
}

CON

    SLAVE_WR          = core#SLAVE_ADDR
    SLAVE_RD          = core#SLAVE_ADDR|1

    DEF_SCL           = 28
    DEF_SDA           = 29
    DEF_HZ            = 100_000
    I2C_MAX_FREQ      = core#I2C_MAX_FREQ

VAR

    byte _secs, _mins, _hours                           ' Vars to hold time
    byte _days, _wkdays, _months, _years                ' Order is important!

OBJ

    i2c : "com.i2c"                                     ' PASM I2C Driver
    core: "core.con.pcf8563.spin"                       ' Low-level constants
    time: "time"                                        ' Basic timing functions

PUB Null{}
' This is not a top-level object

PUB Start: okay
' Start using 'default' Propeller I2C pins,
'   at safest universal speed of 100kHz
    okay := startx (DEF_SCL, DEF_SDA, DEF_HZ)

PUB Startx(SCL_PIN, SDA_PIN, I2C_HZ): okay

    if lookdown(SCL_PIN: 0..31) and lookdown(SDA_PIN: 0..31)
        if I2C_HZ =< core#I2C_MAX_FREQ
            if okay := i2c.setupx(SCL_PIN, SDA_PIN, I2C_HZ)
                time.msleep(1)
                if i2c.present (SLAVE_WR)               ' Response from device?
                    pollrtctime{}                       ' Initial RTC read
                    return okay

    return FALSE                                        ' Something above failed

PUB Stop{}

    i2c.terminate

PUB Date(ptr_date)

PUB DeviceID{}: id

PUB Days(day): curr_day

    case day
        0..30:
            day := int2bcd(day)
            writereg(core#DAYS, 1, @day)
        other:
            pollrtctime{}
            return bcd2int(_days & core#DAYS_MASK)

PUB Hours(hr): curr_hr

    case hr
        0..23:
            hr := int2bcd(hr)
            writereg(core#HOURS, 1, @hr)
        other:
            pollrtctime{}
            return bcd2int(_hours & core#HOURS_MASK)

PUB Months(month): curr_month

    case month
        1..12:
            month := int2bcd(month)
            writereg(core#CENTMONTHS, 1, @month)
        other:
            pollrtctime{}
            return bcd2int(_months & core#CENTMONTHS_MASK)

PUB Minutes(minute): curr_min

    case minute
        0..59:
            minute := int2bcd(minute)
            writereg(core#MINUTES, 1, @minute)
        other:
            pollrtctime{}
            return bcd2int(_mins & core#MINUTES_MASK)

PUB Seconds(second): curr_sec

    case second
        0..59:
            second := int2bcd(second)
            writereg(core#VL_SECS, 1, @second)
        other:
            pollrtctime{}
            return bcd2int(_secs & core#SECS_BITS)

PUB Weekday(wkday): curr_wkday

    case wkday
        0..6:
            wkday := int2bcd(wkday)
            writereg(core#WEEKDAYS, 1, @wkday)
        other:
            pollrtctime{}
            return bcd2int(_wkdays & core#WEEKDAYS_MASK)

PUB Year(yr): curr_yr

    case yr
        0..99:
            yr := int2bcd(yr)
            writereg(core#YEARS, 1, @yr)
        other:
            pollrtctime{}
            return bcd2int(_years & core#YEARS_MASK)

PRI bcd2int(bcd): int
' Convert BCD (Binary Coded Decimal) to integer
    return ((bcd >> 4) * 10) + (bcd // 16)

PRI int2bcd(int): bcd
' Convert integer to BCD (Binary Coded Decimal)
    return ((int / 10) << 4) + (int // 10)

PRI pollRTCTime{}

    readreg(core#VL_SECS, 7, @_secs)

PRI readReg(reg, nr_bytes, ptr_buff) | cmd_pkt, tmp
' Read nr_bytes from device
    case reg                                            ' Validate reg
        $00..$0f:
            cmd_pkt.byte[0] := SLAVE_WR
            cmd_pkt.byte[1] := reg

            i2c.start{}                                 ' Send reg to read
            i2c.wr_block (@cmd_pkt, 2)

            i2c.start{}
            i2c.write (SLAVE_RD)
            i2c.rd_block (ptr_buff, nr_bytes, TRUE)     ' Read it
            i2c.stop{}
        OTHER:
            return

PRI writeReg(reg, nr_bytes, ptr_buff) | cmd_pkt, tmp
' Write nr_bytes to device
    case reg
        $00..$0f:                                       ' Validate reg
            cmd_pkt.byte[0] := SLAVE_WR
            cmd_pkt.byte[1] := reg

            i2c.start{}                                 ' Send reg to write
            i2c.wr_block (@cmd_pkt, 2)

            repeat tmp from 0 to nr_bytes-1
                i2c.write (byte[ptr_buff][tmp])         ' Write it
            i2c.stop{}
        OTHER:
            return


DAT
{
    --------------------------------------------------------------------------------------------------------
    TERMS OF USE: MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
    associated documentation files (the "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
    following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial
    portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    --------------------------------------------------------------------------------------------------------
}
