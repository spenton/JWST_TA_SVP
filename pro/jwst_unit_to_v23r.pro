function jwst_unit_to_v23r,uv
	rcs_id="$Id: jwst_unit_to_v23r.pro,v 1.2 2018/03/15 17:38:58 penton Exp $"
	x=uv[0]
	y=uv[1]
	z=uv[2]

	v2=atan(y,x)
	v3=asin(z)

	vr=[v2,v3]

	return,double(vr)
end

