
#include "../proton-backend-cocoa/Sources/proton-backend-cocoa/proton_crafted.h"

extern "C" {

extern const char * goCallbackDispatcher(const void * _Nonnull, const char * _Nonnull);

prtn_fun_ptr go_callback_proxy_go_type_workaround = goCallbackDispatcher;

}