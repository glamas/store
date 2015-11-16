#-*- coding: UTF-8 -*-

import io
import sys
#改变标准输出的默认编码 utf8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030')

import os
import sqlite3

current_dir = os.getcwd()

def init_db():
    conn = sqlite3.connect("test.db")
    c = conn.cursor()
    c.execute("SELECT * FROM sqlite_master WHERE type='table' AND name='image_info' ")
    if c.fetchone() is None:
        c.execute('''CREATE TABLE image_info(pin_id primary key not null,
        row_text text,user_id int,user_name text,board_id int,board_title text,
        category_id int,created_at text,orig_source text,img_source text)''')
        print('has table')
    print("open db ")
    return conn

def close_db(conn):
    conn.close()
    print("close db ")

if __name__ == "__main__":
    conn = init_db()
    c = conn.cursor();
    c.execute("insert into image_info(pin_id,row_text,user_id,user_name,board_id,board_title,category_id,created_at,orig_source,img_source) values(1,'第一张图',1,'glamas',1,'测试',1,'2015-11-16 17:48','http://localhost/a.jpg','http://localhost/a.jpg')")
    c.execute('select * from image_info')
    for row in c:
        print(row)
    close_db(conn)
