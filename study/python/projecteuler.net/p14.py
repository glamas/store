#!/usr/bin/python
# -*- coding: UTF-8 -*-

if __name__ == "__main__":
    """Longest Collatz sequence
The following iterative sequence is defined for the set of positive integers:

n → n/2 (n is even)
n → 3n + 1 (n is odd)

Using the rule above and starting with 13, we generate the following sequence:

13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.

Which starting number, under one million, produces the longest chain?

NOTE: Once the chain starts the terms are allowed to go above one million.
    """

    collatz_sequence_count_dict = {}
    for n in range(2, 1000000):
        k = n
        count = 1
        while k > 1:
            if k % 2 == 0:
                k = k / 2
            else:
                k = 3 * k + 1
            if k in collatz_sequence_count_dict:
                count = count + collatz_sequence_count_dict[k]
                break
            count += 1

        collatz_sequence_count_dict[n] = count
    # print(collatz_sequence_count_dict)
    max_count = 0
    result = 0
    for k, v in collatz_sequence_count_dict.items():
        if v > max_count:
            max_count = v
            result = k
    print(max_count)
    print(result)   # 837799 (525)
