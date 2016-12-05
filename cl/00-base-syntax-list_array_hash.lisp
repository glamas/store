;;list,array,hash

;;构造列表
(cons foo bar)  ;;返回(foo . bar),第二个参数要求是列表
(list foos)  ;;返回foos组成的列表
'(foos)  ;;list的语法糖,即(quote foos)
(make-list num :initial-element foo)  ;;返回个数为num,每个值为foo的列表

;;列表操作
(car list)  ;;返回list的第一个值
(cdr list)  ;;返回list除第一个值的剩余列表
(nth num list)  ;;返回list的第num-1个元素(索引从0开始)
(first list)  ;;返回list的第一元素,类似的有second ... tenth.
;;可以使用setf方式更新list的元素内容

;;相关函数
(list-length list)  ;;返回列表的元素个数
(pop list)
(push list)  ;;两个破坏性函数,pop返回list的第一个值,push添加新值到第一个位置,两种情况下list都改变
(copy-list list)  ;;复制一个list
(listp list)  ;;如果list是一个list,返回T,否则返回nil


;;构造数组
(make-array sizes :initial-element foo)  ;;返回每个值为foo,大小为sizes的数组,sizes可以是二维列表,如'(2 3),即生成一个2 x 3的数组
(vector foos)  ;;返回由foos组成的一位数组,一维向量

;;数组操作
(aref array indexs)  ;;返回array下标为indexs的元素,如(aref arr 0 0)即二维数组的第一个元素
;;可以通过该返回更新对应的元素,同setf
(svref vector index)  ;;返回vector下标为index的元素,可更新值

;;相关函数
(arrayp arr)  ;;如果arr是数组,返回T,否则返回nil
;;注:字符串也是数组,list不是
(vector-push foo vector)  ;;要求vector是可变的,使用make-array带关键词:fill-pointer
(vector-pop vector)


;;构造hash表
(make-hash-table)  ;;返回一个hash表

;;hash表操作
(gethash key hash-table [default])  ;;根据key获取hash表的值,没找到会返回default的值,默认为nil,同时返回第二个参数:找到T,没找到nil.可以配合setf设置值
(remhash key hash-table)  ;;根据key删除hash表的元素
(clrhash hash-table)  ;;清空hash表

;;hash表相关函数
(hash-table-count hash-table)  ;;返回hash表的元素个数