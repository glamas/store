#!/usr/bin/python
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

def sum_n_bellow_m(n,m):
    return (n/2)*((m-1)//n)*((m-1)//n+1)

def sum_even_febonacci(max):
    a,b = 1,2
    sum = b
    while(b<max):
        a,b = b,a+b
        if b%2 == 0:
            sum+=b
    return sum

def is_palindromic(num):
    strNum = str(num)
    strRvsNum = strNum[::-1]
    if strNum == strRvsNum:
        return 1
    return 0

def gcd(m,n):
    if m < n:
        m,n = n,m
    if m % n == 0:
        return n
    else:
        return gcd(n,m%n)

def sum_square(n):
    '''formular:
    Ek^2 = n*(n+1)*(2*n+1)//6
'''
    return n*(n+1)*(2*n+1)//6

def sum_num(n):
    '''formular:
    Ek = n*(n+1)//2
'''
    return n*(n+1)//2
