#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITPPC)),)
$(error "Please set DEVKITPPC in your environment.")
endif

LIBOGC       := $(DEVKITPRO)/libogc
LIBOGC_INC   := $(LIBOGC)/include
LIBOGC_LIB   := $(LIBOGC)/lib/wii
PORTLIBS_LIB := $(DEVKITPRO)/portlibs/ppc/lib
PORTLIBS_INC := $(DEVKITPRO)/portlibs/ppc/include

include $(DEVKITPPC)/wii_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
#---------------------------------------------------------------------------------
TARGET  := boot
BUILD   := build
DATA    := data
SOURCES	:= source/Bios \
           source/Board \
           source/Debugger \
           source/Emulator \
           source/Expat \
           source/GuiBase \
           source/GuiLayers \
           source/GuiElements \
           source/GuiDialogs \
           source/Gui \
           source/Input \
           source/IoDevice \
           source/Language \
           source/Libpng \
           source/Media \
           source/Memory \
           source/Resource \
           source/SoundChips \
           source/TinyXML \
           source/Tools/Trainer \
           source/Unzip \
           source/Utils \
           source/VideoChips \
           source/VideoRender \
           source/Wii \
           source/WiiUsbKeyboard \
           source/Z80

#---------------------------------------------------------------------------------
# Options for code generation
#---------------------------------------------------------------------------------

CFLAGS = -g -O2 -Wall -Wno-write-strings $(MACHDEP) $(INCLUDE) \
         -DNO_ASM -DWII -DBLUEMSXWII -DUSE_EMBEDDED_SDCARD_IMAGE
CXXFLAGS = $(CFLAGS)
LDFLAGS = -g $(MACHDEP) -Wl,-Map,$(notdir $@).map

#---------------------------------------------------------------------------------
# Any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS := -ldb -logc -lz -lpng -lfreetype -lwiiuse -lbte -lfat -lm -lbz2 -lmad

#---------------------------------------------------------------------------------
# List of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
#LIBDIRS := $(CURDIR)

#---------------------------------------------------------------------------------
# No real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT  := $(CURDIR)/$(TARGET)
export DEPSDIR := $(CURDIR)/$(BUILD)
export VPATH   := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
                  $(foreach dir,$(DATA),$(CURDIR)/$(dir))


#---------------------------------------------------------------------------------
# Automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES   := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))
BINFILES := $(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))
PNGFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.png)))
TTFFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.ttf)))

#---------------------------------------------------------------------------------
# Use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
    export LD := $(CC)
else
    export LD := $(CXX)
endif

export OFILES := $(addsuffix .o,$(BINFILES)) \
                 $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) \
                 $(sFILES:.s=.o) $(SFILES:.S=.o)

export GENFILES := sdcard.inc gamepack.inc \
                   $(PNGFILES:.png=.inc) \
                   $(TTFFILES:.ttf=.inc)

#---------------------------------------------------------------------------------
# Build a list of include paths
#---------------------------------------------------------------------------------
export INCLUDE := -I$(CURDIR)/$(BUILD) \
                  -I$(CURDIR)/include \
                  -I$(LIBOGC_INC) \
                  -I$(LIBOGC_INC)/ogc \
                  -I$(PORTLIBS_INC) \
                  -I$(PORTLIBS_INC)/freetype2

#---------------------------------------------------------------------------------
# Build a list of library paths
#---------------------------------------------------------------------------------
export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib/wii) \
                   -L$(LIBOGC_LIB) \
                   -L$(PORTLIBS_LIB)

export OUTPUT   := $(CURDIR)/$(TARGET)

.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(OUTPUT).elf $(OUTPUT).dol

#---------------------------------------------------------------------------------
run:
	wiiload $(TARGET).dol

#---------------------------------------------------------------------------------
disasm:
	@echo Disassembling ...
	@$(DEVKITPPC)/bin/powerpc-eabi-objdump -S $(TARGET).elf >$(TARGET).txt

#---------------------------------------------------------------------------------
else

DEPENDS := $(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# Main targets
#---------------------------------------------------------------------------------
MSXWii: $(GENFILES) $(OUTPUT).dol

$(OUTPUT).dol: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

#---------------------------------------------------------------------------------
# Links in binary data with the .jpg extension
#---------------------------------------------------------------------------------
%.jpg.o: %.jpg
	@echo $(notdir $<)
	$(bin2o)

#---------------------------------------------------------------------------------
# Creates the zip files for the sd-card contents and converts it to header files
#---------------------------------------------------------------------------------
sdcard.inc: ../sdcard/MSX
	@echo Creating sdcard.zip ...
	@rm -f sdcard.zip
	@7za a -r -xr!*.svn -xr!thumbs.* sdcard.zip ../sdcard/MSX
	@echo Converting sdcard.zip to sdcard.inc ...
	@../util/raw2c sdcard.zip sdcard.inc sdcard

gamepack.inc: ../sdcard/Gamepack
	@echo Creating gamepack.zip ...
	@rm -f gamepack.zip
	@7za a -r -xr!*.svn -xr!thumbs.* gamepack.zip ../sdcard/Gamepack/Games
	@echo Converting gamepack.zip to gamepack.inc ...
	@../util/raw2c gamepack.zip gamepack.inc gamepack

#---------------------------------------------------------------------------------
# This rule converts .png to .inc files
#---------------------------------------------------------------------------------
%.inc: %.png
	@echo Converting $(notdir $<) to $(notdir $@) ...
	@../util/raw2c $< $(CURDIR)/$@ $(notdir $@)

#---------------------------------------------------------------------------------
# This rule converts .ttf to .inc files
#---------------------------------------------------------------------------------
%.inc: %.ttf
	@echo Converting $(notdir $<) to $(notdir $@) ...
	@../util/raw2c $< $(CURDIR)/$@ $(notdir $@)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
