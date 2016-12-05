#!/usr/bin/python
#-*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    '''A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.
'''
    start = 999
    m,n,k = 0,0,0
    result = 0
    while(k<start):
        m,n = 0,k-m
        while(m <= k/2):
            test = (start-m)*(start-n)
            if is_palindromic(test):
                result = test
                break
            m,n = m+1,k-m
        if result != 0:
            break
        k += 1
    print(result)   #906609
