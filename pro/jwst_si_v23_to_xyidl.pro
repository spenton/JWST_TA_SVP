function jwst_si_v23_to_xyidl,v23,si,apername,verbose=verbose,debug=debug,$
	v2ref=v2ref,v3ref=v3ref,vIdlparity=VIdlparity
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id='$Id: jwst_si_v23_to_xyidl.pro,v 1.4 2018/04/10 14:23:57 penton Exp penton $'
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	dv2=double(reform(v23[0,*]))
	dv3=double(reform(v23[1,*]))

	siaf=jwst_read_si_siaf(si,verbose=(verbose > 1))
	index=where(siaf.APERNAME eq uAPER,count)
	v3IdlYAngle=(reform(siaf.V3IDLYANGLE[index]))[0]
	rv3IdlYAngle=(v3IdlYAngle)*!dtor
	VIDLPARITY=(reform(siaf.VIDLPARITY[index]))[0]
	if verbose then begin
		message,/info,'APERNAME  = '+uAPER
		message,/info,'[V2ref,V3ref] = ['+string1f(V2Ref,format=FF)+','+string1f(V3Ref,format=FF)+']'
		message,/info,'[XDetref,YDetref] = ['+string1f(XDetRef,format=FF)+','+string1f(YDetRef,format=FF)+']'
		message,/info,'[XSciref,YSciref] = ['+string1f(XSciRef,format=FF)+','+string1f(YSciRef,format=FF)+']'

		message,/info,'V3IDLYANGE = '+string1f(v3IdlYAngle,format=FF)
		message,/info,'VIDLPARITY = '+string1i(VIDLPARITY)
	endif
	V2Ref=(n_elements(V2ref) eq 1 ? V2Ref : reform(siaf.V2Ref[index]))
	V3Ref=(n_elements(V3ref) eq 1 ? V3Ref : reform(siaf.V3Ref[index]))
	XDetRef=(n_elements(XDetRef) eq 1 ? XDetRef : (reform(siaf.XDetRef[index]))[0])
	YDetRef=(n_elements(YDetRef) eq 1 ? YDetRef : (reform(siaf.YDetRef[index]))[0])
	XSciRef=(n_elements(XSciRef) eq 1 ? XSciRef : (reform(siaf.XSciRef[index]))[0])
	YSciRef=(n_elements(YSciRef) eq 1 ? YSciRef : (reform(siaf.YSciRef[index]))[0])

	xIdl = VIdlParity*(((dv2 - v2Ref)*cos(rv3IDLYAngle)) - ((dv3 - V3Ref)*sin(rv3IDLYAngle)))
	yIdl = (dv2 - V2Ref)*sin(rv3IDLYAngle) + (dv3 - V3Ref)*cos(rv3IDLYAngle)
	xyidl={xIdl:reform(xIDL),yIDL:reform(yIDL),xyIDL:[XIdl,YIdl],si:si,apername:apername,siaf:siaf,$
		VIDLPARITY:VIDLPARITY,v3IdlYAngle:v3IdlYAngle,rv3IdlYAngle:rv3IdlYAngle,v2:dv2,v3:dv3,$
		v2ref:v2ref,v3ref:v3ref}
	if debug then help,xyidl,/str
	return,xyidl
end
