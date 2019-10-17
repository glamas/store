#!/usr/bin/python
# -*- coding: UTF-8 -*-

if __name__ == "__main__":
    """
If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?

NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.
    """

    # num1 = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    num_1 = [0, 3, 3, 5, 4, 4, 3, 5, 5, 4]
    # num2 = ["","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"]
    num_2 = [0, 6, 6, 8, 8, 7, 7, 9, 8, 8]
    # num3 = ["","ten","twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"]
    num_3 = [0, 3, 6, 6, 5, 5, 5, 7, 6, 6]

    ans = 0
    for i in range(1, 1001):
        temp = str(i)[::-1]
        bit = len(temp)
        if bit == 1:
            ans += num_1[int(temp[0])]
        else:
            teen = False
            for b in range(bit):
                if teen:
                    teen = False
                    continue
                if b % 4 == 0 and temp[b] == "0":
                    continue
                elif b % 4 == 0 and temp[b+1] != "1":
                    ans += num_1[int(temp[b])]
                elif b % 4 == 0 and temp[b+1] == "1":
                    teen = True
                    ans += num_2[int(temp[b])]
                    continue
                elif b % 4 == 1 and temp[b] != "0":
                    ans += num_3[int(temp[1])]
                elif b % 4 == 2 and temp[b] != "0":
                    ans += num_1[int(temp[b])]
                    ans += len("hundred")
                    if temp[b-1] != "0" or temp[b-2] !="0":
                        ans += len("and")
                elif b % 4 == 3 and temp[b] != "0":
                    ans += num_1[int(temp[b])]
                    ans += len("thousand")
                    if temp[b-1] == "0" and (temp[b-2] !="0" or temp[b-3] !="0"):
                        ans += len("and")
        # print(i,temp,ans)

    # print("="*30)
    print(ans)
