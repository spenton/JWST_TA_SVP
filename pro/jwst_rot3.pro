function jwst_rot3,ang,in_arcsec=in_arsec,in_degree=in_degree,in_radian=in_radion
	if n_elements(in_radian) ne 1 then in_radian=0
	if n_elements(in_degree) ne 1 then in_degree=0
	if n_elements(in_arcsec) ne 1 then in_arcsec=((in_degree eq 0) and (in_degree eq 0) ? 1 : 0)
	rcs_id="$Id: jwst_rot3.pro,v 1.2 2018/02/27 20:43:40 penton Exp $"
	dang=double(ang)
	ang_degree=(in_degree ? dang : (in_arcsec ? dang/3600. : (dang/!dtor)))
	ang_arcsec=(in_arcsec ? dang : ang_degree*3600.0D )
	ang_radian=(in_radian ? dang : ang_degree * !dtor )

	m1=(-1.0D)
	ca=cos(ang_radian)
	sa=sin(ang_radian)
	r3=[ [ca,m1*sa,0],$
		 [sa,ca,0],$
		 [0,0,1]]

	return,r3
end
