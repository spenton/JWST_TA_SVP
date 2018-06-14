;+
; Convert from NIRSpec DET (OUT) coordinates to GWA ([V2,V3]) coordinates
;
; :Author:
;    Steven V. Penton
;
; Usage:
;          GWAin=JWST_DET_TO_GWAin(xyDET)
;
; Inputs:
;	xyDET: in, required, type=structure
;     xDET: contains the DET X coordinate(s)
;     yDET: contains the DET Y coordinate(s)
;
;	GWAin: out, structure
;		contains the output structure

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

pro test_det_to_gwain,apername,verbose=verbose,debug=debug,detnum=detnum
	if n_elements(detnum) ne 1 then detnum=1
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	; Read in the NIRSPEC TEAM TEST FILES and test
	;
	; Step 1) NRS DETector to GWAin
	; Step 2) GWAin to GWAout (prime)
	; Step 3) GWAout to SKY
	;
	testdir=jwst_get_nrs_testdir
	testfile=''
	readcol,testdir+testfile,v1,v2 ; ...

	aperture='NRS1_FULL_OSS'
	aper2='NRS2_FULL_OSS'
	for t=0,nt -1 do begin
		print,'---'
		xy=testxy[*,t]
		GWAinin=jwst_nrs_det_to_gwain(xyDET,detnum,aper1,debug=debug,verbose=verbose)
		print,'DET',xyDET
		print,'GWAin',GWAin
		print,'---'
	endfor
	stop
end
function jwst_get_DET_xtilt
		DET_xtilt=0.0
		return,DET_xtilt
end
function jwst_get_DET_ytilt
		DET_ytilt=0.0
		return,DET_ytilt
end

