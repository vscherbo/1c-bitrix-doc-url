CREATE OR REPLACE FUNCTION get_devlist_pic_url(
    username character varying DEFAULT 'uploader'::character varying,
    port integer DEFAULT 22)
  RETURNS record AS
$BODY$
DECLARE
  cmd varchar;
  v_dev_list text;
  err_str varchar;
  out_str varchar;
  res RECORD;
BEGIN
   SELECT string_agg(dev_name, '^') INTO v_dev_list FROM ord_arg_devlist; 
   v_dev_list := quote_ident(v_dev_list);
   cmd := 'php $ARC_PATH/get-pic-urls.php -l ' || v_dev_list;
   res := public.exec_paramiko(site(), port, username, cmd);
   RETURN res;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
