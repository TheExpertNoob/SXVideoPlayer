.SUFFIXES:

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment.")
endif

export PATH := $(DEVKITPRO)/devkitA64/bin:$(PATH)
CC       := aarch64-none-elf-gcc
export LD := $(CC)

LIBNX    := $(DEVKITPRO)/libnx
PORTLIBS := $(DEVKITPRO)/portlibs/switch
LIBDIRS  := $(PORTLIBS) $(LIBNX)
LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)
INCLUDE  := $(foreach dir,$(LIBDIRS),-I$(dir)/include)

ARCH     := -march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE
CFLAGS   := -g -Wall -O2 -ffunction-sections $(ARCH) -D__SWITCH__ $(INCLUDE)
LDFLAGS   = -specs=$(LIBNX)/switch.specs -g $(ARCH) -Wl,-Map,$*.map
LIBS     := -lnx

SOURCES  := source
VPATH    := $(SOURCES)
TARGETS  := index video

.PHONY: all clean

all: $(addsuffix .elf, $(TARGETS))

%.elf: %.o
	$(CC) $(LDFLAGS) -o $@ $< $(LIBPATHS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@echo clean ...
	@rm -f $(addsuffix .elf,  $(TARGETS)) \
	       $(addsuffix .o,    $(TARGETS)) \
	       $(addsuffix .map,  $(TARGETS))