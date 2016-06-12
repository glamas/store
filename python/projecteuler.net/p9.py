#!/usr/bin/python
#-*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    '''A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,

a2 + b2 = c2
For example, 32 + 42 = 9 + 16 = 25 = 52.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.'''

    flag = 0
    a,b,c = 0,0,0
    for c in range(1000,0,-1):
        for b in range(c-1,c//2,-1):
            a = 1000 - c - b
            if a < 0:
                break
            if a*a + b*b == c*c:
                print a*a,b*b,c*c
                flag = 1
                break
        if flag == 1:
            break
    print a,b,c
    print a*b*c
