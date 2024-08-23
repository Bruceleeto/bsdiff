CC = gcc
AR = ar
BIGFILES = -D_FILE_OFFSET_BITS=64

O_BINARY_FLAG = 
WIN32_FLAG = 

# make O_BINARY=1 WIN32=1
ifdef O_BINARY
O_BINARY_FLAG = -DO_BINARY=0
endif

ifdef WIN32
WIN32_FLAG = -D_WIN32
endif

CFLAGS += -DBSDIFF_EXECUTABLE -DBSPATCH_EXECUTABLE $(BIGFILES) -O3 -fdata-sections -ffunction-sections -I. $(O_BINARY_FLAG) $(WIN32_FLAG)
CFLAGS_STRIP = 

BZIP2_OBJS = blocksort.o huffman.o crctable.o randtable.o compress.o decompress.o bzlib.o

ALL: libbz2.a bsdiff bsmodify

libbz2.a: $(BZIP2_OBJS)
	$(AR) rcs $@ $^

bsdiff: bsdiff.o libbz2.a
	$(CC) $(CFLAGS) $^ -o $@ $(CFLAGS_STRIP)

bsmodify: bspatch.o libbz2.a
	$(CC) $(CFLAGS) $^ -o $@ $(CFLAGS_STRIP)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.a bsdiff bsmodify

.PHONY: clean ALL
