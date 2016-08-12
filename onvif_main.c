#include <stdio.h>

#include "libOnvifAccess.h"

int main(int argc,char ** argv)
{
	printf("%s %d: Common_Init!\n");
	printf("Onvif starting...\n");

	printf("Now, starting the probe thread...\n");
	Onvif_Start_Probe();

	printf("Now, starting the webservice thread...\n");
	Onvif_Start_WebService();	


	while(1);
	return 0;


}
