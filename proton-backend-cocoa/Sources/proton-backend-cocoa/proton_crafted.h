//
//  Header.h
//  
//
//  Created by Igor Okulist on 5/19/21.
//

#ifndef __PROTON_CRAFTED_HEADER__
#define __PROTON_CRAFTED_HEADER__

#include <stdint.h>

// typedef int (*prtn_fun_ptr)(void  *  _Nonnull  param);
typedef char const * _Nonnull (* _Nonnull prtn_fun_ptr)(void const * _Nonnull, char const * _Nonnull param);

void sayHello(char const * _Nullable namePtr);
int startApp();

void setTitle(char const * _Nullable contentPath);
void setContentPath(char const * _Nullable contentPath);
void addMenuExtra(char const * _Nonnull namePtr);

int64_t bindCallback(char const * _Nonnull namePtr);



int64_t prtn_register_function_callback_with_dispatcher(
    char const * _Nonnull namePtr, 
    char const * _Nonnull (* _Nonnull dispatcher)(void const * _Nonnull, char const * _Nonnull param),
    void * _Nonnull callback
    );


#endif /* __PROTON_CRAFTED_HEADER__ */
