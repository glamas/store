;;条件判断
;;这部分的代码来自http://acl.readthedocs.io/en/latest/zhCN/ch5-cn.html

;;区块(block)有三个操作符: progn, block, tagbody
;progn运行多个表达式,并返回最后一个表达式的值
(progn
  (format t "a")
  (format t "b")
  (+ 11 12))

;block的第一个参数是符号,通过return-from该符号来结束这个区块,return-from的第二个参数作为返回值,并且,之后的表达式将不会运行
(block head
  (format t "Here we go.")
  (return-from head 'idea)
  (format t "We'll never see this."))   ;;该表达式将不会运行,区块返回IDEA

;return宏,把传入的参数当作封闭区块nil的返回值.可理解为每个不是显式区块都是一个符号为nil的区块
(dolist (x '(a b c d e))
  (format t "~A " x)
  (if (eql x 'c)
    (return 'done)))

;tagbody, 出现在区块的原子(atom,即单独元素?)被视为tag,通过配合go表达式来进行代码运行的跳转
(tagbody
  (setf x 0)
  top
    (setf x (+ x 1))
    (format t "~A " x)
    (if (< x 10) (go top)))
;大多数迭代操作符都隐含在一个tagbody

;;条件判断
;if:
; (if condition then-form [else-form])
;注意,当then字句多于一条表达式的时候,需要使用progn区块来包裹,不然第二条表达式将会认为是else字句
;另,如果需要运行else字句但else字句没有提供的话,返回nil
(if (> 2 3) "yes" "no")

;when宏
; (when condition 
;   statements)
;这个宏可以避免使用progn来显式区块,单仅用于不需要else字句的情况

;unless宏
;这个宏的用法和when类似,不过仅在条件为假(取反)的时候运行

;多重条件分支的宏cond
; (cond
;   (condition1 form*)
;   ...
;   (conditionN form*))
;可以对多个条件判断,按顺序如果某个条件成立,即运行该条件对于的表达式语句(可以多条),剩余的条件将不会进行判断.当condition为t的时候,运行到该部分的判断必然运行,这个可以作为多重条件的最后判断(技巧).