CREATE OR REPLACE FUNCTION public.dl_urllist_pics(arg_urllist text)
 RETURNS boolean
 LANGUAGE plpython2u
AS $function$
#-*- coding:utf-8 -*-
import re
import requests
import logging
from os.path import expanduser
res_site = plpy.execute('select site()')
site = res_site[0]["site"]
proto = 'http://'
home_dir = expanduser("~")
log_dir = home_dir + '/logs/'
log_format = '%(levelname)-7s | %(asctime)-15s | %(message)s'

logger = logging.getLogger("order_photos")
if not len(logger.handlers):
    file_handler = logging.FileHandler(log_dir+'order_photos.log')
    formatter = logging.Formatter(log_format)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.DEBUG)

order_photos_path = plpy.execute("SELECT const_value FROM arc_constants WHERE const_name='order_photos_path';")[0]["const_value"].decode('utf-8')
logger.debug("order_photos_path={0}".format(order_photos_path))
pic_path =  home_dir + '/' + order_photos_path
logger.debug("pic_path={0}".format(pic_path))

for url_elem in arg_urllist.splitlines():
    (dev_name, pic_url) = url_elem.split('^')
    url = site + pic_url
     
    r1=re.compile('/')
    filename = r1.split(pic_url)[-1]
    logger.debug("filename={0}".format(filename))
    pic_filename =  pic_path + filename.decode('utf-8')
    logger.debug("pic_filename={0}".format(pic_filename.encode('utf-8')))
    r = requests.get(proto + url)
    if 200 == r.status_code:
        with open(pic_filename, "wb") as code:
            code.write(r.content)
        plpy.execute("UPDATE ord_arg_devlist SET pic_filename='{0}' WHERE dev_name='{1}';".format(filename, dev_name))

cmd_cmd = '/usr/bin/rsync'
cmd_args = '-rltgoDvv'
cmd_src = pic_path
logger.debug("cmd_src={0}".format(cmd_src.encode('utf-8')))
cmd_tgt = 'root@cifs-public.arc.world:/mnt/r10/ds_cifs/public/' + order_photos_path #.decode('utf-8') #+ '/'
# home_dir on target problem: cmd_tgt = 'order_photo@cifs-public.arc.world:/mnt/r10/ds_cifs/public/' + order_photos_path #.decode('utf-8') #+ '/'
logger.debug("cmd_tgt={0}".format(cmd_tgt.encode('utf-8')))
import subprocess
try:
    rc = subprocess.call([cmd_cmd, cmd_args, cmd_src, cmd_tgt])
except OSError as e:
   logger.error("Execution failed. exception={0}".format(e))

logger.info("rsync rc={0}".format(rc) )

return True if 0 == rc else False
$function$
;

