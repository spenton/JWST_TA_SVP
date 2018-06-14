;V82800002001
function_jwst_nircam_dithercheck,verbose=verbose,do_plot=do_plot
	if n_elements(do_plot) ne 1 then do_plot=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	FF='(F12.6)'
	out_si='FGS'
	in_si='NIRCAM'
	form='(4("[",F9.6,",",F9.6,"]","	"))'
	form2='(12(F9.6,"	"))'

	dithers=
end
function jwst_nircam_dithertest,verbose=verbose,do_plot=do_plot
	if n_elements(do_plot) ne 1 then do_plot=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id="$Id: jwst_nircam_dithertest.pro,v 1.1 2018/03/15 12:12:32 penton Exp $"
	FF='(F12.6)'
	out_si='FGS'
	in_si='NIRCAM'
	form='(4("[",F9.6,",",F9.6,"]","	"))'
	form2='(12(F9.6,"	"))'
	;
	DITHERID=1
	NDITHERS=63
	;
	; These are the commanded NIRCAM DITHERS
	; The input aperture is unknown, so try them all
	;
	DITHERS=[[0.224,0.08],[-0.144,0.144],[0.224,0.08],[0.184,-0.304],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[-0.024,0.472],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.2,0.272],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.212,0.268],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[0.28,-0.208],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.024,-0.488],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[0.184,-0.304],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[0.168,-0.316],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[0.184,-0.304],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[-0.312,0.184],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[-0.296,0.176],$
			[0.224,0.08],[-0.144,0.144],[0.224,0.08],[-0.028,0.46],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.2,0.272],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.216,0.28],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048],[-0.2,0.272],$
			[-0.224,-0.048],[0.176,-0.176],[-0.224,-0.048] ]

	SAMs_Reported=[	[1.05296666, 0.546825116],$
					[-0.545313831, 0.894839629],$
					[-0.986008788,-0.416011939],$
					[-0.0479320861,-1.28261660],$
					[ 1.052966670, 0.546825120],$
					[-0.545313826, 0.894839635],$
					[-0.986008790,-0.416011942]]

	apertures='NRC'+['A1','A2','A3','A4','A5','B1','B2','B3','B4','B5']+'_FULL_OSS'
	naper=n_elements(apertures)
	guider_init_xy=[50.432,-1.8707]
	target_init_v23=[-294.142219,-758.586629]
	guider_init_tasam_xy=[0.642797674,1.00483296]
	guidername='GUIDER1'

	v00=jwst_si_xyidl_to_v23([0,0],in_si,aper[a],v2ref=0,v3ref=0)
	v00v23=v00.v23
	f00=jwst_si_v23_to_xyidl(v00.v23,out_si,'FGS1_FULL_OSS',v2ref=0,v3ref=0)
	f00xy=f00.xyidl
	; The dithers are [xidl,yidl] of NIRCAM
	;
	; To convert these to TA SAM, then I would need to
	;
	; 1) NIRCAM_APERTURE[Xidl,Yidl] -> [v2,v3] (but what is the APERTURE?)
	; 2) [v2,v3] -> FGS_FULL_OSS[Xidl,Yidl]
	;
	;
	xyidls=(DITHERS < 0) > 0
	current_NIRCAM_xy=[0,0]
	SAMs_Calculated=(DITHERs > 0) < 0
	for i=0,ndithers-1 do begin
		dither=[DITHERS[0,i],DITHERS[1,i]]
		;
		; 1) Convert the dither from NIRCAM [X,Y] to [v2,v3]
		;
		message,/info,'Current NIRCAM position [Xidl,Yidl] = '+string1f(current_NIRCAM_xy[0],format=FF)+','+string1f(current_NIRCAM_xy[1],format=FF)+']""'
		message,/info,'Commanded DITHER = ['+string1f(dither[0],format=FF)+','+string1f(dither[1],format=FF)+']""'
		v23=jwst_si_xyidl_to_v23(dither,'NIRCAM',"NIS_CEN_OSS",v2ref=0,v3ref=0,/verbose)
		message,/info,'Commanded DITHER in [V2,V3] = ['+string1f(v23.v2,format=FF)+','+string1f(v23.v3,format=FF)+']""'
		f23=jwst_si_v23_to_xyidl([v23.v2,v23.v3],'FGS','FGS1_FULL_OSS',v2ref=0,v3ref=0,/verbose)
		;
		; 2) Translate the dither from [v2,v3] to FGS [X,Y]
		;
		message,/info,'Commanded DITHER in FGS [Xidl,Yidl] = ['+string1f(f23.xidl,format=FF)+','+string1f(f23.yidl,format=FF)+']""'
		f23xy=f23.xyidl
		;
		; Store SAM
		;
		SAMs_Calculated[*,i]=f23xy
		;
		; update current_xy
		;
		old_NIRCAM_xy=current_NIRCAM_xy
		current_NIRCAM_xy+=dither
	endfor
	;
	print,'DITHERS	SAMs	SAMs	Difference'
	print,'([X,Y]")	([X,Y] Calculated, ")	([X,Y] Reported, ")	([X,Y] Reported - Calculated, mas)'
	SAMs_DIFF_mas=1000*(SAMs_Reported-SAMs_Calculated)
	forprint,dithers[0,*],dithers[1,*],SAMs_Calculated[0,*],SAMs_Calculated[1,*],SAMs_Reported[0,*],SAMs_Reported[1,*],SAMs_DIFF_mas[0,*],SAMs_DIFF_mas[1,*],format=form
	rms_diffs=sqrt(total(SAMs_DIFF_mas^2)/n_elements(SAMs_DIFF_mas) )
	message,/info,'RMS DIFFS = '+string1f(rms_diffs*1000.,format=FF)+' micro-arcseconds'
	print,'---'
	print,'DITHERS		SAMs		SAMs		Difference'
	print,'([X,Y]")		([X,Y] Calculated, ")		([X,Y] Reported, ")		([X,Y] Reported - Calculated, mas)'
	forprint,dithers[0,*],dithers[1,*],SAMs_Calculated[0,*],SAMs_Calculated[1,*],SAMs_Reported[0,*],SAMs_Reported[1,*],SAMs_DIFF_mas[0,*],SAMs_DIFF_mas[1,*],format=form2
	print,'---'
	out={ditherid:ditherid,ndithers:ndithers,dithers:dithers,SAMs_Calculated:SAMs_Calculated,$
		SAMs_Reported:SAMs_Reported,SAMs_DIFF_mas:SAMs_DIFF_mas}
