;V87800042001_2018045205707.html
function jwst_get_visit42_dithers,verbose=verbose,do_plot=do_plot
	if n_elements(do_plot) ne 1 then do_plot=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id="$Id: jwst_get_visit42_dithers.pro,v 1.2 2018/02/27 20:43:40 penton Exp $"
	FF='(F12.6)'
	si='FGS'
	form='(4("[",F9.6,",",F9.6,"]","	"))'
	form2='(12(F9.6,"	"))'
	;
	DITHERID=1
	NDITHERS=7
	;
	; These are the commanded NIRISS DITHERS
	; They are relative, and in the NIS_CEN_OSS aperture
	;
	DITHERS=[[1.0464,0.5593],[-0.5559,0.8883],[-0.981,-0.4277],[-0.0327,-1.2831],$
			 [1.0464,0.5593],[-0.5559,0.8883],[-0.981,-0.4277]]

	SAMs_Reported=[	[1.05296666, 0.546825116],$
					[-0.545313831, 0.894839629],$
					[-0.986008788,-0.416011939],$
					[-0.0479320861,-1.28261660],$
					[ 1.052966670, 0.546825120],$
					[-0.545313826, 0.894839635],$
					[-0.986008790,-0.416011942]]

	guider_init_xy=[50.432,-1.8707]
	target_init_v23=[-294.142219,-758.586629]
	guider_init_tasam_xy=[0.642797674,1.00483296]
	guidername='GUIDER1'

	v00=jwst_si_xyidl_to_v23([0,0],'NIRISS',"NIS_CEN_OSS",v2ref=0,v3ref=0)
	v00v23=v00.v23
	f00=jwst_si_v23_to_xyidl(v00.v23,'FGS','FGS1_FULL_OSS',v2ref=0,v3ref=0)
	f00xy=f00.xyidl
	; Here are the dithers, I think they are [xidl,yidl] of NIRISS
	;
	;	1.04640	0.559300
	;	-0.555900	0.888300
	;	-0.981000	-0.427700
	;	-0.0327000	-1.28310
	;	1.04640	0.559300
	;	-0.555900	0.888300
	;	-0.981000	-0.427700
	;
	; To convert these to TA SAM, then I would need to
	;
	; 1) NIRISS_CEN_OSS[Xidl,Yidl] -> [v2,v3]
	; 2) [v2,v3] -> FGS_FULL_OSS[Xidl,Yidl]
	;
	;Table 1 Dither patterns and drizzle parameters used in simulations
	;	Pattern Pixel shifts (x, y)
	;
	;	2-point	(0.0, 0.0) (4.5, 4.5)	0.5	1.0
	;	3-point	(0.0, 0.0) (4.33, 4.33) (8.67, 8.67)	0.5	1.0
	;	4-point	(0.0, 0.0) (5.0, 2.5) (2.5, 6.0) (-2.5,4.5)	0.5	0.8
	;	9-point	(4.00, 6.67) (7.33, 8.67) (10.67, 10.67) (2.00, 3.33) (5.33, 5.33) (8.67, 7.33) (0.00, 0.00) (3.33, 2.00) (6.67, 4.00)	0.5	0.8
	;
	xyidls=(DITHERS < 0) > 0
	current_niriss_xy=[0,0]
	SAMs_Calculated=(DITHERs > 0) < 0
	for i=0,ndithers-1 do begin
		dither=[DITHERS[0,i],DITHERS[1,i]]
		;
		; 1) Convert the dither from NIRISS [X,Y] to [v2,v3]
		;
		message,/info,'Current NIRISS position [Xidl,Yidl] = '+string1f(current_niriss_xy[0],format=FF)+','+string1f(current_niriss_xy[1],format=FF)+']""'
		message,/info,'Commanded DITHER = ['+string1f(dither[0],format=FF)+','+string1f(dither[1],format=FF)+']""'
		v23=jwst_si_xyidl_to_v23(dither,'NIRISS',"NIS_CEN_OSS",v2ref=0,v3ref=0,/verbose)
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
		old_niriss_xy=current_niriss_xy
		current_niriss_xy+=dither
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
;  SLEW ,01 ,SCSLEWMAIN ,DETECTOR=GUIDER1 ,SLEWREQ=REQ ,FSMOPTION=SETTLE
;  ,DDC=NIS_AMI ,GSRA=80.3 ,GSDEC=-69.6077 ,GSPA=128.87 ,GSX=0 ,GSY=0
;  ,GSPASCI=127.092 ,GSXSCI=50.7547 ,GSYSCI=-1.97515 ,LSST=2025-001/02:30:00;
;
;  ACT ,02 ,FGSMAIN ,DETECTOR=GUIDER1 ,DDC=NIS_AMI ,GSCOUNTS=153846
;  ,GSTHRESH=53846 ,GSROLLID=128.87 ,GSXID=0 ,GSYID=0 ,GSROLLSCI=127.092
;  ,GSXSCI=50.7547 ,GSYSCI=-1.97515 ,GSDEC=-69.6077 ,GSRA=80.3;

