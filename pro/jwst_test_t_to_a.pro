pro jwst_test_t_to_a,si=si,verbose=verbose
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(si) ne 1 then si='NIRISS'
	rcs_id="$Id: jwst_test_t_to_a.pro,v 1.1 2018/02/27 20:43:40 penton Exp $"
	visit_sidata=[$
		[-351.566018,-685.258708,0.497037285,-1.03568517,-351.046558,-686.283309],$
		[-350.756043,-686.96823,-0.275441895,0.691105246,-351.046558,-686.283309],$
		[-350.756273,-686.967886,-0.275219749,0.690755752,-351.046558,-686.283309],$
		[-294.142463,-758.586647,0.643041496,1.0048458,-293.521522,-757.568036],$
		[-294.161366,-757.59968,0.64040441,0.017705237,-293.521522,-757.568036],$
		[-292.576185,-759.171651,-0.910098704,1.62389845,-293.521522,-757.568036],$
		[-294.142219,-758.586629,0.642797618,1.00483304,-293.521522,-757.568036],$
		[-292.576185,-759.171651,-0.910098677,1.62389845,-293.521522,-757.568036],$
		[-292.576185,-759.171651,-0.910098629,1.62389832,-293.521522,-757.568036],$
		[-351.566018,-685.258708,0.497037215,-1.03568517,-351.046558,-686.283309],$
		[-350.756043,-686.96823,-0.275442167,0.691105236,-351.046558,-686.283309],$
		[-294.142219,-758.586629,0.642797674,1.00483296,-293.521522,-757.568036],$
		[-294.142219,-758.586629,0.642797674,1.00483296,-293.521522,-757.568036],$ ; this is the special Visit 42
		]

	visit_aper=["NIS_SOSSTA","NIS_SOSSTA","NIS_SOSSTA","NIS_AMITA","NIS_AMITA",$
	"NIS_AMITA","NIS_AMITA","NIS_AMITA","NIS_AMITA","NIS_SOSSTA","NIS_SOSSTA","NIS_AMITA","NIS_AMITA"]

	fgs=read_niriss_guider()

	forprint,visit_aper,fgs.penultimate_idls[0,*],fgs.penultimate_idls[1,*],fgs.last_idls[0,*],fgs.last_idls[1,*],$
			fgs.penultimate_idls[0,*]-fgs.last_idls[0,*],fgs.penultimate_idls[1,*]-fgs.last_idls[1,*]

	all_v2t=reform(visit_sidata[0,*])
	all_v3t=reform(visit_sidata[1,*])
	all_dv2=reform(visit_sidata[2,*])
	all_dv3=reform(visit_sidata[3,*])
	all_v2a=reform(visit_sidata[4,*])
	all_v3a=reform(visit_sidata[5,*])

	nv=n_elements(all_v3a)

	for v=0,nv-1 do begin

		v2a=double(all_v2a[v])	&	v3a=double(all_v3a[v])
		v2t=double(all_v2t[v])	&	v3t=double(all_v3t[v])

		dv2=v2t-v2a		&	dv3=v3t-v3a

		input_dv2=all_dv2[v]
		input_dv3=all_dv3[v]

		NM=jwst_t_to_a(v2a,v3a,v2t,v3t)

		uv=jwst_v23_to_unit(v2a,v3a)

		penult_fgs=jwst_v23_to_unit(fgs.penultimate_idls[0,v],fgs.penultimate_idls[1,v])
		last_fgs=jwst_v23_to_unit(fgs.last_idls[0,v],fgs.last_idls[1,v])

		ta=matrix_multiply(NM,uv)
		fgs_post=matrix_multiply(transpose(NM),penult_fgs)

		taout=jwst_unit_to_v23a(ta)

		out_fgs=jwst_unit_to_v23a(fgs_post)

		delta_fgsx=out_fgs[0]-fgs.penultimate_idls[0,v]
		delta_fgsy=out_fgs[1]-fgs.penultimate_idls[1,v]

		vin=[v2t,v3t]
		vout=[v2a,v3a]
		if verbose then begin
			print,'--- target [V2,V3]'
			print,v2t,v3t,format='(F14.9,"	",F14.9)'
			print,'--- aperture [V2,V3]'
			print,v2a,v3a,format='(F14.9,"	",F14.9)'
		endif
		xyidl_end=jwst_si_v23_to_xyidl(vout,'FGS','FGS1_FULL_OSS')
		xyidl_start=jwst_si_v23_to_xyidl(vin,'FGS','FGS1_FULL_OSS')

		xyidl_end=xyidl_end[0]
		xyidl_start=xyidl_start[0]

		;
		; Calculate the SAM parameters by subtracting the destination FGS Ideal coordinates from the current guide star position in FGS Ideal coordinates using eqn 43 and eqn 44
		; eqn 43	Delta_xIdl = xIdlEnd - xIdlStart
		; eqn 44	Delta_yIdl = yIdlEnd - yIdlStart

		delta_fgsxIdl=xyidl_end[0].xidl-xyidl_start[0].xidl
		delta_fgsyIdl=xyidl_end[0].yidl-xyidl_start[0].yidl
		delta_v2=xyidl_end[0].v2-xyidl_start[0].v2
		delta_v3=xyidl_end[0].v3-xyidl_start[0].v3

		print,visit_aper[v],taout,vout-taout,vin-taout,fgs.penultimate_idls[0,v],fgs.penultimate_idls[1,v],out_fgs[0],out_fgs[1],delta_fgsxIdl,delta_fgsyIdl,delta_v2,delta_v3,format='(A10,"	",14(F14.8,"	"))'
	endfor
	stop
end
