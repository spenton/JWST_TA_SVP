;+
; Convert from NIRSpec GWA (OUT) coordinates to Sky ([V2,V3]) coordinates
;
; :Author:
;    Steven V. Penton
;
; Usage:
;          v23SKY=JWST_GWAout_TO_SKY(GWAout[,verbose=verbose],$
;                 [,debug=debug][,redo=redo],[out_apername=out_apername][,out_si=out_si])
;
; Inputs:
;	GWAout: in, required, type=structure
;     xgwaprime: contains the GWA out side X coordinate(s)
;     ygwaprime: contains the GWA out side Y coordinate(s)
;
;	v23SKY: out, structure
;		contains the output structure
;     v2: contains the SKY V2 coordinate(s) (arcseconds)
;     v3: contains the SKY V3 coordinate(s) (arcseconds)

;	apername: in, required, string
;			Must be a valid Aperture Name for the SI in question
;    verbose : in, optional, type=boolean
;       if set, print informational messages
;    debug : in, optional, type=boolean
;       if set, output debugging information
;    redo : in, optional, type=boolean, default = NO (0)
;       if set, re-create the siaf file for the given SI
;    out_apername : in, optional, type=string
;       if set, overrides the default of 'FGS1_FULL_OSS'
;    out_si : in, optional, type=string
;       if set, overrides the default of 'FGS'
;-

pro test_sky_to_gwaout,apername,verbose=verbose,debug=debug,detnum=detnum
	if n_elements(detnum) ne 1 then detnum=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	;
	; Read in the NIRSPEC TEAM TEST FILES and test
	;
	; Step 1) NRS DETector to GWAin
	; Step 2) GWAin to GWAout (prime)
	; Step 3) GWAout to SKY
	;
	testdir=jwst_get_nrs_testdir()
	testfile=''
	readcol,testdir+testfile,v1,v2 ; ...

	aperture='NRS1_FULL_OSS'
	aper2='NRS2_FULL_OSS'
	aper_gwa='CLEAR_GWA_OTE'
	for t=0,nt -1 do begin
		print,'---'
		xy=testxy[*,t]
		v23SKY=jwst_nrs_gwaout_to_sky(GWAout,apername=aper_gwa,debug=debug,verbose=verbose)
		print,'DET',xyDET
		print,'SKY',v23SKY
		print,'---'
	endfor
	stop
end

