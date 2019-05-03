#!/usr/bin/python
# -*- coding: UTF-8 -*-

if __name__ == "__main__":
    '''Power digit sum
215 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.

What is the sum of the digits of the number 21000?
    '''

    p = str(2**1000)
    print(p)
    result = sum([int(x) for x in p])

    print(result)   # 1366