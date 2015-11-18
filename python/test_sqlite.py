#-*- coding: UTF-8 -*-

import io
import sys
#改变标准输出的默认编码 utf8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030')

import os
import sqlite3

current_dir = os.getcwd()

def init_db():
    try:
        conn = sqlite3.connect("test.db")
        c = conn.cursor()
        c.execute("SELECT * FROM sqlite_master WHERE type='table' AND name='image_info' ")
        if c.fetchone() is None:
            c.execute('''CREATE TABLE image_info(pin_id primary key not null,
            row_text text,user_id int,user_name text,board_id int,board_title text,
            category_id int,created_at text,orig_source text,img_source text)''')
            print('created table success...')
        print("open db sucess...")
        return (conn,c)
    except sqlite3.Error as e:
        print("[Error]:",e.args[0])

def close_db(conn):
    conn.close()
    print("close db success...")

if __name__ == "__main__":
    conn,cur = init_db()
    cur.execute('select * from image_info')
    for row in cur:
        print(row)
    close_db(conn)
