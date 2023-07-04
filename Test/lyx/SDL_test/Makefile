
PROJECT = SDL_test
MAJOR_REV := 0
MINOR_REV := 1
SVN_REV   := $(shell svn info --show-item revision || echo 0)
VERSION   := ${MAJOR_REV}.${MINOR_REV}.${SVN_REV}

LOONG ?= loong-5.2
MACH  ?= lpc1758

ifeq (${MACH},native)
  TARGET  := native
  EXT     :=
  CFLAGS  := -g 
  LDFLAGS := -g -lSDL2
  CFLAGS  += -I/${LOONG}/native/sysroot/usr/include
  LDFLAGS += -L/${LOONG}/native/sysroot/usr/lib
endif
ifeq (${MACH},lpc1758)
  ARCH    := lpc17
  TARGET  := arm-m3-eabi
  EXT     := .lpc
  CFLAGS  := -I../SDL_lite -DSDL_lite
  LDFLAGS += -T../platform/lpc17/lpc1758.ld -Wl,-Map=${PROGRAM}.map
  SDL_lite:= y
endif
ifeq (${MACH},eg4s20)
  TARGET  := arm-m3-eabi
  EXT     := .eg4s
  CFLAGS  := -I../SDL_lite -DSDL_lite
  LDFLAGS += -T../platform/eg4s/eg4s20.ld -Wl,-Map=${PROGRAM}.map
  SDL_lite:= y
endif

CC     := ${TARGET}-gcc
STRIP  := ${TARGET}-strip
CFLAGS += -Wall -Os -std=gnu99 -pipe -I.
CFLAGS += -DMAJOR_REV=${MAJOR_REV} -DMINOR_REV=${MINOR_REV} -DSVN_REV=${SVN_REV}
CFLAGS += -DHW_REV=${HW_REV} -DHW_NAME=${HW_NAME}
CFLAGS += -DMACH_${MACH} -DMACH=${MACH} -DARCH=${ARCH} -DARCH_${ARCH}

BUILD_DIR   ?= ${CURDIR}/build/${MACH}
PACKAGE_DIR := ${CURDIR}/build/${MACH}_package
RELEASE_DIR := ${CURDIR}/../release
PROGRAM := ${CURDIR}/build/${PROJECT}${EXT}

PATH  := ${PATH}:/${LOONG}/${TARGET}/bin
VPATH += ${CURDIR}/../SDL_lite ${CURDIR}/../platform

OBJS_${SDL_lite} := console.o fmtio.o ra8875.o SDL.o
OBJS_APP := startup.o main.o font.o SDL_txt.o
OBJS := $(addprefix ${BUILD_DIR}/,${OBJS_APP} ${OBJS_y})

DEPS  := $(OBJS:.o=.d)

define OCD_CFG =
source [find lpc17xx.ocd]
proc erase {}    { reset halt; flash erase_address pad 0 0x20000 }
proc write {}    { f ${PROJECT}.hex; reset halt; flash uuid 0x1000 update}
proc verify {}   { v ${PROJECT}.hex }
proc checksum {} { load_image ${PROJECT}.hex }
endef
export OCD_CFG

all: ${BUILD_DIR} ${PROGRAM}

install: all
	sudo openocd -f lpc17xx.ocd -c "f ${PROGRAM}" -c reset -c exit

release: all
	rm -rf ${PACKAGE_DIR}
	mkdir -p ${PACKAGE_DIR}
	${TARGET}-objcopy ${PROGRAM} -O ihex ${PROGRAM}.hex
	cp ${PROGRAM}.hex ${PACKAGE_DIR}/${PROJECT}.hex
	echo "$${OCD_CFG}" > ${PACKAGE_DIR}/${PROJECT}.ocd
	unix2dos ${PACKAGE_DIR}/${PROJECT}.ocd
	cd ${PACKAGE_DIR}; zip ${PROJECT}.oz ${PROJECT}.hex ${PROJECT}.ocd
	mkdir -p ${RELEASE_DIR}
	cp ${PACKAGE_DIR}/${PROJECT}.oz ${RELEASE_DIR}/${PROJECT}-${VERSION}.oz
	
${PROGRAM}: ${OBJS}
	$(CC) ${OBJS} ${LIBS} ${LDFLAGS} -o $@
ifeq (${SDL_lite},y)
	${TARGET}-size -A -x $@
endif
	
${BUILD_DIR}/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

${BUILD_DIR}/%.d: %.c
	mkdir -p $(dir $@)
	$(CC) -M $(CFLAGS) $< | \
	sed 's#\($*\)\.o[ :]*#${BUILD_DIR}/\1.o $@ : #g' > $@

${BUILD_DIR}:
	mkdir -p $@
	
clean:
	rm -f ${BUILD_DIR}/*
	rm -f ${PROGRAM}

sinclude $(DEPS)

