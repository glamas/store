#!/usr/bin/python
# -*- coding: UTF-8 -*-

import math

if __name__ == "__main__":
    '''Lattice paths
Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there are exactly 6 routes to the bottom right corner.


How many such routes are there through a 20×20 grid?'''

    '''
    method 1:
    import math

    method 2:
    from functools import reduce
    def factorial(n):
        return reduce(lambda x,y:x*y,[1]+range(1,n+1))

    method 3
    def factorial(n):
        if n == 0:
            return 1
        else:
            return n * factorial(n - 1)
    '''

    result = math.factorial(40) / math.factorial(20) / math.factorial(20)
    print(result)   # 137846528820