function jwst_nrs_gwaout_to_sky,GWAout,apername=apername,verbose=verbose,debug=debug
	;,XSciRef=XSciRef,YSciRef=YSciRef,XDetRef=XDetRef,YDetRef=YDetRef,IdlSciParity=IdlSciParity,V2ref=V2ref,V3ref=V3ref
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(apername) ne 1 then apername='CLEAR_GWA_OTE'
	rcs_id="$Id$"
	;
	; Convert from GWA to SKY coordinates
	;
	; GWAout are outward looking direction cosines (Skyward) of the GWA
	;
	; Specifically, GWAout is a structure with:
	;
	; GWAout={n:n,xprimegwa:xprimegwa,yprimegwa:yprimegwa,zprimegwa,$
	;  xgwa:xgwa,ygwa:ygwa,zgwa:zgwa}
	;
	; "prime" indicates the skyward side of the GWA (Grating Wheel Assembly)
	;
	; There is nothing fancy about the direction cosines, they are just:
	;
	;	cos  α  = x|A⃗ = x/√ x^2 + y^2 + z^2
	;	cos  β  = y|A⃗ = y/√ x^2 + y^2 + z^2
	;	cos  γ  = z|A⃗ = z/√ x^2 + y^2 + z^2
	;
	; SKY is in arcseconds ([V2,V3]), XYAN are in degrees, as dictated
	; by the coefficients in the nrs_siaf.
	;
	; XAN = SUMi SUMj GWA2XANij (xGWA)^(i-j) * (yGWA)^j
	; YAN = SUMi SUMj GWA2YANij (xGWA)^(i-j) * (yGWA)^j
	;
	; Conversion to [V2,V3] is handled by v23xyan=jwst_xyan_to_v23(XYAN)
	;
	; where XYAN=[XAN,YAN] and,
	;	V2 =   3600*XAN (arcseconds)
	;	V3 = -(3600*YAN+468) (arcseconds)
	;
	;	[V2,V3]=[0.0,-468.0] is the center of the NIRspec apertures.
	;
	; GWA2XAN, GWA2YAN are from the SIAF tables for NIRspec
	;
	;
	rcs_id='$Id$'
	si='NRS' ; NIRspec
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	if verbose help,GWAout,/str
	;
	xprimegwa=GWAout.xprimegwa
	yprimegwa=GWAout.yprimegwa
	zprimegwa=GWAout.zprimegwa

	nrs_siaf=jwst_read_si_siaf('NRS',verbose=(verbose > 1))
	;
	; The SIAF contains Idl2SCI[X,Y]ij, these are really, GWA2[X,Y]ANij
	; e.g.,  GWA2XAN12 = IDL2SCIX12
	;
	; See section 5.5.1 of the SIAF Part 4 (Proffitt) document
	;
	index=where(nrs_siaf.APERNAME eq uAPER,count)
	;
	GWA2XAN00=(double(reform(nrs_siaf.Idl2SciX00[index])))[0]
	GWA2XAN10=(double(reform(nrs_siaf.Idl2SciX10[index])))[0]
	GWA2XAN11=(double(reform(nrs_siaf.Idl2SciX11[index])))[0]
	GWA2XAN20=(double(reform(nrs_siaf.Idl2SciX20[index])))[0]
	GWA2XAN21=(double(reform(nrs_siaf.Idl2SciX21[index])))[0]
	GWA2XAN22=(double(reform(nrs_siaf.Idl2SciX22[index])))[0]
	GWA2XAN30=(double(reform(nrs_siaf.Idl2SciX30[index])))[0]
	GWA2XAN31=(double(reform(nrs_siaf.Idl2SciX31[index])))[0]
	GWA2XAN32=(double(reform(nrs_siaf.Idl2SciX32[index])))[0]
	GWA2XAN33=(double(reform(nrs_siaf.Idl2SciX33[index])))[0]
	GWA2XAN40=(double(reform(nrs_siaf.Idl2SciX40[index])))[0]
	GWA2XAN41=(double(reform(nrs_siaf.Idl2SciX41[index])))[0]
	GWA2XAN42=(double(reform(nrs_siaf.Idl2SciX42[index])))[0]
	GWA2XAN43=(double(reform(nrs_siaf.Idl2SciX43[index])))[0]
	GWA2XAN44=(double(reform(nrs_siaf.Idl2SciX44[index])))[0]
	GWA2XAN50=(double(reform(nrs_siaf.Idl2SciX50[index])))[0]
	GWA2XAN51=(double(reform(nrs_siaf.Idl2SciX51[index])))[0]
	GWA2XAN52=(double(reform(nrs_siaf.Idl2SciX52[index])))[0]
	GWA2XAN53=(double(reform(nrs_siaf.Idl2SciX53[index])))[0]
	GWA2XAN54=(double(reform(nrs_siaf.Idl2SciX54[index])))[0]
	GWA2XAN55=(double(reform(nrs_siaf.Idl2SciX55[index])))[0]
	;
	GWA2YAN00=(double(reform(nrs_siaf.Idl2SciY00[index])))[0]
	GWA2YAN10=(double(reform(nrs_siaf.Idl2SciY10[index])))[0]
	GWA2YAN11=(double(reform(nrs_siaf.Idl2SciY11[index])))[0]
	GWA2YAN20=(double(reform(nrs_siaf.Idl2SciY20[index])))[0]
	GWA2YAN21=(double(reform(nrs_siaf.Idl2SciY21[index])))[0]
	GWA2YAN22=(double(reform(nrs_siaf.Idl2SciY22[index])))[0]
	GWA2YAN30=(double(reform(nrs_siaf.Idl2SciY30[index])))[0]
	GWA2YAN31=(double(reform(nrs_siaf.Idl2SciY31[index])))[0]
	GWA2YAN32=(double(reform(nrs_siaf.Idl2SciY32[index])))[0]
	GWA2YAN33=(double(reform(nrs_siaf.Idl2SciY33[index])))[0]
	GWA2YAN40=(double(reform(nrs_siaf.Idl2SciY40[index])))[0]
	GWA2YAN41=(double(reform(nrs_siaf.Idl2SciY41[index])))[0]
	GWA2YAN42=(double(reform(nrs_siaf.Idl2SciY42[index])))[0]
	GWA2YAN43=(double(reform(nrs_siaf.Idl2SciY43[index])))[0]
	GWA2YAN44=(double(reform(nrs_siaf.Idl2SciY44[index])))[0]
	GWA2YAN50=(double(reform(nrs_siaf.Idl2SciY50[index])))[0]
	GWA2YAN51=(double(reform(nrs_siaf.Idl2SciY51[index])))[0]
	GWA2YAN52=(double(reform(nrs_siaf.Idl2SciY52[index])))[0]
	GWA2YAN53=(double(reform(nrs_siaf.Idl2SciY53[index])))[0]
	GWA2YAN54=(double(reform(nrs_siaf.Idl2SciY54[index])))[0]
	GWA2YAN55=(double(reform(nrs_siaf.Idl2SciY55[index])))[0]
