;;注释使用逗号

;;快速手册:http://clqr.boundp.org/download.html

;;定义变量
(defvar foo form)  ;;将 value of form 赋值给 foo

;;定义常量
(defconstant foo form)

;;定义全局变量
(defparameter *foo* form)  ;;全局变量一般用星号包住

;;局部变量
(let ((x 2) (y 3))
  (print (+ x y)))
(let (foo value)
  form*)   ;;将value的值赋与foo,最终返回form*的值
(multiple-value-bind (paras) value-form body-form)  ;;将value-form的值分别赋予paras,返回body-form的值

;;注:
;;    defvar,defconstant,defparameter都是全局变量
;;    并且,defvar和defconstant仅在foo没定义的时候生效,重复定义无效

;;设置变量
(setf foo form)  ;;设置foo的新值,返回form的值
(setq symbol form)  ;;设置符号sysbol的新值

;;注:
;;    仅在已被定义的变量生效

;;定义函数
(defun foo (para)
  (fun-block))  ;;返回fun-block的值

(lambda (para) (fun-block)) ;;匿名函数