;start itst_oss_fgses_los_set ( "GUIDER1",0,0)
;[Xidl,Yidl]=	50.758	-1.9417	-0.133896756	-0.260026469 ; Initial
;[Xidl,Yidl]=	50.624	-2.202	-0.192279883	0.331306966  ; Post TA ?
;From guiding: guider 1 X ideal 50.432	-1.8707
;target location (v2,v3) = (-294.142219,-758.586629)
;TA SAM (x	y) = 0.642797674	1.00483296
;
; We have a 7 pattern dither but there appears to be 4 sets of these
; But, the dithers are the same, so it's just a different starting position
;
;[Xidl,Yidl]=	51.075	-0.86617	 1.052966660	 0.546825116
;[Xidl,Yidl]=	52.128	-0.31917	-0.545313831	 0.894839629
;[Xidl,Yidl]=	51.583	 0.57584	-0.986008788	-0.416011939
;[Xidl,Yidl]=	50.597	 0.15999	-0.0479320861	-1.28261660
;[Xidl,Yidl]=	50.549	-1.12260	 1.052966670	 0.546825120
;[Xidl,Yidl]=	51.602	-0.57617	-0.545313826	 0.894839635
;[Xidl,Yidl]=	51.057	 0.31884	-0.986008790	-0.416011942
;
;; ------ That's 7
;[Xidl,Yidl]=	51.411	-5.57960	 1.052966630	 0.546825114
;[Xidl,Yidl]=	52.464	-5.03320	-0.545313891	 0.894839625
;[Xidl,Yidl]=	51.919	-4.13820	-0.986008758	-0.416011937
;[Xidl,Yidl]=	50.933	-4.55400	-0.0479319989	-1.28261659
;[Xidl,Yidl]=	50.885	-5.83660	 1.052966630	 0.546825117
;[Xidl,Yidl]=	51.938	-5.29020	-0.545313886	 0.894839631
;[Xidl,Yidl]=	51.393	-4.39520	-0.986008760	-0.416011940
;;
;; This is another 7 dither the [X,Y]s are different but the last SAMs repeat
;
;start itst_oss_fgses_los_set ( "GUIDER1",50.407,-4.811)
;FGS Guider 1 poor quality centroid data in TRK or FG.
;start itst_oss_fgses_los_set ( "GUIDER1",51.112,-0.81764)
;FGS Guider 1 poor quality centroid data in TRK or FG.
;[Xidl,Yidl]=	51.112	-0.81764	 1.052966660	0.546825116
;[Xidl,Yidl]=	52.165	-0.27117	-0.545313831	0.894839628
;[Xidl,Yidl]=	51.620	 0.62384	-0.986008788	-0.416011939
;[Xidl,Yidl]=	50.634	 0.20799	-0.0479320862	-1.28261660
;[Xidl,Yidl]=	50.586	-1.07460	 1.052966670	0.546825120
;[Xidl,Yidl]=	51.639	-0.52817	-0.545313826	0.894839634
;[Xidl,Yidl]=	51.094	 0.36684	-0.986008790	-0.416011941
;;
;[Xidl,Yidl]=	51.448	-5.53160	 1.052966630	0.546825113
;[Xidl,Yidl]=	52.501	-4.98520	-0.545313891	0.894839625
;[Xidl,Yidl]=	51.956	-4.09020	-0.986008758	-0.416011937
;[Xidl,Yidl]=	50.970	-4.50600	-0.0479319990	-1.28261659
;[Xidl,Yidl]=	50.922	-5.78860	 1.052966630	0.546825117
;[Xidl,Yidl]=	51.975	-5.24220	-0.545313886	0.894839631
;[Xidl,Yidl]=	51.430	-4.34720	-0.986008760	-0.416011940
;
