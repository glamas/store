#!/usr/bin/python
# -*- coding: UTF-8 -*-

from common_func import *


if __name__ == "__main__":
    """By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10 001st prime number?
"""
    start = 10001
    num = result = 3
    while start >= 2:
        if is_prime(num):
            start -= 1
            result = num
        num += 2
    print(result)