;
;	Give priority to passed in XDetRef and YDetRef
;
;	XDetRef=(n_elements(XDetRef) eq 1 ? XDetRef : (reform(nrs_siaf.XDetRef[index]))[0])
;	YDetRef=(n_elements(YDetRef) eq 1 ? YDetRef : (reform(nrs_siaf.YDetRef[index]))[0])
;	XSciRef=(n_elements(XSciRef) eq 1 ? XSciRef : (reform(nrs_siaf.XSciRef[index]))[0])
;	YSciRef=(n_elements(YSciRef) eq 1 ? YSciRef : (reform(nrs_siaf.YSciRef[index]))[0])
;
;	psxSci=(reform(nrs_siaf.XSciSCALE[index]))[0]
;	psySci=(reform(nrs_siaf.YSciSCALE[index]))[0]
;
;	V2ref=(reform(nrs_siaf.V2ref[index]))[0]
;	V3ref=(reform(nrs_siaf.V3ref[index]))[0]

	xydegree=(reform(nrs_siaf.Sci2IdlDeg[index]))[0]

	if verbose then begin
		message,/info,'APERNAME = '+uAPER+' ('+apername+')'
		;message,/info,'[XDetRef,YDetRef] = ['+string1f(XDetRef,format=FF)+','+string1f(YDetRef,format=FF)+']'
		;message,/info,'[XSciref,YSciref] = ['+string1f(XSciRef,format=FF)+','+string1f(YSciRef,format=FF)+']'
		;message,/info,'[V2ref,V3ref] = ['+string1f(V2ref,format=FF)+','+string1f(V3ref,format=FF)+']'
		;message,/info,'Platescales [xSCI,ySCI] = ['+string1f(psxSCI,format=FF)+','+string1f(psySCI,format=FF)+']'
		message,/info,'XYDegree = '+string1i(xydegree)
	endif

	; The transformation comes from 5.5.3 of pre-flight SIAF aperture file, part 4: NIRSpec Proffitt (SM-12)
	;
	; Convert from GWAout to [XAN,YAN]
	;
	if verbose then forprint,xprimegwa,yprimegwa,zprimegwa
	;
	; degree i
	; XAN = SUMi SUMj GWA2XANij (xprimeGWA)^(i-j) * (yprimeGWA)^j
	;     = GWA2XAN00 + GWA2XAN01*xp * 1 + GWA2XAN11 * 1 * yp^1b, ... just like the Idl2Scis
	; YAN = SUMi SUMj GWA2YANij (xprimeGWA)^(i-j) * (yprimeGWA)^j
	;
	xp=xprimegwa
	yp=yprimegwa
	zp=zprimegwa
	XAN =  (GWA2XAN00) + $
		(GWA2XAN10)*xp   + (GWA2XAN11)      * yp + $
		(GWA2XAN20)*xp^2 + (GWA2XAN21)*xp   * yp + (GWA2XAN22)      * yp^2 + $
		(GWA2XAN30)*xp^3 + (GWA2XAN31)*xp^2 * yp + (GWA2XAN32)*xp   * yp^2 + (GWA2XAN33)      * yp^3 + $
		(GWA2XAN40)*xp^4 + (GWA2XAN41)*xp^3 * yp + (GWA2XAN42)*xp^2 * yp^2 + (GWA2XAN43)*xp   * yp^3 + (GWA2XAN44)     * yp^4 + $
		(GWA2XAN50)*xp^5 + (GWA2XAN51)*xp^4 * yp + (GWA2XAN52)*xp^3 * yp^2 + (GWA2XAN53)*xp^2 * yp^3 + (GWA2XAN54) *xp * yp^4 + (GWA2XAN55)*yp^5
	YAN = (GWA2YAN00) + $
		(GWA2YAN10)*xp   + (GWA2YAN11)      * yp + $
		(GWA2YAN20)*xp^2 + (GWA2YAN21)*xp   * yp + (GWA2YAN22)      * yp^2 + $
		(GWA2YAN30)*xp^3 + (GWA2YAN31)*xp^2 * yp + (GWA2YAN32)*xp   * yp^2 + (GWA2YAN33)      * yp^3 + $
		(GWA2YAN40)*xp^4 + (GWA2YAN41)*xp^3 * yp + (GWA2YAN42)*xp^2 * yp^2 + (GWA2YAN43)*xp   * yp^3 + (GWA2YAN44)     * yp^4 + $
		(GWA2YAN50)*xp^5 + (GWA2YAN51)*xp^4 * yp + (GWA2YAN52)*xp^3 * yp^2 + (GWA2YAN53)*xp^2 * yp^3 + (GWA2YAN54) *xp * yp^4 + (GWA2YAN55)*yp^5

	;function jwst_xyan_to_v23,xan,yan,in_degrees=in_degrees,in_radians=in_radians
		v23={n:nx,v2:v2,v3:v3,xan:xan,yan:yan,in_degrees:in_degrees,in_radians:in_radians,rcs_id:rcs_id}
	;	return,v23

	v23xyan=jwst_xyan_to_v23(XAN,YAN,/in_degrees)
	n=v23xyan.n
	if verbose then begin
		print,'----- XAN (deg), YAN (deg), V2 ("), V3 (") '
		forprint,XAN,YAN,V23xyan.v2,V23xyan.v3
	endif
	if debug then stop
	v23={n:n,XAN:reform(XAN),YAN:reform(YAN),xYAN:xYAN,si:si,apername:apername,siaf:nrs_siaf,$
			xp:xp,yp:yp,zp:zp,GWAout:GWAout,$
			GWA2XAN00:GWA2XAN00,GWA2XAN10:GWA2XAN10,GWA2XAN11:GWA2XAN11,$
			GWA2XAN20:GWA2XAN20,GWA2XAN21:GWA2XAN21,GWA2XAN22:GWA2XAN22,$
			GWA2XAN30:GWA2XAN30,GWA2XAN31:GWA2XAN31,GWA2XAN32:GWA2XAN32,GWA2XAN33:GWA2XAN33,$
			GWA2XAN40:GWA2XAN40,GWA2XAN41:GWA2XAN41,GWA2XAN42:GWA2XAN42,GWA2XAN43:GWA2XAN43,GWA2XAN44:GWA2XAN44,$
			GWA2XAN50:GWA2XAN50,GWA2XAN51:GWA2XAN51,GWA2XAN52:GWA2XAN52,GWA2XAN53:GWA2XAN53,GWA2XAN54:GWA2XAN54,GWA2XAN55:GWA2XAN55,$
			GWA2YAN00:GWA2YAN00,GWA2YAN10:GWA2YAN10,GWA2YAN11:GWA2YAN11,$
			GWA2YAN20:GWA2YAN20,GWA2YAN21:GWA2YAN21,GWA2YAN22:GWA2YAN22,$
			GWA2YAN30:GWA2YAN30,GWA2YAN31:GWA2YAN31,GWA2YAN32:GWA2YAN32,GWA2YAN33:GWA2YAN33,$
			GWA2YAN40:GWA2YAN40,GWA2YAN41:GWA2YAN41,GWA2YAN42:GWA2YAN42,GWA2YAN43:GWA2YAN43,GWA2YAN44:GWA2YAN44,$
			GWA2YAN50:GWA2YAN50,GWA2YAN51:GWA2YAN51,GWA2YAN52:GWA2YAN52,GWA2YAN53:GWA2YAN53,GWA2YAN54:GWA2YAN54,GWA2YAN55:GWA2YAN55}
	if debug then help,v23,/str
	return,v23
end