end

;MOMENTUM ,MOMEARLY=[1.5732,-1.5882,-3.2334],MOMLATE=[1.6715,-1.3575,-3.6303] ,MOMLIMIT=90;
;
;  SLEW ,01 ,SCSLEWMAIN ,DETECTOR=GUIDER1 ,SLEWREQ=REQ ,FSMOPTION=SETTLE
;  ,DDC=NRCA_CNTR ,GSRA=80.3339 ,GSDEC=-69.5107 ,GSPA=129.024 ,GSX=-1.01155
;  ,GSY=46.329 ,GSPASCI=126.471 ,GSXSCI=-37.4456 ,GSYSCI=57.8627
;  ,LSST=2025-001/02:30:00;
;
;  ACT ,02 ,FGSMAIN ,DETECTOR=GUIDER1 ,DDC=NRCA_CNTR ,GSCOUNTS=153846
;  ,GSTHRESH=53846 ,GSROLLID=129.024 ,GSXID=-1.01155 ,GSYID=46.329
;  ,GSROLLSCI=126.471 ,GSXSCI=-37.4456 ,GSYSCI=57.8627 ,GSDEC=-69.5107
;  ,GSRA=80.3339;
;
;  ACT ,03 ,FGSVERMAIN;
;
;GROUP ,02 :CONGRP ,SI=NRC;
;
; SEQ ,1 ::CONSEQ ,SI=NRC;
;
;  ACT ,01 ,NRCMAIN ,CONFIG=NRCAALL ,TARGTYPE=FLAT ,DITHERID=1
;  ,PATTERN=MEDIUM2 ,NINTS=1 ,NGROUPS=2 ,FILTSHORTA=F150W2 ,FILTLONGA=F356W
;  ,PUPILSHORTA=F162M ,PUPILLONGA=F323N ,SUBARRAY=FULL;
