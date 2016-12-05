#!/usr/bin/python
#-*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    '''2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
'''
    start = 20
    result = start
    while(start>1):
        start -= 1
        if result % start != 0:
            result *= start // gcd(result,start)
    print(result)   
