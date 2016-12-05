#!/usr/bin/python
#-*- coding: UTF-8 -*-

import io
import sys
#改变标准输出的默认编码 utf8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030')

import os
import urllib.request
import lxml.etree as ET
import re
from datetime import date


def init_urlopener():
    opener = urllib.request.build_opener()
    opener.addheaders = [('User-agent','Mozilla/5.0 (Windows NT 6.1)'),('Cookie','country=cn')]
    return opener

def get_html(opener,url,alert=False):
    try:
        content = opener.open(url)
        return content
    except urllib.error.HTTPError as err:
        if alert==True:
            raise
        elif 404 == err.code or 503 == err.code:
            return False
        else:
            raise

def save_html(stream,filename,path='.'):
    with open(path+'/'+filename,'w',encoding='utf8') as f:
        f.write(stream.decode('utf8'))

if __name__ ==  "__main__":
    save_dir = os.getcwd()+'/bing'
    info_dir = save_dir+'/info'
    if os.path.exists(save_dir) is False:
      os.mkdir(save_dir)
    if os.path.exists(info_dir) is False:
      os.mkdir(info_dir)

    info_data = '''
title:{title}
filename:{filename}.jpg
date:{date}
country:{country}
short_desc:{short_desc}
'''

    opener = init_urlopener()

    base_url = "http://www.istartedsomething.com/bingimages"
    month,year = date.today().month,date.today().year
    url = base_url+"/?m={month}&y={year}".format(month=month,year=year)
    html = get_html(opener,url,True)
    #save_html(html.read(),'content.html',save_dir)
    #html = open(save_dir+'/content.html','r',encoding='utf8')
    tree = ET.HTML(html.read())
    images = tree.xpath("//table//a[@class='cn']")
    for data in images:
        info_href,info_title,info_class = data.attrib['href'][1:],data.attrib['title'],data.attrib['class']
        data_original = data.find('img').attrib['data-original']
        patterm = re.compile(r"(.*?)i=(.*)_(.*)_(\d+)x(\d+)(.*?)w=(\d+)")
        m = re.match(patterm,data_original)
        short_desc = m.group(2)
        image_url = base_url+'/'+m.group(1)+'i='+m.group(2)+'_'+m.group(3)+'_'+m.group(4)+'x'+m.group(5)+m.group(6)+'w='+m.group(4)
        print(image_url)

        #保存图片
        if os.path.exists(save_dir+"/"+info_href+".jpg") is True:
            continue
        image_data = get_html(opener,image_url,True)
        with open(save_dir+"/"+info_href+".jpg","wb") as f:
            f.write(image_data.read())

        #保存图片信息
        with open(info_dir+"/"+info_href+".txt","w",encoding="utf8") as f:
            f.write(info_data.format(title=info_title,filename=info_href,date=info_href,country=info_class,short_desc=short_desc))

