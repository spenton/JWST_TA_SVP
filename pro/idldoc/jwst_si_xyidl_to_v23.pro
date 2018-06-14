function jwst_si_xyidl_to_v23,xyidl,si,apername,verbose=verbose,debug=debug,$
	v2ref=v2ref,v3ref=v3ref,vIdlparity=vIdlparity
	; This should now work with vectors
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id='$Id: jwst_si_xyidl_to_v23.pro,v 1.4 2018/03/15 15:22:37 penton Exp $'
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	xidl=reform(double(xyidl[0,*]))
	yidl=reform(double(xyidl[1,*]))
	n=n_elements(xidl)

	siaf=jwst_read_si_siaf(si,verbose=(verbose > 1))
	index=where(siaf.APERNAME eq uAPER,count)
	v3IdlYAngle=(reform(siaf.V3IDLYANGLE[index]))[0]
	rv3IdlYAngle=(v3IdlYAngle)*!dtor
	VIDLPARITY=(reform(siaf.VIDLPARITY[index]))[0]
	;
	; Give priority to passed in V2Ref and V3Ref
	;
	V2Ref=(n_elements(V2Ref) eq 1 ? V2Ref : (reform(siaf.V2Ref[index]))[0])
	V3Ref=(n_elements(V3Ref) eq 1 ? V3Ref : (reform(siaf.V3Ref[index]))[0])

	psV2=(reform(siaf.XSCISCALE[index]))[0]
	psV3=(reform(siaf.YSCISCALE[index]))[0]

	if verbose then begin
		message,/info,'APERNAME = '+uAPER+' ('+apername+')'
		message,/info,'[V2ref,V3ref] = ['+string1f(V2Ref,format=FF)+','+string1f(V3Ref,format=FF)+']'
		message,/info,'Platescales [V2,V3] = ['+string1f(psV2,format=FF)+','+string1f(psV3,format=FF)+']'
		message,/info,'V3IDLYANGLE = '+string1f(v3IdlYAngle,format=FF)
		message,/info,'VIDLPARITY = '+string1i(VIDLPARITY)
	endif

	;
	; [XIdl,YIdl]=[0,0] is [V2Ref,V3Ref]
	;
	;eqn 7	v2 = [V2Ref] + [VIdlParity]xIdl * cos([V3IdlYAngle]) + yIdl * sin([V3IdlYAngle])
	;eqn 8	v3 = [V3Ref] - [VIdlParity]xIdl * sin([V3IdlYAngle]) + yIdl * cos([V3IdlYAngle])
	;
	; Convert to [v2,v3]
	;
	v2 = V2Ref + (VIdlParity*xIdl * cos(rV3IdlYAngle)) + (yIdl * sin(rV3IdlYAngle))
	v3 = V3Ref - (VIdlParity*xIdl * sin(rV3IdlYAngle)) + (yIdl * cos(rV3IdlYAngle))
	forprint,xidl,yidl,-(VIdlParity*xIdl * sin(rV3IdlYAngle))+ (yIdl * cos(rV3IdlYAngle))

	v23={n:n,v2:reform(v2),v3:reform(v3),v23:[v2,v3],si:si,apername:apername,siaf:siaf,$
		VIDLPARITY:VIDLPARITY,v3IdlYAngle:v3IdlYAngle,rv3IdlYAngle:rv3IdlYAngle,$
		xidl:xidl,yidl:yidl,v2ref:v2ref,v3ref:v3ref,uAPER:uAPER}
	if debug then help,v23,/str
	return,v23[0]
end
