-- Function: get_doc_url(character varying, character varying, character varying, integer)

-- DROP FUNCTION get_doc_url(character varying, character varying, character varying, integer);

CREATE OR REPLACE FUNCTION get_doc_url(
    devicename character varying,
    site character varying,
    username character varying DEFAULT 'uploader'::character varying,
    port integer DEFAULT 22)
  RETURNS record AS
$BODY$
DECLARE
  cmd varchar;
  err_str varchar;
  out_str varchar;
  res RECORD;
BEGIN
   devicename := quote_ident(devicename);
   cmd := 'php $ARC_PATH/get-doc-url.php -n ' || devicename;
   res := public.exec_paramiko(site, 22, 'uploader', cmd);
   RETURN res;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_doc_url(character varying, character varying, character varying, integer)
  OWNER TO arc_energo;
