/*
 * tensix operating system project
 * Copyright (C) 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * uIP object driver
 *
 * $License$
 */

#ifndef __UIPOBJ_H__
#define __UIPOBJ_H__

void uipobj_init(void);
void uipobj_appcall(void);

/* UIP_APPCALL: the name of the application function. This function
   must return void and take no arguments (i.e., C type "void
   appfunc(void)"). */
#ifndef UIP_APPCALL
#define UIP_APPCALL     uipobj_appcall
#endif

struct uipobj_state {
  u8_t state; 
  u16_t count;
  char *dataptr;
  char *script;
};


/* UIP_APPSTATE_SIZE: The size of the application-specific state
   stored in the uip_conn structure. */
#ifndef UIP_APPSTATE_SIZE
#define UIP_APPSTATE_SIZE (sizeof(struct uipobj_state))
#endif

#define FS_STATISTICS 1

extern struct uipobj_state *hs;

#endif /* __UIPOBJ_H__ */
