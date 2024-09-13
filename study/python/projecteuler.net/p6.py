#!/usr/bin/python
# -*- coding: UTF-8 -*-

from common_func import *

if __name__ == "__main__":
    """The sum of the squares of the first ten natural numbers is,

12 + 22 + ... + 102 = 385
The square of the sum of the first ten natural numbers is,

(1 + 2 + ... + 10)2 = 552 = 3025
Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025 − 385 = 2640.

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
"""
    start = 100
    result = sum_num(start)
    result *= result
    result = result - sum_square(start)

    print(result)
