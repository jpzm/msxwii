/*****************************************************************************
** $Source: /cvsroot/bluemsx/blueMSX/Src/Sdl/bluemsxlite.c,v $
**
** $Revision: 1.20 $
**
** $Date: 2006/06/24 08:35:29 $
**
** More info: http://www.bluemsx.com
**
** Copyright (C) 2003-2006 Daniel Vik
**
**  This software is provided 'as-is', without any express or implied
**  warranty.  In no event will the authors be held liable for any damages
**  arising from the use of this software.
**
**  Permission is granted to anyone to use this software for any purpose,
**  including commercial applications, and to alter it and redistribute it
**  freely, subject to the following restrictions:
**
**  1. The origin of this software must not be misrepresented; you must not
**     claim that you wrote the original software. If you use this software
**     in a product, an acknowledgment in the product documentation would be
**     appreciated but is not required.
**  2. Altered source versions must be plainly marked as such, and must not be
**     misrepresented as being the original software.
**  3. This notice may not be removed or altered from any source distribution.
**
******************************************************************************
*/

#include <stdio.h>
#include <debug.h>
#include <fat.h>
#include <ogc/system.h>      // for syswd_t (required in ogc/usbstorage.h)
#include <ogc/usbstorage.h>
#include <sdcard/wiisd_io.h>

#include "../Gui/GuiMain.h"
#include "WiiInput.h"
#include "WiiLog.h"

#define ENABLE_GECKO  1

bool g_bSDMounted;
bool g_bUSBMounted;

int main(int argc, char **argv)
{
    // USB Gecko
#if ENABLE_GECKO
    DEBUG_Init(GDBSTUB_DEVICE_USB, 1);
    CON_EnableGecko(1, false);
#endif
    // Set main thread priority
    LWP_SetThreadPriority(LWP_GetSelf(), 100);

    // Init Wiimote
    PAD_Init();
    WPAD_Init();
    WPAD_SetDataFormat(WPAD_CHAN_0, WPAD_FMT_BTNS_ACC_IR);
    WPAD_SetDataFormat(WPAD_CHAN_1, WPAD_FMT_BTNS_ACC_IR);

    // Init Storage (keyboard layout can be saved)
    g_bSDMounted  = fatMountSimple("sd", &__io_wiisd);
    g_bUSBMounted = fatMountSimple("usb", &__io_usbstorage);

    wii_log_start();
    wii_log("main", "starting");

    // GUI init
    GuiMain *guimain = new GuiMain();
    wii_log("main", "GUI created");

    // Init keyboard
    keyboardInit(guimain);
    wii_log("main", "keyboard initialized");

    // Let's rock now!
    guimain->Run();
    wii_log("main", "GUI running");
    keyboardClose();
    wii_log("main", "keyboard closed");

    // Cleanup
    delete guimain;
    wii_log("main", "GUI deleted");

    wii_log_stop();

    fatUnmount("sd");
    fatUnmount("usb");

    return 0;
}
