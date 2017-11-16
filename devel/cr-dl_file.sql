-- drop function dl_file(text, text);
CREATE OR REPLACE FUNCTION dl_file(
    arg_url text,
    arg_filename text)
RETURNS boolean AS
$BODY$
import requests
r = requests.get(arg_url)
if 200 == r.status_code:
    res = True
    with open(arg_filename, "wb") as code:
        code.write(r.content)
    #print "Download Complete!"
else:
    res = False

return res
$BODY$
  LANGUAGE plpython2u VOLATILE
  COST 100;
