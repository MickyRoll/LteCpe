#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> 
#include <pthread.h>
#include <fcntl.h>
#include <string.h>
#include <getopt.h>
#include <termios.h>
#include <errno.h>
#include <stdarg.h>

int setport(int fd)
{
	int baudrate;
	struct   termios   newtio;   
	
	tcgetattr(fd,&newtio);     
	bzero(&newtio,sizeof(newtio));   
	newtio.c_cflag   &=~CSIZE;     
  	newtio.c_cflag |= CS8; 
	newtio.c_cflag &= ~PARENB;   
	newtio.c_iflag &= ~INPCK;  
	newtio.c_cflag &= ~CSTOPB;  		
	newtio.c_cc[VTIME] = 0;    
	newtio.c_cc[VMIN] = 0; 
	newtio.c_cflag   |=   (CLOCAL|CREAD);
	newtio.c_oflag|=OPOST; 
	newtio.c_iflag   &=~(IXON|IXOFF|IXANY);                     
    cfsetispeed(&newtio,B115200);   
    cfsetospeed(&newtio,B115200);   

    tcflush(fd, TCIOFLUSH);
	if (tcsetattr(fd,TCSANOW,&newtio) != 0)   
	{ 
		perror("SetupSerial Error\n");  
		close(fd);
		return -1;  
	}  
	return 0;
}

int readport(int fd,char *buf,int len,int maxwaittime)
{
	int no=0;int rc;int rcnum=len;
	struct timeval tv;
	fd_set readfd;
	tv.tv_sec=maxwaittime/1000;    
	tv.tv_usec=maxwaittime%1000*1000;  
	FD_ZERO(&readfd);
	FD_SET(fd,&readfd);
	rc=select(fd+1,&readfd,NULL,NULL,&tv);
	if(rc>0)
	{
		rc = read(fd, buf, len-1);
		buf[len-1] = 0;
		return rc;      
	}
	else
	{
		memcpy(buf,"\nERROR\r\n",strlen("\nERROR\r\n"));
	}
	return -1;
}

int openport(const char *Dev)   
{
	int fd = open( Dev, O_RDWR|O_NOCTTY|O_NDELAY|O_NONBLOCK); 
	if (-1 == fd) 
	{
		return -1;  
	} 
	else 
		return fd;
}

int	 main(int argc, char *argv[])
{
	char cmd[128];
	char rsp[128];
	int i;
	int	iread;
	int fdd; 

	system("cat /etc/cm.pid | xargs kill -SIGUSR2");
	sleep(5);

	fdd = openport("/var/dev/mux3");
	if(fdd <= 0)
	{
		printf("device is not exists\n");
		exit(2);
	}
	if(setport(fdd)<0)
	{
		printf("set error!\n");
		exit(2);
	}
	printf("3G serialport open successful!\r\n");
	while(1)
	{
		memset(cmd,0, 128);
		memset(rsp,0, 128);
		scanf("%s",cmd); 
		
		for(i = 0; i < strlen(cmd); i++)
		{
			write(fdd, cmd+i, 1);
			usleep(50000);
		}
		write(fdd, "\r\0", 1);
		usleep(200000);

		iread = 0;
		iread = readport(fdd, rsp, 128, 15000);
		printf("%s",rsp);
	}
	
	close(fdd);
}
