CROSS=mips-linux-
#CROSS=mips-linux-
#all: gsm0710muxd
#gsm0710muxd: gsm0710muxd.c
#gcc -o gsm0710muxd gsm0710muxd.c

#clean:
#    @rm -vf gsm0710muxd *.o *~

#CROSS=arm-linux-

all: gsm0710muxd

gsm0710muxd: gsm0710muxd.c
$(CROSS)gcc -o gsm0710muxd gsm0710muxd.c -lpthread

#$(CROSS)gcc -Wall -O3 -o armgsm0710muxd gsm0710muxd.c -lpthread
#$(CROSS)gcc -o gsm0710muxd gsm0710muxd.c -lpthread
#	gcc -o gsm0710muxd gsm0710muxd.c -lpthread

clean:
	@rm -vf gsm0710muxd *.o *~
