s;;输入输出和文件操作
;;参考:http://www.yiibai.com/lisp/lisp_input_output.html

;print,prin1,princ,pprint
;(print foo [stream])
;打印变量到stream,默认是标准输出.
;三者都将foo作为返回值(在top-level输出两次)
;区别:
;    print 会先打印一个换行符,其他两个不会
;    prin1 给程序产生输出
;    princ 给人类产生输出,prin1会给字符串加上双引号,princ不会
(print '(1 2 3))

;princ-to-string,prin1-to-sting
;(princ-to-string foo)
;将变量输出为字符串

;print-object
;(print-object object stream)
;打印对象到stream

;terpri,fresh-line
;(terpri [stream])
;输出空行,
;terpri返回nil
;如果不是在一行开始,fresh-line返回T,否则nil
(terpri)


;format宏
;(format [T | NIL | out-string | out-stream] control arg*)
;如果第一个参数是T,输出到标准输出,并且返回nil
;如果第一个参数是nil,返回格式化之后的字符串

;指令都以一个波浪线(~)开始并以单个字符终止
;前置参数:最多4个
;  数字类型:紧跟波浪线,并带有逗号(,)分割 e.g.(format nil "~,,'.,4d" 100000000) -> 1.0000.0000
;  字符类型:(v)消耗掉arg*的一个参数,并作为前置参数,格式化之后一个参数
;           (#)将剩余待格式化的参数的数量做为前置参数
;(format nil "~v$" 3 pi) -> 3.142

;修饰符:冒号和@,根据不同的指令有不同的效果

;基本格式化指令:(大小写不论)
;  ~a -> 将任何类型的参数格式化输出为易读形式
;  ~s -> 生成可被READ读回来的形式,如字符串被包围在引用标记中，而符号必要的时候是包限定的,对不带有可读表示的对象打印成不可读对象语法#<>,使用一个 : 修饰符可以将NIL输出为 ()
;  ~% -> 换行
;  ~& -> 如果在一行的开始处,生成一个换行.和~%一样可以带一个前置参数,用来确定生成换行的数量
;  ~~ -> 产生一个波浪线
;  ~^ -> 参考"迭代",没有剩余参数时忽略后面的格式化指令
;  ~* -> 跳跃(忽略或重用)参数

;字符:
;  ~c -> 不接受前置参数,仅接受修饰符,用来输出单个字符 (format nil "~c" (code-char 0)) -> "^@"
;  ~:c -> 可以将如空格等不可打印的字符按名字输出 (format nil "~:c" (code-char 0)) -> "Nul"
;  ~@c -> 可以将字符按照Lisp的字符语法输出字符 (format nil "~@c" (code-char 0)) -> "#\\Nul"
;  ~:@c -> 可以将字符要求特殊的按键组合的方式打印出来 (format nil "~:@c" (code-char 0)) -> "Nul"

;整数:
;  ~d -> 按十进制输出
;  ~x -> 按十六进制输出
;  ~o -> 按八进制输出
;  ~b -> 按二进制输出
;  ~r -> 通用进制输出指令,第一个参数介于2到36之间
;修饰符:
;  ~:d -> 以逗号分割三位数显示
;  ~@d -> 正数前加+号
;  ~:@d -> 两者组合
;前置参数:最多4个
;  第一个: 设置最小宽度
;  第二个: 设置占位字符,默认为空格
;  第三个: 指定分割字符,默认为逗号
;  第四个: 指定分割数位,默认为3

;浮点数:
;  ~f -> 十进制输出
;  ~e -> 科学计数法输出
;  ~g -> 通用浮点形式
;  ~$ -> 相当于~,2F,保留两位小数
;修饰符:
;  同整数
;前置参数:最多2个
;  第一个: 小数点前保留几位
;  第二个: 小数点后保留几位

;英语指令:
;  ~r -> 当没有指定进制时,将数字输出为英语单词或者罗马数字
;        当不带前置参数或修饰符时,将数字输出为基数词
;        冒号修饰符,将数字输出成序数 (format nil "~:r" 20) -> twentieth
;        @修饰符,将数字输出为罗马数字
;        同时使用:和@,输出为旧式的罗马数字,4为IIII,而不是IV
;  ~p -> 对复数化单词,如果参数不是1,会简单输出一个s,(0也会输出s)
;        使用冒号,会重新处理前一个格式化参数,(根据前一个参数做处理)
;        使用:和@,输出y或者ies (format nil "~r famil~:@p" 10) -> "ten families"
;  ~(和~) -> 组合使用,用来控制包围的里面单词的大小写
;        使用冒号,所有单词首字母大写
;        使用@,仅第一个单词的首字母大写
;        使用:和@,所有字母大写 (format nil "~:@(~a~)" "tHe Quick BROWN foX") ==> "THE QUICK BROWN FOX"

;条件格式化:
;  ~[和~] ->组合使用,中间由:;分割子句;该指令会根据修饰符和前置参数来选择字句,然后格式化参数
;        不带修饰符(:和@)时,字句根据参数做索引进行选择:该参数应该是一个数字;索引从0开始;如果超出字句个数,除非最后一个字句使用~:;分割(此时返回最后一个字句)否则返回空nil
;        前置参数#比较常用在此处,能够根据剩余参数数量来进行格式化
;        @修饰符,允许只有一个字句,仅当参数不为空(nil)的时候进行格式化
;        :修饰符,只含有两个字句,当参数为空的时候,选择第一个字句,否则选择第二个字句
;注:如果字句为空,也需要保留一个:;作为分割
(format nil "~#[NONE~;~a~;~a and ~a~:;~a, ~a~]~#[~; and ~a ~:;, ~a, etc~]." 'b 'c 'd 'e)

;迭代指令:
;  ~{和~} -> 组合使用,参数为列表,或者元素(和@修饰符联合使用)
;        @修饰符,将剩余的参数作为列表来对待 
;        如果里面有带#前置参数的~[和~],剩余参数个数按list来计算,而不是整个传入参数的个数
;        ~^ -> 该指令在后面没有剩余参数的时候生效,可以使迭代立即结束而不处理剩余的格式化指令
;        :修饰符 (?)
(format nil "~@{~a~^, ~}" 1 2 3) ; ==> "1, 2, 3"
(format nil "~{~a~#[~;, and ~:;, ~]~}" (list 1 2 3)) ; ==> "1, 2, and 3"
(format nil "~{~#[~;~a~;~a and ~a~:;~@{~a~#[~;, and ~:;, ~]~}~]~}" '(1 2 3 4)) ; ==> "1, 2, 3, and 4"

;参数跳跃(重用):
;  ~* -> 不使用修饰符,直接跳过下一个参数(略过一个参数)
;        :修饰符,向前移动一个参数(重用前面的参数)
;        @修饰符,重用参数,按参数的绝对值索引,默认为0(第一个)
;        默认跳跃参数是1,常结合~[或~{来一起使用
(format nil "~{~s~*~^ ~}" '(:a 10 :b 20)) ; ==> ":A :B"


;io 交互
;(y-or-n-p [control arg*]) 或者
;(yes-or-no-p [control arg*]) 其中的[control arg*]可选,类似于format的格式化输出.用来提示
(y-or-n-p "Another? [y/n]: ")

;(read [stream | *standard-input*] [eof-err [eof-val [recursive-p]]])
;read,read-char,read-line 三个类似.stream通常来自文件或其他流.
;eof-err默认为T,表示遇到end of file报错,当eof-err为nil时,遇到eof时返回eof-val
;recursive-p 参考226文档,默认为nil
(with-input-from-string (is "0123")
			(do ((c (read-char is) (read-char is nil 'the-end)))
			    ((not (characterp c)))
			    (format t "~S " c))) ;-> #\0 #\1 #\2 #\3
;技巧:标准输入时不需要后面的参数;标准输入时最好给于足够的文字信息提示,这三个方法会停住等待输入,会误以为程序卡住

;(read-byte [stream] [eof-err [eof-val]])
;用来读取二进制数据

;(read-from-string string [eof-err [eof-val]] :start 0 :end nil :preserve-whitespace nil)
;用于从字符串读取,带有3个关键字参数,start是开始索引,从0开始,end是结束索引

;(write-char char [stream | *standard-output*])
;输出char到stream

;(write-string string [stream | *standard-output*] :start 0 :end nil)
;write-string 和write-line 作用相同,都是将string输出到stream,前者不输出换行,后者输出换行

;(write-byte byte stream)
;输出二进制到stream

;write和write-to-string
;(write foo :stream stream | *standard-output* ) 
;还有很多关键词参数,具体参考手册,例如 :length int|nil ,:lines int|nil

;文件操作
;(open path :direction [:input |:output |:io |:probe] 
;           :element-type [type |default] 
;           :if-exists [:new-version |:error |:rename |:rename-and-delete |:overwrite |:append |:supersede | nil]
;           :if-does-not-exist [:error |:create | nil]
;           :external-format format)
;打开path对应的文件,返回stream.其中
;  :direction 默认:input
;  :element-type 默认character
;  :if-exists 默认:new-version
;  :if-does-not-exists 如果:direction :probe 默认为nil,其他为[:create |:error]
;对于:probe,仅测试文件是否存在
;对于:direction是:input或:probe,:if-exists参数无效.
;对:if-exists和:if-does-not-exist,nil不返回文件流,仅返回nil表示错误
;对:if-exists,:rename-and-delete会重命名文件并删除? :supersede表示替换

;(close stream [:abort nil])
;关闭文件流,如果stream已经被打开,返回T;如果:abort设置为T,关闭的同时删除文件)

;注:open需要搭配close使用,为避免没有close,建议使用with-open-file
;(with-open-file (stream path open-arg*) (declare decl) form*)
;作为临时文件打开path,文件流名称为stream,open-arg*对应(open)的关键字参数,后面可以执行多个语句,最后返回form*的值

;路径和文件名
;(make-pathname :host {host |nil |:unspecific}
;               :device {device |nil |:unspecific}
;               :directory {directory |:wild |nil |:unspecific} {:absolute |:relative}{directory |:wild |:wild-inferiors |:up |:back}
;               :name {filename |:wild |nil |:unspecific}
;               :type {file-type |:wild |nil |:unspecific}
;               :version {:newest |version |nil |:unspecific}
;               :defaults path 
;               :case {:local |:common}

