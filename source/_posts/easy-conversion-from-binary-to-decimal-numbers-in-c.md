---
title: Easy conversion from binary to decimal numbers in C
date: 2013-01-28 02:02:00
tags: c
---

Below, you can see simple and useful code snippet presenting conversion from binary to decimal number in C language without any sophisticated operations using only strtol function.

```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
   const char binary[] = "11001";
   int decimal = strtol(binary, NULL, 2);
   printf("binary = \"%s\", decimal = %d = 0x%02X\n",
          binary, decimal, decimal);
   return 0;
}

/* my output
binary = "11001", decimal = 25 = 0x19
*/
```
