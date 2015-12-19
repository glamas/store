#-*- coding: UTF-8 -*-

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
    '''By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10 001st prime number?
'''
    start = 10001
    num = result = 3
    while(start >= 2):
        if is_prime(num):
            start -= 1
            result = num
        num += 2
    print(result)
