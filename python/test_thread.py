#!/usr/bin/pyhton
#-*- coding: UTF-8 -*-


#import io
#import sys
#改变标准输出的默认编码 utf8
#sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030')

import queue
import threading
import time


class myThread (threading.Thread):
    '''
    require:
        threadID
        name
        queue       :list parameter for callback function
    option:
        lock        :class threading.Lock() for lock proceding data
    '''
    def __init__(self, threadID, name, queue,lock=None):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.queue = queue
        self.lock = lock
        self.exitFlag = False
    def run(self):
        while not self.exitFlag:
            if self.lock:
                self.lock.acquire()
            if not self.queue.empty():
                item = self.queue.get()
                if self.lock:
                    self.lock.release()
                ## call function
                print("%s processing %s" % (self.name, item))
                time.sleep(1)

            else:
                if self.lock:
                    self.lock.release()
            
    def end(self):
        self.exitFlag = True



if __name__ == "__main__":
    '''
    1.将数据保存到queue
    2.启动线程(传入锁,可选)
    3.主线程活动(处理queue,可选)
    4.对每个线程调用self.end()通知结束线程
    5.对每个线程调用self.join()等待线程结束
    '''
    threadList = ["Thread-1", "Thread-2", "Thread-3"]
    nameList = ["One", "Two", "Three", "Four", "Five"]
    queueLock = threading.Lock()
    workQueue = queue.Queue(10)
    threads = []
    threadID = 1
   
    queueLock.acquire()
    for word in nameList:
        workQueue.put(word)
    queueLock.release() 

    for tName in threadList:
        thread = myThread(threadID, tName, workQueue,queueLock)
        thread.start()
        threads.append(thread)
        threadID += 1


    while not workQueue.empty():
        pass

    for thread in threads:
        thread.end()


    for t in threads:
        t.join()
    print("Exiting Main Thread")
