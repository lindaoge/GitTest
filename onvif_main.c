#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include "libLog.h"

#include "libOnvifAccess.h"
#include "libCameraAccess.h"

int main(int argc,char ** argv)
{
/*
    Onvif_Start_All();
    while(1) sleep(10);
    return 0;
*/

	int cnt = 0;
	unsigned short port_webserver = 0;
	char dev_name[64] = {0};

	port_webserver = DEFAULT_PORT;
	strcpy(dev_name, DEFAULT_DEVNAME);

    	//CameraDeviceInit(CAMERA_DEV_BS_SD_DOME);
    	CameraDeviceInit(CAMERA_DEV_COMMON);
	for(cnt = 1; cnt < argc; cnt++)
	{
		if(strcasecmp(argv[cnt], "-p") == 0)
		{
			if(cnt+1 < argc)
			{
				int port = atoi(argv[cnt+1]);
				if(port == 0 || port > 65535)
				{
					goto Usage;
				}
				LogTrace("Port = %d\n", port);
				port_webserver = port;
				cnt++;
			}
			else
			{
				goto Usage;
			}

		}
		else if(strcasecmp(argv[cnt], "-i") == 0)
		{
			if(cnt+1 < argc)
			{
				LogTrace("dev = %s\n", argv[cnt+1]);
				strcpy(dev_name, argv[cnt+1]);
				cnt++;
			}
			else
			{
				goto Usage;
			}

		}

	}

	LogTrace("Onvif starting...\n");
	Onvif_Env_Init(port_webserver, dev_name);

	LogTrace("Now, Init config...\n");
	Onvif_Config_Init();


    	LogTrace("Now, starting the webservice thread...\n");
	Onvif_Start_WebService();

	sleep(1);

	LogTrace("Now, starting the probe thread...\n");
	Onvif_Start_Probe();

	sleep(1);
	LogTrace("Now, starting the event thread...\n");
	Onvif_Start_EventService();

	while(1) sleep(100);

Usage:
	LogError("Usage: %s [-p webserver port] [-i net interface like \"eth0\"...]\n", argv[0]);

	return 0;


}
