/*
 * tensix operating system project
 * Copyright (C) 2004, 2005 Sven Klose <pixel@copei.de>
 *
 * uIP object driver
 *
 * $License$
 */

#include "types.h"
#include "uipobj.h"

void
uipobj_appcall ()
{
#if 0
   if (uip_aborted ())
       uipobj_remove (UIP_ABORT);

   if (uip_timedout ())
       uipobj_remove (UIP_TIMEOUT);

   if (uip_closed ())
       uipobj_remove (UIP_CLOSED);

   if (uip_connected ())
       uipobj_enanble_send ();

   if (uip_acked())
       uipobj_acked();

   if (uip_newdata())
       uipobj_newdata();

   if (uip_rexmit () || uip_newdata () || uip_acked () || uip_connected () ||
       uip_poll ()) {
       uipobj_senddata();
    }
#endif
}
