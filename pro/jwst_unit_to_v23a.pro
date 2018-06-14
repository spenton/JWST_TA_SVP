function jwst_unit_to_v23a,uv
	rcs_id="$Id: jwst_unit_to_v23a.pro,v 1.2 2018/03/15 17:38:58 penton Exp $"
	vr=jwst_unit_to_v23r(uv)
	va=(vr/!dtor) * double(3600.0)
	return,va
end
