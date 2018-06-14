;+
; Convert from NIRSpec GWA (IN) coordinates to GWA (OUT) coordinates
;
; :Author:
;    Steven V. Penton
;
; Usage:
;          GWAout=JWST_GWAIN_TO_GWAOUT(GWAin)
;
; Inputs:
;	GWAin: in, required, type=structure
;     xGWA: contains the GWA in side X coordinate(s)
;     yGWA: contains the GWA in side Y coordinate(s)
;
;	GWAout: out, structure
;		contains the output structure
;    xprimeGWA: contains the GWA out (prime) side X coordinate(s)
;    yprimeGWA: contains the GWA out (prime) side Y coordinate(s)

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
pro test_gwain_to_gwaout,apername,verbose=verbose,debug=debug,GWAnum=GWAnum
	if n_elements(GWAnum) ne 1 then GWAnum=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	; Read in the NIRSPEC TEAM TEST FILES and test
	;
	; Step 1) NRS GWAector to GWAin
	; Step 2) GWAin to GWAout (prime)
	; Step 3) GWAout to SKY
	;
	;
	; Test only  GWAin to GWAout(prime)
	;
	aperture='NRS1_FULL_OSS'
	aper2='NRS2_FULL_OSS'

	testdir=jwst_get_nrs_testdir()
	testfile=''
	readcol,testdir+testfile,xgwa,ygwa ; ...
	; fake a GWAin structure
	;
	GWAin={n:n_elements(xgwa),xgwa:xgwa,ygwa:ygwa}
	GWAout=jwst_nrs_gwain_to_gwaout(GWAin,GWAnum=GWAnum,apername=apername,$
		debug=debug,verbose=verbose)
	if verbose then forprint,xgwa,ygwa,GWAout.xprimegwa,GWAout.yprimegwa
	if debug then stop
end


function jwst_nrs_gwain_to_gwaout,GWAin,apername=apername
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(apername) ne 1 then apername='CLEAR_GWA_OTE'
	;
	; Following the CP doc convention
	;
	; prime = out
	; not-prime = in
	;
	; section 5.5.2
	;
	rcs_id="$Id$"
	xGWA=double(GWAin.xGWA)
	yGWA=double(GWAin.yGWA)
	;
	GWA=get_nrs_siaf(si='NIRSPEC',aperture=apername)
	;
	; As discussed in section 5.4
	;
	; The ZeroReadings are in [X,Y]SciRefs,
	; and the A coefficients are in [X,Y]SciScale
	;
	; The tilts are read on the fly from the telemetry, but
	; here we will use the jwst_get_gwa_xtilt and jwst_get_gwa_ytilt
	; functions.
	;
	AX=GWA.XSciScale
	AY=GWA.YSciScale
	rzeroX=GWA.XSciRef
	rzeroY=GWA.YSciRef
	;
	GWA_xtilt=jwst_get_gwa_xtilt()
	GWA_ytilt=jwst_get_gwa_ytilt()
	;
	; NOTE THAT THIS IS EXACTLY AS PRESENTED in 5.5.2
	;
	; The Ytilt goes with dthetax, the Xtilt goes with dthetay
	;
	; Check this is in Giardino, Ferruit & Oliveira (2014)
	;
	dthetax=0.5 * AX * (GWA_ytilt-rzeroX)
	dthetay=0.5 * AY * (GWA_xtilt-rzeroY)
	;
	vabs=sqrt(1.0D+(xGWA^2)+(yGWA^2))
	xzero=xGWA/vabs
	yzero=yGWA/vabs
	zzero=1.0D/vabs
	;
	x1=(-1.0D)*(xzero-(dthetay)*sqrt(1.0D-(xzero^2)-(yzero+dthetax*zzero)^2 ) ) ; (-1.0D) is the refection
	y1=(-1.0D)*(yzero+dthetax*zzero)
	z1=sqrt(1.0D-(x1^2)-(y1^2))
	;
	x2=x1+(dthetay*z1)
	y2=y1
	z2=sqrt((1.0D)-(x2^2)-(y2^2) )
	;
	x3=x2
	y3=y2-(dthetax*z2)
	z3=sqrt((1.0D)-(x3^2)-(y3^2))
	;
	xprimeGWA=x3/z3
	yprimeGWA=y3/z3
	n=n_elements(xprimeGWA)
	GWAout={n:n,xprimeGWA:xprimeGWA,yprimeGWA:yprimeGWA,$
			xGWA:xGWA,yGWA:yGWA,rcs_id:rcs_id,apername:apername,$
			x1:x1,y1:y1,z1:z1,x2:x2,y2:y2,z2:z2,x3:x3,y3:y3:z3:z3}
	return,GWAout
end
