function jwst_si_det_to_sci,xydet,si,apername,verbose=verbose,debug=debug,$
	XDetRef=XDetRef,YDetRef=YDetRef,$
	XSciRef=XSciRef,YSciRef=YSciRef,DetSciParity=DetSciParity
	; convert from detector to science coordinates
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id='$Id: jwst_si_det_to_sci.pro,v 1.3 2018/04/10 14:23:57 penton Exp penton $'
	FF='(F12.6)'
	uSI=strupcase(strtrim(si,2))
	uAPER=strupcase(strtrim(apername,2))
	if verbose then message,/info,'Looking for SIAF info for '+uSI+' + '+uAPER
	xdet=reform(double(xydet[0,*]))
	ydet=reform(double(xydet[1,*]))
	n=n_elements(xdet)

	siaf=jwst_read_si_siaf(si,verbose=(verbose > 1))
	index=where(siaf.APERNAME eq uAPER,count)
	DetSciYAngle=(reform(siaf.DetSciYAngle[index]))[0]
	rDetSciYAngle=(DetSciYAngle)*!dtor
	DetSciParity=(reform(siaf.DetSciParity[index]))[0]
	;
	; Give priority to passed in XSciRef and YSciRef
	;
	XSciRef=(n_elements(XSciRef) eq 1 ? XSciRef : (reform(siaf.XSciRef[index]))[0])
	YSciRef=(n_elements(YSciRef) eq 1 ? YSciRef : (reform(siaf.YSciRef[index]))[0])
	XDetRef=(n_elements(XDetRef) eq 1 ? XDetRef : (reform(siaf.XDetRef[index]))[0])
	YDetRef=(n_elements(YDetRef) eq 1 ? YDetRef : (reform(siaf.YDetRef[index]))[0])

	psxSci=(reform(siaf.XSCISCALE[index]))[0]
	psySci=(reform(siaf.YSCISCALE[index]))[0]

	if verbose then begin
		message,/info,'APERNAME = '+uAPER+' ('+apername+')'
		message,/info,'[XSciref,YSciref] = ['+string1f(XSciRef,format=FF)+','+string1f(YSciRef,format=FF)+']'
		message,/info,'[XDetref,YDetref] = ['+string1f(XDetRef,format=FF)+','+string1f(YDetRef,format=FF)+']'
		message,/info,'Platescales [xSci,ySci] = ['+string1f(psxSci,format=FF)+','+string1f(psySci,format=FF)+']'
		message,/info,'DetSciYAngle = '+string1f(DetSciYAngle,format=FF)
		message,/info,'DetSciParity = '+string1i(DetSciParity)
	endif

	;eqn 1	xSci = [XSciRef] + [DetSciParity]((xDet – [XDetRef]) * cos([DetSciYAngle]) +(yDet – [YDetRef]) · sin([DetSciYAngle]))
	;eqn 2	ySci = [YSciRef] - (xDet – [XDetRef]) · sin([DetSciYAngle]) + (yDet – [YDetRef] * cos([DetSciYAngle])

	;
	; [Xdet,Ydet]=[0,0] is [XSciRef,YSciRef]
	;eqn 1	xSci = [XSciRef] + [DetSciParity]((xDet – [XDetRef]) · cos([DetSciYAngle]) +(yDet – [YDetRef]) · sin([DetSciYAngle]))
	;eqn 2	ySci = [YSciRef] - (xDet – [XDetRef]) · sin([DetSciYAngle]) + (yDet – [YDetRef]) · cos([DetSciYAngle])
	;
	; Convert to [xSci,ySci]
	;
	; From Colin's ISR:
	;
	; XSci − XSciRef = DetSciParity[(XDet−XDetRef) * cos(DetSciYAngle)+ (YDet−YDetRef) *sin(DetSciYAngle)]
	; YSci − YSciRef = − (XDet − XDetRef ) sin(DetSciYAngle) + (YDet − YDetRef ) cos(DetSciYAngle)
	; XDet − XDetRef = DetSciParity(XSci − XSciRef ) cos(DetSciYAngle) − (YSci − YSciRef ) sin(DetSciYAngle)
	; YDet − YDetRef = DetSciParity(XSci − XSciRef ) sin(DetSciYAngle) + (YSci − YSciRef ) cos(DetSciYAngle)

	;eqn 1	xSci = [XSciRef] + DetSciParity *(dx * cos([DetSciYAngle])  + dy * sin([DetSciYAngle]) )
	;eqn 2	ySci = [YSciRef] -                dx * sin([DetSciYAngle])  + dy * cos([DetSciYAngle])

	dx=(xdet-XDetRef)
	dy=(ydet-YDetRef)
	xSci = XSciRef + (DetSciParity)* ( dx * cos(rDetSciYAngle) +  dy * sin(rDetSciYAngle) )
	ySci = YSciRef -                   dx * sin(rDetSciYAngle)  + dy * cos(rDetSciYAngle)
	xySci=dblarr(2,n)
	xySci[0,*]=xSci
	xySci[1,*]=ySci
	xySCI={n:n,xSci:reform(xSci),ySci:reform(ySci),xySCI:xySCI,si:si,apername:apername,siaf:siaf,$
		dx:dx,dy:dy,DetSciParity:DetSciParity,DetSciYAngle:DetSciYAngle,rDetSciYAngle:rDetSciYAngle,$
		xdet:xdet,ydet:ydet,XSciRef:XSciRef,YSciRef:YSciRef,uAPER:uAPER}
	if debug then help,xySCI,/str
	return,xySCI
end
