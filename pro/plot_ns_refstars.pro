pro plot_ns_refstars
	rcs_id="$Id: plot_ns_refstars.pro,v 1.4 2018/04/10 14:23:57 penton Exp penton $"
;
;
;
; InstrName	AperName	DDCName	AperType	XSciScale	YSciScale	V2Ref	V3Ref	V3IdlYAngle	VIdlParity
; NIRSPEC	NRS1_FULL_OSS	NRS1_CNTR	OSS	0.10324663	0.10533870	294.054813	-502.901911	139.155450	1
; NIRSPEC	NRS1_FULL	NRS1_CNTR	FULLSCA	0.10326748	0.10532422	294.054813	-502.901911	139.155450	-1
; NIRSPEC	NRS2_FULL_OSS	NRS2_CNTR	OSS	0.10331174	0.10536197	463.165228	-353.212474	-42.281773	1
; NIRSPEC	NRS_FULL_MSA	NRS_CNTR	SLIT						378.771240	-428.156219	138.492340	-1
; BOTA/WATA is S1600A1 TA APERTURE
;
; NRS_S1600A1_SLIT	NRS1_CNTR
; [V2ref,V3ref]=[321.531952,-473.679199]
; V3IdlYangle=138.771439
; VIdlParity = -1
;
	close_gwin
	pngdir=jwst_get_dir(/NIRSPEC,/png)
	color1='BLUE'
	color1r='CYAN'
	color2='RED'
	color2r='HOT PINK'

	NRS=jwst_read_si_siaf('NIRSPEC',redo=redo,verbose=verbose,debug=debug)

	XIDLV1=NRS.XIDLVERT1
	XIDLV2=NRS.XIDLVERT2
	XIDLV3=NRS.XIDLVERT3
	XIDLV4=NRS.XIDLVERT4
	YIDLV1=NRS.YIDLVERT1
	YIDLV2=NRS.YIDLVERT2
	YIDLV3=NRS.YIDLVERT3
	YIDLV4=NRS.YIDLVERT4
	V3IDLYANGLE=NRS.V3IDLYANGLE
	VIDLPARITY=NRS.VIDLPARITY

	ps=[[0.10326748,0.10532422], $ ; NRS1
		[0.10331174,0.10536197]] ; NRS2
	ps_x=NRS.XSciScale*(1.0)
	ps_y=NRS.YSciScale*(1.0)
	apername=NRS.AperName
	aper1='NRS1_FULL_OSS'
	aper2='NRS2_FULL_OSS'

	index1=where(apername eq aper1,ct1)
	index2=where(apername eq aper2,ct2)

	xyidlv1_1=[XIDLV1[index1],YIDLV1[index1]]
	v23_vert1_1=jwst_si_xyidl_to_v23(xyidlv1_1,'NIRSPEC',aper1)

	xyidlv2_1=[XIDLV2[index1],YIDLV2[index1]]
	v23_vert2_1=jwst_si_xyidl_to_v23(xyidlv2_1,'NIRSPEC',aper1)

	xyidlv3_1=[XIDLV3[index1],YIDLV3[index1]]
	v23_vert3_1=jwst_si_xyidl_to_v23(xyidlv3_1,'NIRSPEC',aper1)

	xyidlv4_1=[XIDLV4[index1],YIDLV4[index1]]
	v23_vert4_1=jwst_si_xyidl_to_v23(xyidlv4_1,'NIRSPEC',aper1)

	xyidlv1_2=[XIDLV1[index2],YIDLV1[index2]]
	v23_vert1_2=jwst_si_xyidl_to_v23(xyidlv1_2,'NIRSPEC',aper2)

	xyidlv2_2=[XIDLV2[index2],YIDLV2[index2]]
	v23_vert2_2=jwst_si_xyidl_to_v23(xyidlv2_2,'NIRSPEC',aper2)

	xyidlv3_2=[XIDLV3[index2],YIDLV3[index2]]
	v23_vert3_2=jwst_si_xyidl_to_v23(xyidlv3_2,'NIRSPEC',aper2)

	xyidlv4_2=[XIDLV4[index2],YIDLV4[index2]]
	v23_vert4_2=jwst_si_xyidl_to_v23(xyidlv4_2,'NIRSPEC',aper2)

	ps_x1=(reform(ps_x[index1]))[0]
	ps_y1=(reform(ps_y[index2]))[0]
	ps_x2=(reform(ps_x[index1]))[0]
	ps_y2=(reform(ps_y[index2]))[0]

	vbigbox_x1=[v23_vert1_1.v2,v23_vert2_1.v2,v23_vert3_1.v2,v23_vert4_1.v2,v23_vert1_1.v2]
	vbigbox_x2=[v23_vert1_2.v2,v23_vert2_2.v2,v23_vert3_2.v2,v23_vert4_2.v2,v23_vert1_2.v2]
	vbigbox_y1=[v23_vert1_1.v3,v23_vert2_1.v3,v23_vert3_1.v3,v23_vert4_1.v3,v23_vert1_1.v3]
	vbigbox_y2=[v23_vert1_2.v3,v23_vert2_2.v3,v23_vert3_2.v3,v23_vert4_2.v3,v23_vert1_2.v3]

	ibigbox_x1=(reform(NRS.V2REF[index1]))[0]+[XIDLV1[index1],XIDLV2[index1],XIDLV3[index1],XIDLV4[index1],XIDLV1[index1]]
	ibigbox_x2=(reform(NRS.V2REF[index2]))[0]+[XIDLV1[index2],XIDLV2[index2],XIDLV3[index2],XIDLV4[index2],XIDLV1[index2]]
	ibigbox_y1=(reform(NRS.V3REF[index1]))[0]+[YIDLV1[index1],YIDLV2[index1],YIDLV3[index1],YIDLV4[index1],YIDLV1[index1]]
	ibigbox_y2=(reform(NRS.V3REF[index2]))[0]+[YIDLV1[index2],YIDLV2[index2],YIDLV3[index2],YIDLV4[index2],YIDLV1[index2]]

	help,ibigbox_x1,ibigbox_y1,ibigbox_x2,ibigbox_y2
	print,'-----'
	forprint,ibigbox_x1,ibigbox_y1,ibigbox_x2,ibigbox_y2
	print,'-----'
	forprint,vbigbox_x1,vbigbox_y1,vbigbox_x2,vbigbox_y2
	print,'-----'
	xs=(ys=32.0)
	hs=xs/2.

	xr=[650,100]+[-10,10]
	yr=[-700,-200]+[-10,10]
	REFSTARs=[[377.393326,-565.829778,1,1219,1970],$
		[307.344353,-446.863266,1,1463,694],$
		[304.549599,-368.144899,1,1951,109],$
		[314.843702,-458.842479,1,1441,827],$
		[259.34421099,-435.068119,1,1185,302],$
		[352.180722,-418.424003,1,1975,776],$
		[309.382966,-377.11018899,1,1928,205],$
		[324.90877199,-448.867364,1,1579,820],$
		[422.740361,-525.516016,1,1801,1970],$
		[250.254232,-421.49136399,1,1205,146],$
		[343.484277,-325.65398699,2,1696,1966],$
		[497.473222,-411.653541,2,1142,381],$
		[497.275168,-454.536401,2,1420,82],$
		[387.51252299,-371.046258,2,1670,1356],$
		[465.85008499,-427.25002699,2,1469,466],$
		[382.570419,-355.80509499,2,1607,1497],$
		[448.095793,-473.82625799,2,1896,249],$
		[376.03454599,-328.02890899,2,1473,1740],$
		[343.876952,-336.629654,2,1764,1884],$
		[462.451029,-395.87322,2,1290,709]]

		mcen=[378.771240,-428.156219]

		; create a line that passes through mcen at V3IDLAngle

		xx=xr[0]+findgen(abs(xr[1]-xr[0]))
		xp=xx-mcen[0]
		yy=mcen[1]+cos(V3IDLYANGLE*!dtor)*xp
		yys=mcen[1]+sin(V3IDLYANGLE*!dtor)*xp
		index1=where(REFSTARs[2,*] eq 1,i1)
		index2=where(REFSTARs[2,*] eq 2,i2)
		p1=plot(REFSTARs[0,index1],REFSTARS[1,index1],"S",/sym_filled,name='  DET1',$
			font_size=16,dimensions=[1000,800],sym_size=0.25,xrange=xr,yrange=yr,$
			xtitle='V2 (")',ytitle='V3 (")',linestyle=6,font_name='Times',$
			title='NIRSPEC REFSTARS (V84800001001)',color=color1,/ASPECT_RATIO)
		p2=plot(REFSTARs[0,index2],REFSTARS[1,index2],"S",/sym_filled,sym_size=0.25,font_size=16,$
			xtitle='V2 (")',ytitle='V3 (")',linestyle=6,font_name='Times',/overplot,color=color2,name='  DET2')
		p3=plot([mcen[0],mcen[0]],[mcen[1],mcen[1]],"+",color='BLACK',/overplot,sym_size=2,sym_thick=3,$
			name='  NRS_FULL_MSA')

		l=legend(shadow=0,/auto_text_color,linestyle=6,position=[420,-560],/data)
		pbb1=plot(vbigbox_x1,vbigbox_y1,/overplot,linestyle=3,color=color1)
		pbb2=plot(vbigbox_x2,vbigbox_y2,/overplot,linestyle=3,color=color2)

		for i=0,i1-1 do begin
			print,'APER1 - # '+string1i(i+1)
			xc=(reform(REFSTARs[3,index1[i]]))[0] ;* ps_x1
			yc=(reform(REFSTARs[4,index1[i]]))[0] ;* ps_y1

			this_star_x=[REFSTARs[0,index1[0]],REFSTARs[0,index1[0]]]
			this_star_y=[REFSTARs[1,index1[0]],REFSTARs[1,index1[0]]]
			p11=plot(this_star_x,this_star_y,"o",/overplot,sym_size=2)

			box_x1=xc+([0,xs,xs,0,0]) ;*ps_x1
			box_y1=yc+([0,0,ys,ys,0]) ;*ps_y1
			xybox=fltarr(2,5)
			xybox[0,*]=box_x1
			xybox[1,*]=box_y1
			xysci=jwst_si_det_to_sci(xybox,'NIRSPEC',aper1,debug=debug)
			xyidl=jwst_si_sci_to_idl(xysci.xysci,'NIRSPEC',aper1,debug=debug,/verbose)
			help,xyidl,/str
			v23=jwst_si_xyidl_to_v23(xyidl.xyidl,'NIRSPEC',aper1,debug=debug)

			p1_32=plot(v23.v2,v23.v3,linestyle=0,color='GREEN',thick=3,current=p1,/overplot)
			print,'XBOX	YBOX	XSCI	YSCI	XSCI-XSCIref	YSCI-YSCIref	XIDL	YIDL	V2	V3'
			forprint,xybox[0,*],xybox[1,*],xysci.xsci,xysci.ysci,xysci.dx,xysci.dy,xyidl.xidl,xyidl.yidl,v23.v2,v23.v3,$
				FORMAT='(6(F6.1,"	"),4(F10.4,"	"))
			help,v23,/str
		endfor
		for i=0,i2-1 do begin
			print,'APER2 - # '+string1i(i+1)
			xc=(reform(REFSTARs[3,index2[i]]))[0] ;* (-ps_y2)
			yc=(reform(REFSTARs[4,index2[i]]))[0] ;* (ps_y2)

			box_x2=xc+([0,xs,xs,0,0])
			box_y2=yc+([0,0,ys,ys,0])
			xybox=fltarr(2,5)
			xybox[0,*]=box_x2
			xybox[1,*]=box_y2
			xysci=jwst_si_det_to_sci(xybox,'NIRSPEC',aper2)
			xyidl=jwst_si_sci_to_idl(xysci.xysci,'NIRSPEC',aper2)
			v23=jwst_si_xyidl_to_v23(xyidl.xyidl,'NIRSPEC',aper2)
			p2_32=plot(v23.v2,v23.v3,linestyle=0,color=color2,/overplot,current=p2,thick=2)
			forprint,xybox[0,*],xybox[1,*],xysci.xsci,xysci.ysci,xyidl.xidl,xyidl.yidl,v23.v2,v23.v3,$
				FORMAT='(4(F6.1,"	"),4(F10.4,"	"))
		endfor

		message,/info,'Making '+pngdir+'V84800001001_refstars.png'
		p1.save,pngdir+'V84800001001_refstars.png'
		stop
end
