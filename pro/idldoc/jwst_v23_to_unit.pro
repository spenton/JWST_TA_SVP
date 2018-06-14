function jwst_v23_to_unit,v2a,v3a
	; v2a in arcsec
	; v3a in arcsec

	v2r=(v2a/double(3600.)) *!dtor
	v3r=(v3a/double(3600.)) *!dtor

	x=cos(v2r)*cos(v3r)
	y=sin(v2r)*cos(v3r)
	z=sin(v3r)

	uv=[x,y,z]

	return,uv
end
