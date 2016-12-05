#!/usr/bin/python
#-*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    '''If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.
'''
    print(sum_n_bellow_m(3,1000)+sum_n_bellow_m(5,1000)-sum_n_bellow_m(15,1000))
