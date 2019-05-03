#!/usr/bin/python
#-*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    '''The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

    Find the sum of all the primes below two million.
'''
    result = 2
    m = 3
    while m < 2000000:
        if is_prime(m):
            result += m
        m +=2
    print(result)
