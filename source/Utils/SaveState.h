/*****************************************************************************
** $Source: /cvsroot/bluemsx/blueMSX/Src/Utils/SaveState.h,v $
**
** $Revision: 1.6 $
**
** $Date: 2008/06/25 22:26:17 $
**
** More info: http://www.bluemsx.com
**
** Copyright (C) 2003-2006 Daniel Vik
**
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
**
******************************************************************************
*/
#ifndef SAVE_STATE_H
#define SAVE_STATE_H

#include "../Common/MsxTypes.h"
#include "ziphelper.h"

typedef struct SaveState SaveState;

#ifdef __cplusplus
extern "C" {
#endif

void saveStateCreateForRead(ZipFile *zip);
void saveStateCreateForWrite(void);

SaveState* saveStateOpenForRead(const char* fileName);
SaveState* saveStateOpenForWrite(const char* fileName);
void saveStateClose(SaveState* state);

UInt32 saveStateGet(SaveState* state, const char* tagName, UInt32 defValue);
void saveStateSet(SaveState* state, const char* tagName, UInt32 value);

void saveStateGetBuffer(SaveState* state, const char* tagName, void* buffer, UInt32 length);
void saveStateSetBuffer(SaveState* state, const char* tagName, void* buffer, UInt32 length);

#ifdef __cplusplus
}
#endif

#endif /* SAVE_STATE_H */

