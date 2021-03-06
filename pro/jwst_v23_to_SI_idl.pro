function jwst_v23_to_SI_idl,v23,SI=SI,APERTURE=APERTURE,out=out,v2ref=v2ref,v3ref=v3ref
	rcs_id="$Id"
	if n_elements(SI) ne 1 then SI='NIRISS' ; We'll improve this later
	if n_elements(APERTURE) ne 1 then APERTURE='NIRISS_TA'
	;
	;Convert v2, v3 to SI Ideal
	;Convert the destination v2, v3 coordinates into SI Ideal coordinates (xIdl and yIdl).
	;
	; V23  = [v2,v3] in arcseconds
	;
	; Output is SI Idl (IDL), also in arcseconds
	;
	; This is equations 41 & 42 in JWST-STScI-003289
	; eqn 41	xIdl = (VIdlParity)((v2rcos(rV3IdlYAngle)) � (v3rsin(rV3IdlYAngle)))
	; eqn 42	yIdl = v2rsin(rV3IdlYAngle) + v3rcos(rV3IdlYAngle)

	;
	; Step 1:
	; 	Get the V3IdlYAngle from the SIAF file, and convert to radians
	;
	si_info=jwst_get_si_info_from_siaf(SI)
	index=where(si_info.apername eq 'APERTURE')

	V3IdlYangle=si_info.V3IdlYangle[index]
	rV3IdlYangle=V3IdlYangle*!dtor
	;
	; Step 2:
	;	Get VIdlParity from the siaf
	VIdlParity=si_info.VIdlParity[index]
	;
	; Step 3:
	;	Get [Xref,Yref]
	;
	v2ref=si_info.v2ref[index]
	v3ref=si_info.v3ref[index]
	v2r=(v2-v2Ref)
	v3r=(v3-v3Ref)
	;
	; Step 4
	;	Get Xidl,Yidl
	;
	xIdl = (VIdlParity) * ((v2r * cos(rV3IdlYAngle)) � (v3r * sin(rV3IdlYAngle)))
	yIdl = v2r *sin(rV3IdlYAngle) + v3r *cos(rV3IdlYAngle)
	if verbose then begin
		message,/info,'[V2ref,V3ref]='+string1f(V2Ref,format=FF)+','+string1f(V3Ref,format=FF)+']'
		message,/info,'V3IDLYANGE = '+string1f(v3IdlYAngle,format=FF)'
		message,/info,'VIDLPARITY = '+string1i(VIDLPARITY)
	endif

	xy=[xIDL,yIDL]
	out=(VIdlParity:VIdlParity,V3IdlYangle:V3IdlYangle,rV3IdlYangle:rV3IdlYangle,$
		v2ref:v2ref,v3ref:v3ref,xIdl:xIdl,yIdl:yIdl,xy:xy,SI:SI,APERTURE:APERTURE,$
		si_info:si_info)

	return,xy

end


