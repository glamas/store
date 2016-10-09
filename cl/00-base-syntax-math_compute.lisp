;;math_compute 数学操作

;;四则运算
(+ 2 3)
(- 4 3)
(* 3 4)
(/ 3 4)

;;增量
(1+ 3)
(1- 4)
(incf foo delta)
(decf foo delta)  ;;返回并设置foo为减去delta之后的值

;;e指数
(exp p)  ;;返回e^p的值
(expt b p)  ;;返回b^p的值

;;对数
(log a [b])  ;;b或e为底a的对数

;;pi
pi

;;三角函数
(sin a)  ;;a为弧度
(cos a)
(tan a)
(asin a)
(acos a)
(atan a)
(sinh a)
(cosh a)
(tanh a)
(asinh a)
(acosh a)
(atanh a)

;;比较函数
(max num+)  ;;返回多个数字的最大值
(min num+)  ;;返回多个数字的最小值

;;四舍五入
(round n [d])  ;;返回n除以d后四舍五入的值,以及该值乘以d和n的差值,如:(round 11 3)->(4 -1)
(fround n [d]) ;;和round类似,返回第一个值是浮点数
(floor/ffloor n [d])
(ceiling/fceiling n [d])
(truncate/ftruncate n [d])

;;取模
(mod n d)
(rem n d)  ;;类似floor和truncate,仅返回第二部分

;;随机数
(random limit)  ;;返回一个小于limit的正数,类型和limit相同

;;分数
(numerator num)  ;;返回分数的分子部分
(denominator num)  ;;返回分数的分母部分
