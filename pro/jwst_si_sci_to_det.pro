function jwst_si_sci_to_det,xySci,si,apername,verbose=verbose,debug=debug,$
	XSciRef=XSciRef,YSciRef=YSciRef,$
	XDetRef=XDetRef,YDetRef=YDetRef,DetSciParity=DetSciParity
	; convert from Sciector to Detence coordinates
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id='$Id: jwst_si_sci_to_det.pro,v 1.3 2018/04/10 14:23:57 penton Exp penton $'
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	xSci=reform(double(xySci[0,*]))
	ySci=reform(double(xySci[1,*]))
	n=n_elements(xSci)

	siaf=jwst_read_si_siaf(si,verbose=(verbose > 1))
	index=where(siaf.APERNAME eq uAPER,count)
	DetSciYAngle=(reform(siaf.DetSciYAngle[index]))[0]
	rDetSciYAngle=(DetSciYAngle)*!dtor
	DetSciParity=(reform(siaf.DetSciParity[index]))[0]
	;
	; Give priority to passed in XDetRef and YDetRef
	;
	XDetRef=(n_elements(XDetRef) eq 1 ? XDetRef : (reform(siaf.XDetRef[index]))[0])
	YDetRef=(n_elements(YDetRef) eq 1 ? YDetRef : (reform(siaf.YDetRef[index]))[0])
	XSciRef=(n_elements(XSciRef) eq 1 ? XSciRef : (reform(siaf.XSciRef[index]))[0])
	YSciRef=(n_elements(YSciRef) eq 1 ? YSciRef : (reform(siaf.YSciRef[index]))[0])

	psxDet=(reform(siaf.XDetSCALE[index]))[0]
	psyDet=(reform(siaf.YDetSCALE[index]))[0]

	if verbose then begin
		message,/info,'APERNAME = '+uAPER+' ('+apername+')'
		message,/info,'[XDetref,YDetref] = ['+string1f(XDetRef,format=FF)+','+string1f(YDetRef,format=FF)+']'
		message,/info,'[XSciref,YSciref] = ['+string1f(XSciRef,format=FF)+','+string1f(YSciRef,format=FF)+']'
		message,/info,'Platescales [xDet,yDet] = ['+string1f(psxDet,format=FF)+','+string1f(psyDet,format=FF)+']'
		message,/info,'DetSciYAngle = '+string1f(DetSciYAngle,format=FF)
		message,/info,'DetSciParity = '+string1i(DetSciParity)
	endif

	;
	; [XSci,YSci]=[0,0] is [XDetRef,YDetRef]
	; Note the ambiguous "missing", ")" in eqn 51. I am assuming here that it belongs at the end
	;
	;eqn 51	xDet = [XDetRef] + [DetSciParity) * ((xSci – [XSciRef]) * cos([DetSciYAngle]) – (YSci – [YSciRef]) * sin([DetSciYAngle])
	;eqn 52	yDet = [YDetRef] + [DetSciParity) * (XSci – [XSciRef]) * sin([DetSciYAngle]) + (YSci – [YSciRef]) * cos([DetSciYAngle])
	;
	; Convert to [xDet,yDet]
	;
	; From Colin's ISR:
	;
	; XSci − XSciRef = DetSciParity[(XDet−XDetRef) * cos(DetSciYAngle)+ (YDet−YDetRef) *sin(DetSciYAngle)]
	; YSci − YSciRef = − (XDet − XDetRef ) sin(DetSciYAngle) + (YDet − YDetRef ) cos(DetSciYAngle)
	; XDet − XDetRef = DetSciParity(XSci − XSciRef ) cos(DetSciYAngle) − (YSci − YSciRef ) sin(DetSciYAngle)
	; YDet − YDetRef = DetSciParity(XSci − XSciRef ) sin(DetSciYAngle) + (YSci − YSciRef ) cos(DetSciYAngle)

	dx=(xSci-XSciRef)
	dy=(ySci-YSciRef)

	xDet = XDetRef + (DetSciParity) * dx * cos(rDetSciYange) - (dy * sin(rDetSciYange)) ; Using Colin's ISR
	yDet = YDetRef + (DetSciParity) * dx * sin(rDetSciYange) + (dy * cos(rDetSciYange))

	xDet+=xSci
	yDet+=ySci

	xyDet=dblarr(2,n)
	xyDet[0,*]=xDet
	xyDet[1,*]=yDet
	xyDet={n:n,xDet:reform(xDet),yDet:reform(yDet),xyDet:xyDet,si:si,apername:apername,siaf:siaf,$
		DetSciParity:DetSciParity,DetSciYAngle:DetSciYAngle,rDetSciYAngle:rDetSciYAngle,$
		xSci:xSci,ySci:ySci,XDetRef:XDetRef,YDetRef:YDetRef,uAPER:uAPER}
	if debug then help,xyDet,/str
	return,xyDet
end
