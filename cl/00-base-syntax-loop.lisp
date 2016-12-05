;;循环

;(dolist (var list-form)
;  body-form)
;从列表里取出数据,做循环处理
(dolist (x '(1 2 3 4))
  (print x))

;(dotimes (var count-form)
;  body-form)
;设置循环的次数
(dotimes (i 5)
  (print i))

;dolist和dotimes都可以使用return来终止循环

;(do (variable-definition*)
;  (end-test-form result-form*)
;  statement*)
;其中,variable-definition是一个三元素的列表
;  (var init-form step-form) step-form可选,没有的话var的值一直为init-form
;在每次循环开始和变量被更新之后,end-test-form都会被求值,只要其结果为nil,循环就会继续
;当end-test-form结果为真时,result-form被求值并作为do的返回值
(do ((n 0 (1+ n))
     (cur 0 next)
     (next 1 (+ cur next)))
    ((= 10 n) cur))
;计算第11个斐波那契数

;loop宏
(loop for i from 1 to 3 for x = (* i i) do (print x))
;--> 1 4 9
;未完待续

;map宏