include ../onvif.param


#INSTALLDIR = $(APP_LIB_DIR)

ONVIF_LIB = libOnvifAccess.a

CFLAGS +=  -I$(ONVIF_HEADER_DIR) -I$(ONVIF_HEADER_DIR)/openssl #-DWITH_FAST

ifeq ($(PLATFORM),TI)
CFLAGS += -DPLATFORM_TI
endif

ifeq ($(PLATFORM),HI)
CFLAGS += -DPLATFORM_HI
endif

ifeq ($(PLATFORM),PC)
CFLAGS += -DPLATFORM_PC
endif

ifeq ($(PLATFORM),AMBA)
CFLAGS += -DPLATFORM_AMBA
endif

ifeq ($(PLATFORM),NXP)
CFLAGS += -DPLATFORM_NXP
endif

CFLAGS += -DWITH_NOIDREF# -DTCP_NODELAY

ifeq ($(ONVIF_AUTH),AUTH_OPENSSL)
CFLAGS += -DAUTH_OPENSSL -DWITH_DOM -DWITH_OPENSSL -I$(ONVIF_HEADER_DIR)/openssl
endif

ifeq ($(ONVIF_AUTH),AUTH_TINY)
CFLAGS += -DAUTH_TINY
endif

ifeq ($(ONVIF_AUTH),AUTH_DISABLE)
CFLAGS += -DAUTH_NO
endif

ifeq ($(CONSOLE_OUT),yes)
CFLAGS += -DCONSOLE_OUT
endif


ONVIF_OBJ = soapC.o soapServer.o stdsoap2.o onvif_server_interface.o \
		duration.o libOnvifAccess.o onvif_server_function.o \
		onvif_common_service.o onvif_event_service.o onvif_file_mng.o utils.o mime.o
		

ifeq ($(ONVIF_AUTH),AUTH_OPENSSL)
ONVIF_OBJ += wsseapi.o smdevp.o threads.o mecevp.o wsaapi.o dom.o
endif

ifeq ($(ONVIF_AUTH),AUTH_TINY)
ONVIF_OBJ += onvif_Auth.o SHA1.o
endif

all:  $(ONVIF_LIB) install

$(ONVIF_LIB): $(ONVIF_OBJ)
	$(AR) $(AR_FLAGS) $(ONVIF_LIB) $(ONVIF_OBJ)

install: $(ONVIF_LIB)
	install -d $(ONVIF_LIB_DIR)
	install -d $(ONVIF_HEADER_DIR)	
	install $(ONVIF_LIB) $(ONVIF_LIB_DIR)
	cp -rf libOnvifAccess.h $(ONVIF_HEADER_DIR)
	#cp -rf libOnvifAccess.h ../../
ifeq ($(PLATFORM),HI)	
	install $(ONVIF_LIB) ../../libs_HI3511
endif
	#chmod 777 -R ../Debug
clean:
	rm -rf *.a *.o $(ONVIF_LIB) $(ONVIF_OBJ)   
	#rm -rf $(ONVIF_HEADER_DIR) $(ONVIF_LIB_DIR) 



