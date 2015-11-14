#-*- coding: UTF-8 -*-

import io
import sys
#改变标准输出的默认编码 utf8
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='gb18030')

import os
import urllib.request
import lxml.etree as ET
import json
import re
import time



save_dir = os.getcwd()+'/huaban'
info_dir = save_dir+'/info'
if os.path.exists(save_dir) is False:
  os.mkdir(save_dir)
if os.path.exists(info_dir) is False:
  os.mkdir(info_dir)
info_data = '''
pin_id:{pin_id}
raw_text:{raw_text}
user_id:{user_id}
user_name:{user_name}
board_id:{board_id}
board_title:{board_title}
category_id:{category_id}
created_at:{created_at}
orig_source:{orig_source}
img_source:{img_source}
'''

pre_url = 'http://img.hb.aicdn.com/'
opener = urllib.request.build_opener()
opener.addheaders = [('User-agent','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36 SE 2.X MetaSr 1.0')]

max_pin = None
limit = 20
fetch_time = 5

while fetch_time>0:
  fetch_time = fetch_time-1

  try:
    if max_pin is None:
      content = opener.open('http://huaban.com/all/')
    else:
      content = opener.open('http://huaban.com/all/?max={max_pin}&limit={limit}'.format(max_pin=max_pin,limit=limit))
  except urllib.error.HTTPError as err:
    if 404 == err.code:
      break
    else:
      raise

  tree = ET.HTML(content.read())
  images = tree.xpath('//script/text()[contains(string(.),"app.page = app.page")]')

  for data in images:
    for item in re.split(r';\n',data+""):
      key = item.split('=',1)
      if len(key)==2 and 'app.page["pins"]' == key[0].strip().lower():
        for img in json.loads(key[1].strip()):
          img_store_url = pre_url+img['file']['key']+'_fw658'
          # 已保存的图片,跳过
          if os.path.exists(save_dir+"/"+str(img['pin_id'])+".jpg") is True:
            continue
          if max_pin is None or max_pin >= img['pin_id']:
            max_pin = img['pin_id']

          if None != img['orig_source']:
            img_url = img['orig_source']
          else:
            img_url = img_store_url
            
          #停一秒钟请求一次
          time.sleep(0.3)
          try:
              image_data = opener.open(img_url)
          except urllib.error.HTTPError as err1:
              if 404 == err1.code or 503 == err1.code:
                  try:
                      image_data = opener.open(img_store_url)
                  except urllib.error.HTTPError as err2:
                      if 404 == err2.code or 503 == err2.code:
                          continue
                      else:
                          raise
              else:
                  raise
          #保存图片
          f_image = open(save_dir+"/"+str(img['pin_id'])+".jpg","wb")
          f_image.write(image_data.read())
          f_image.close()
          
          #保存图片信息
          f = open(info_dir+"/"+str(img['pin_id'])+".txt","w",encoding='utf-8')
          f.write(
            info_data.format(pin_id=img['pin_id'],
            raw_text=img['raw_text'],
            user_id=img['user_id'],
            user_name=img['user']['username'],
            board_id=img['board_id'],
            board_title=img['board']['title'],
            category_id=img['board']['category_id'],
            created_at=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(img['created_at'])),
            orig_source=img['orig_source'],
            img_source=pre_url+str(img['file']['key'])+"_fw658"
            )
          )
          f.close()
        break
  print(max_pin)


