function jwst_rot2,ang,in_arcsec=in_arsec,in_degree=in_degree,in_radian=in_radion
	rcs_id="$Id: jwst_rot2.pro,v 1.2 2018/03/15 17:38:58 penton Exp penton $"
	if n_elements(in_radian) ne 1 then in_radian=0
	if n_elements(in_degree) ne 1 then in_degree=0
	if n_elements(in_arcsec) ne 1 then in_arcsec=((in_degree eq 0) and (in_degree eq 0) ? 1 : 0)

	dang=double(ang)
	ang_degree=(in_degree ? dang : (in_arcsec ? dang/3600. : (dang/!dtor)))
	ang_arcsec=(in_arcsec ? dang : ang_degree*3600.0D )
	ang_radian=(in_radian ? dang : ang_degree * !dtor )

	m1=(-1.0D)
	ca=cos(ang_radian)
	sa=sin(ang_radian)
	r2=[ [ca,0,sa],$
		 [0,1,0],$
		 [m1*sa,0,ca]]

	return,r2
end
