#-*- coding: UTF-8 -*-

from math import sqrt,floor

def is_prime(num):
    '''https://zh.wikipedia.org/wiki/%E7%B4%A0%E6%80%A7%E6%B5%8B%E8%AF%95
'''
    if num<=1:
        return 0
    if num == 2:
        return 1
    if num % 2 ==0:
        return 0
    iNum = 3
    while(iNum * iNum <= num):
        if num % iNum == 0:
            return 0
        iNum += 2
    return 1

if __name__ == "__main__":
    '''The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?
'''
    value = 600851475143
    i = floor(sqrt(value))
    # if not use math
    # i = value // 2
    if i % 2 == 0:
        i=i+1
    result = 0
    print(i*i)
    print(i)
    while(i>=2):
        if value % i == 0:
            if is_prime(i):
                result = i
                break
        i -= 2
    print(result)
