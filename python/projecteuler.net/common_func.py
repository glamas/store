#!/usr/bin/python
# -*- coding: UTF-8 -*-

from math import sqrt, floor

# 判断素数
def is_prime(num):
    """https://zh.wikipedia.org/wiki/%E7%B4%A0%E6%80%A7%E6%B5%8B%E8%AF%95"""
    if num <= 1:
        return 0
    if num == 2:
        return 1
    if num % 2 == 0:
        return 0
    iNum = 3
    while iNum * iNum <= num:
        if num % iNum == 0:
            return 0
        iNum += 2
    return 1


# 计算小于m并且能被n整除的所有数字只和
def sum_n_bellow_m(n, m):
    return (n / 2) * ((m - 1) // n) * ((m - 1) // n + 1)


# 奇数的febonacci数之和
def sum_even_febonacci(max):
    a, b = 1, 2
    sum = b
    while b < max:
        a, b = b, a + b
        if b % 2 == 0:
            sum += b
    return sum


# 判断回文数
def is_palindromic(num):
    strNum = str(num)
    strRvsNum = strNum[::-1]
    if strNum == strRvsNum:
        return 1
    return 0


# 最大公约数
def gcd(m, n):
    if m < n:
        m, n = n, m
    if m % n == 0:
        return n
    else:
        return gcd(n, m % n)


# 求平方和
def sum_square(n):
    """formular:
    Ek^2 = n*(n+1)*(2*n+1)//6
"""
    return n * (n + 1) * (2 * n + 1) // 6


# 求整数和
def sum_num(n):
    """formular:
    Ek = n*(n+1)//2
"""
    return n * (n + 1) // 2


# 是否平方数
def is_squares(num):
    """ for python2.x division need be float
    2分法快速找到最接近num的平方数,
    然后使用逼近法得到最近的平方数,由num=(a+b)^2 =a^2+2ab+b^2,舍弃b^2项,可以得到b=(num-a^2)/(2*a),
    如果|b|>1,将a修正为a+b,带入刚才的算式,直到|b|<1,
    在判断a^2,(a+b)^2和num的大小
    """
    i = 2
    while num <= (num // i) * (num // i):
        i = i * 2
    m = int(num // i)
    k = (num - m * m) / 2.0 / m
    while k >= 1.0 or k <= -1.0:
        m = int(m + k)
        k = (num - m * m) / 2.0 / m
    if num == m * m:
        return True
    else:
        return False


# 统计num的因子个数
def count_divisor(num):
    start = 1
    count = 0
    while start <= num // start:
        if num % start == 0:
            if start == num // start:
                count += 1
            else:
                count += 2
        start += 1
    return count

# 阶乘
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)