function jwst_nrs_det_to_gwain,xyDET
		;
		; Following the CP doc convention
		;
		; prime = out
		; not-prime = in
		;
		rcs_id="$Id: jwst_nrs_det_to_DET.pro,v 1.1 2018/04/10 14:23:57 penton Exp penton $"
		;
		; section 5.5.2
		;
		xDET=xyDET.xDET
		yDET=xyDET.yDET
		;
		DET=get_nrs_siaf(si='NIRSPEC',aperture='DET')
		AX=DET.XSciScale
		AY=DET.YSciScale
		rzeroX=DET.XSciRef
		rzeroY=DET.YSciRef
		;
		DET_xtilt=jwst_get_DET_xtilt()
		DET_ytilt=jwst_get_DET_ytilt()
		dthetax=0.5 * AX * (DET_ytilt-rzeroX)
		dthetay=0.5 * AY * (DET_xtilt-rzeroY)
		;
		vabs=sqrt(1.0D+(xDET^2)+(yDET^2))
		xzero=xDET/vabs
		yzero=yDET/vabs
		zzero=1.0D/vabs
		;
		x1=(-1.0D)(xzero- (dthetay)*sqrt(1.0D-(xzero^2)-(yzero+dthetax*zzero)^2 ) ) ; (-1.0D) is the refection
		y1=(-1.0D)(yzero+(dthetax*zzero)
		z1=sqrt(1.0D-(x1^2)-(y1^2))
		;
		x2=x1+(dthetay*z1)
		y2=y1
		z2=sqrt( (1.0D)-(x2^2)-(y2^2) )
		;
		;
		x3=x2
		y3=y2-(dthetax*z2)
		z3=sqrt((1.0D)-(x3^2) -(y3^2))
		;
		xDET_prime=x3/z3
		yDET_prime=y3/z3
		xyDETout={xDET_prime:xDET_prime,yDET_prime:yDET_prime,xDET:xDET,yDET:yDET,rcs_id:rcs_id}
		return,xyDETout
end
function jwst_nrs_det_to_gwain,xyDET,apername,verbose=verbose,debug=debug,$
	XSciRef=XSciRef,YSciRef=YSciRef,XDetRef=XDetRef,YDetRef=YDetRef,$
	IdlSciParity=IdlSciParity,V2ref=V2ref,V3ref=V3ref
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	; convert from DET to GWA coordinates
	; xyDETprime is in direction cosines AFTER bouncing off the DET
	; GWA is in arcseconds
	;
	; XAN = SUMi SUMj DET2XANij (xDET)^(i-j) * (yDET)^j
	;
	; YAN = SUMi SUMj DET2YANij (xDET)^(i-j) * (yDET)^j
	;
	; DET2XAN, DET2YAN are
	rcs_id='$Id$'
	si='NRS' ; NIRspec
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	xSci=reform(double(xySci[0,*]))
	ySci=reform(double(xySci[1,*]))
	n=n_elements(xSci)

	siaf=jwst_read_si_siaf(si,verbose=(verbose > 1))
	index=where(siaf.APERNAME eq uAPER,count)
	;
	Sci2IdlX00=(double(reform(siaf.Sci2IdlX00[index])))[0]
	Sci2IdlX10=(double(reform(siaf.Sci2IdlX10[index])))[0]
	Sci2IdlX11=(double(reform(siaf.Sci2IdlX11[index])))[0]
	Sci2IdlX20=(double(reform(siaf.Sci2IdlX20[index])))[0]
	Sci2IdlX21=(double(reform(siaf.Sci2IdlX21[index])))[0]
	Sci2IdlX22=(double(reform(siaf.Sci2IdlX22[index])))[0]
	Sci2IdlX30=(double(reform(siaf.Sci2IdlX30[index])))[0]
	Sci2IdlX31=(double(reform(siaf.Sci2IdlX31[index])))[0]
	Sci2IdlX32=(double(reform(siaf.Sci2IdlX32[index])))[0]
	Sci2IdlX33=(double(reform(siaf.Sci2IdlX33[index])))[0]
	Sci2IdlX40=(double(reform(siaf.Sci2IdlX40[index])))[0]
	Sci2IdlX41=(double(reform(siaf.Sci2IdlX41[index])))[0]
	Sci2IdlX42=(double(reform(siaf.Sci2IdlX42[index])))[0]
	Sci2IdlX43=(double(reform(siaf.Sci2IdlX43[index])))[0]
	Sci2IdlX44=(double(reform(siaf.Sci2IdlX44[index])))[0]
	Sci2IdlX50=(double(reform(siaf.Sci2IdlX50[index])))[0]
	Sci2IdlX51=(double(reform(siaf.Sci2IdlX51[index])))[0]
	Sci2IdlX52=(double(reform(siaf.Sci2IdlX52[index])))[0]
	Sci2IdlX53=(double(reform(siaf.Sci2IdlX53[index])))[0]
	Sci2IdlX54=(double(reform(siaf.Sci2IdlX54[index])))[0]
	Sci2IdlX55=(double(reform(siaf.Sci2IdlX55[index])))[0]
	;
	Sci2IdlY00=(double(reform(siaf.Sci2IdlY00[index])))[0]
	Sci2IdlY10=(double(reform(siaf.Sci2IdlY10[index])))[0]
	Sci2IdlY11=(double(reform(siaf.Sci2IdlY11[index])))[0]
	Sci2IdlY20=(double(reform(siaf.Sci2IdlY20[index])))[0]
	Sci2IdlY21=(double(reform(siaf.Sci2IdlY21[index])))[0]
	Sci2IdlY22=(double(reform(siaf.Sci2IdlY22[index])))[0]
	Sci2IdlY30=(double(reform(siaf.Sci2IdlY30[index])))[0]
	Sci2IdlY31=(double(reform(siaf.Sci2IdlY31[index])))[0]
	Sci2IdlY32=(double(reform(siaf.Sci2IdlY32[index])))[0]
	Sci2IdlY33=(double(reform(siaf.Sci2IdlY33[index])))[0]
	Sci2IdlY40=(double(reform(siaf.Sci2IdlY40[index])))[0]
	Sci2IdlY41=(double(reform(siaf.Sci2IdlY41[index])))[0]
	Sci2IdlY42=(double(reform(siaf.Sci2IdlY42[index])))[0]
	Sci2IdlY43=(double(reform(siaf.Sci2IdlY43[index])))[0]
	Sci2IdlY44=(double(reform(siaf.Sci2IdlY44[index])))[0]
	Sci2IdlY50=(double(reform(siaf.Sci2IdlY50[index])))[0]
	Sci2IdlY51=(double(reform(siaf.Sci2IdlY51[index])))[0]
	Sci2IdlY52=(double(reform(siaf.Sci2IdlY52[index])))[0]
	Sci2IdlY53=(double(reform(siaf.Sci2IdlY53[index])))[0]
	Sci2IdlY54=(double(reform(siaf.Sci2IdlY54[index])))[0]
	Sci2IdlY55=(double(reform(siaf.Sci2IdlY55[index])))[0]

	;
	; Give priority to passed in XDetRef and YDetRef
	;
	XDetRef=(n_elements(XDetRef) eq 1 ? XDetRef : (reform(siaf.XDetRef[index]))[0])
	YDetRef=(n_elements(YDetRef) eq 1 ? YDetRef : (reform(siaf.YDetRef[index]))[0])
	XSciRef=(n_elements(XSciRef) eq 1 ? XSciRef : (reform(siaf.XSciRef[index]))[0])
	YSciRef=(n_elements(YSciRef) eq 1 ? YSciRef : (reform(siaf.YSciRef[index]))[0])

	psxSci=(reform(siaf.XSciSCALE[index]))[0]
	psySci=(reform(siaf.YSciSCALE[index]))[0]

	V2ref=(reform(siaf.V2ref[index]))[0]
	V3ref=(reform(siaf.V3ref[index]))[0]

	xydegree=(reform(siaf.Sci2IdlDeg[index]))[0]

	if verbose then begin
		message,/info,'APERNAME = '+uAPER+' ('+apername+')'
		message,/info,'[XDetRef,YDetRef] = ['+string1f(XDetRef,format=FF)+','+string1f(YDetRef,format=FF)+']'
		message,/info,'[XSciref,YSciref] = ['+string1f(XSciRef,format=FF)+','+string1f(YSciRef,format=FF)+']'
		message,/info,'[V2ref,V3ref] = ['+string1f(V2ref,format=FF)+','+string1f(V3ref,format=FF)+']'
		message,/info,'Platescales [xSCI,ySCI] = ['+string1f(psxSCI,format=FF)+','+string1f(psySCI,format=FF)+']'
		message,/info,'XYDegree = '+string1i(xydegree)
	endif

	;
	; [XSci,YSci]=[0,0] is [XDetRef,YDetRef]
	; Note the ambiguous "missing", ")" in eqn 51. I am assuming here that it belongs at the end
	;
	;	eqn 3	dx = xSci - [XSciRef]
	;	eqn 4	dy = ySci - [YSciRef]
	;	eqn 5	xIdl = (Sci2IdlXCoef00) + (Sci2IdlXCoef10)*dx +(Sci2IdlXCoef11)*dy + (Sci2IdlXCoef20)*dx^2 + (Sci2IdlXCoef21)*dx*dy + (Sci2IdlXCoef22)*dy^2 + $
	;	(Sci2IdlXCoef30)*dx^3 + (Sci2IdlXCoef31)*dx^2*dy + (Sci2IdlXCoef32)*dx*dy^2 +(Sci2IdlXCoef33)*dy3 + $
	;	(Sci2IdlXCoef40)*dx^4 + (Sci2IdlXCoef41)*dx^3 * dy + (Sci2IdlXCoef42)*dx^2 * dy^2 + (Sci2IdlXCoef43)*dx * dy3 + (Sci2IdlXCoef44)*dy^4+$
	;	(Sci2IdlXCoef50)*dx^5 + (Sci2IdlXCoef51)*dx^4dy + (Sci2IdlXCoef52)*dx^3 * dy^2 + (Sci2IdlXCoef53)*dx^2 * dy^3 + (Sci2IdlXCoef54)*dx * dy^4 + (Sci2IdlXCoef55)*dy^5
	;	eqn 6	yIdl = (Sci2IdlYCoef00) + (Sci2IdlYCoef10)*dx +(Sci2IdlYCoef11)*dy + (Sci2IdlYCoef20)*dx^2 + (Sci2IdlYCoef21)*dx*dy + (Sci2IdlYCoef22)*dy^2 + $
	;	(Sci2IdlYCoef30)*dx^3 + (Sci2IdlYCoef31)*dx^2*dy + (Sci2IdlYCoef32)*dx*dy^2 +(Sci2IdlYCoef33)*dy3 + $
	;	(Sci2IdlYCoef40)*dx^4 + (Sci2IdlYCoef41)*dx^3 * dy + (Sci2IdlYCoef42)*dx^2 * dy^2 + (Sci2IdlYCoef43)*dx * dy3 + (Sci2IdlYCoef44)*dy^4+$
	;	(Sci2IdlYCoef50)*dx^5 + (Sci2IdlYCoef51)*dx^4dy + (Sci2IdlYCoef52)*dx^3 * dy^2 + (Sci2IdlYCoef53)*dx^2 * dy^3 + (Sci2IdlYCoef54)*dx * dy^4 + (Sci2IdlYCoef55)*dy^5
	;
	; Convert to [xIdl,yIdl]
	;
	;
	dx=double(xSci-XSciRef) ;/psxSCI ; these are still in pixels
	dy=double(ySci-YSciRef) ;/psySCI ; these are still in pixels
	if verbose then forprint,xSci,ySci,dx,dy
	;
	; degree i
	;	XIdl= ∑∑Sci2IdlCoefXi,j (XSci−XSciRef)^(i−j) * (YSci−YSciRef)^j
	;	i=1 j=0 degree i
	;  YIdl= ∑∑Sci2IdlCoefYi,j (XSci−XSciRef)^(i−j)  * (YSci−YSciRef)^j
	;	i=1 j=0
	;for i=1,xydegree do begin
	;	for j=0,(xydegree-1) do begin
	;
	;	endfor
	;endfor
	dxIdl =  (Sci2IdlX00) + $
		(Sci2IdlX10)*dx   + (Sci2IdlX11)      * dy + $
		(Sci2IdlX20)*dx^2 + (Sci2IdlX21)*dx   * dy + (Sci2IdlX22)      * dy^2 + $
		(Sci2IdlX30)*dx^3 + (Sci2IdlX31)*dx^2 * dy + (Sci2IdlX32)*dx   * dy^2 + (Sci2IdlX33)      * dy^3 + $
		(Sci2IdlX40)*dx^4 + (Sci2IdlX41)*dx^3 * dy + (Sci2IdlX42)*dx^2 * dy^2 + (Sci2IdlX43)*dx   * dy^3 + (Sci2IdlX44)     * dy^4 + $
		(Sci2IdlX50)*dx^5 + (Sci2IdlX51)*dx^4 * dy + (Sci2IdlX52)*dx^3 * dy^2 + (Sci2IdlX53)*dx^2 * dy^3 + (Sci2IdlX54) *dx * dy^4 + (Sci2IdlX55)*dy^5
	dyIdl = (Sci2IdlY00) + $
		(Sci2IdlY10)*dx   + (Sci2IdlY11)      * dy + $
		(Sci2IdlY20)*dx^2 + (Sci2IdlY21)*dx   * dy + (Sci2IdlY22)      * dy^2 + $
		(Sci2IdlY30)*dx^3 + (Sci2IdlY31)*dx^2 * dy + (Sci2IdlY32)*dx   * dy^2 + (Sci2IdlY33)      * dy^3 + $
		(Sci2IdlY40)*dx^4 + (Sci2IdlY41)*dx^3 * dy + (Sci2IdlY42)*dx^2 * dy^2 + (Sci2IdlY43)*dx   * dy^3 + (Sci2IdlY44)     * dy^4 + $
		(Sci2IdlY50)*dx^5 + (Sci2IdlY51)*dx^4 * dy + (Sci2IdlY52)*dx^3 * dy^2 + (Sci2IdlY53)*dx^2 * dy^3 + (Sci2IdlY54) *dx * dy^4 + (Sci2IdlY55)*dy^5

	xIdl=dxIdl ;*dx
	yIdl=dyIdl ;*dy

	xyIdl=dblarr(2,n)
	xyIdl[0,*]=xIdl ;+v2ref
	xyIdl[1,*]=yIdl ;+v3ref
	if verbose then begin
		print,'-----'
		forprint,xSci,ySci,dx,dy,dxIdl,dyIdl,xIdl,yIdl
	endif
	if debug then stop
	xyIdl={n:n,xIdl:reform(xIdl),yIdl:reform(yIdl),xyIdl:xyIdl,si:si,apername:apername,siaf:siaf,$
			dxIdl:reform(dxIdl),dyIdl:reform(dyIdl),V2REF:V2REF,V3REF:V3REF,dx:dx,dy:dy,$
			psxSci:psxSci,psySci:psySci,$
			xSci:xSci,ySci:ySci,XSciRef:XSciRef,YSciRef:YSciRef,XDetRef:XDetRef,YDetRef:YDetRef,uAPER:uAPER,$
			Sci2IdlX00:Sci2IdlX00,Sci2IdlX10:Sci2IdlX10,Sci2IdlX11:Sci2IdlX11,$
			Sci2IdlX20:Sci2IdlX20,Sci2IdlX21:Sci2IdlX21,Sci2IdlX22:Sci2IdlX22,$
			Sci2IdlX30:Sci2IdlX30,Sci2IdlX31:Sci2IdlX31,Sci2IdlX32:Sci2IdlX32,Sci2IdlX33:Sci2IdlX33,$
			Sci2IdlX40:Sci2IdlX40,Sci2IdlX41:Sci2IdlX41,Sci2IdlX42:Sci2IdlX42,Sci2IdlX43:Sci2IdlX43,Sci2IdlX44:Sci2IdlX44,$
			Sci2IdlX50:Sci2IdlX50,Sci2IdlX51:Sci2IdlX51,Sci2IdlX52:Sci2IdlX52,Sci2IdlX53:Sci2IdlX53,Sci2IdlX54:Sci2IdlX54,Sci2IdlX55:Sci2IdlX55}
	if debug then help,xyIdl,/str
	return,xyIdl
end