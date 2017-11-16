drop function dl_devlist_pics();

create or replace function dl_devlist_pics()
returns boolean as
$$
declare
v_rec record;
v_dl_res boolean;
BEGIN
	v_rec := get_devlist_pic_url();
	IF v_rec.err_str = '' then 
        -- RAISE NOTICE 'out_str=%', v_rec.out_str;
        v_dl_res := dl_urllist_pics(v_rec.out_str);
    ELSE 
        v_dl_res := False;
        RAISE 'ERROR %', v_rec.err_str;
    END IF;
    return v_dl_res;
END;$$
language plpgsql;
