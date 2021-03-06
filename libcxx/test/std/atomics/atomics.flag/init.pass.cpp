//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// XFAIL: c++03
// ADDITIONAL_COMPILE_FLAGS: -D_LIBCPP_DISABLE_DEPRECATION_WARNINGS

// <atomic>

// struct atomic_flag

// atomic_flag() = ATOMIC_FLAG_INIT;

#include <atomic>
#include <cassert>

#include "test_macros.h"

int main(int, char**)
{
    std::atomic_flag f = ATOMIC_FLAG_INIT;
    assert(f.test_and_set() == 0);

  return 0;
}
