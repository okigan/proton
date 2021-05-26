
#include "../proton-backend-cocoa/Sources/proton-backend-cocoa/proton_crafted.h"

extern "C" {

// extern int go_callback_dispatcher(void *v);
extern const char * go_callback_dispatcher(const void * _Nonnull, const char * _Nonnull);

prtn_fun_ptr go_callback_proxy_go_type_workaround = go_callback_dispatcher;

}