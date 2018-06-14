;+
; Given a DITHER for a particular Science Instrument (SI) and APERTURE NAME (APERNAME), convert this to a SAM
;
; Small Angle Maneuvers (SAMs) are always in [V2,V3] arcseconds in the FGS frame.
; This can be either FGS1 (Guider1) or FGS2 (Guider2).
;
; :Author:
;    Steven V. Penton
;
; Keywords:
;	dither: in, required, type=double array (2)
;     A dither tuple in the arcseconds in the reference frame of the given SI and APERNAME
;
;	si: in, required, string
; 		The Science Instrument, must be one of
;                NRC | Nircam
;                NRS | Nirspec
;                NIR | Niriss
;                MIR | MIRI
;                FGS
;		NOT case-sensitive
;
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

function jwst_dither_to_sam,dither,si,apername,verbose=verbose,debug=debug,redo=redo,$
	out_apername=out_apername,out_si=out_si
	if n_elements(out_si) ne 1 then out_si='FGS'
	if n_elements(out_apername) ne 1 then out_apername='FGS1_FULL_OSS'
	if n_elements(redo) ne 1 then redo=0
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(debug) ne 1 then debug=0
	rcs_id="$Id: jwst_dither_to_sam.pro,v 1.3 2018/03/15 17:38:58 penton Exp penton $"

	uSI=strupcase(strtrim(si,2))
	uSI=(uSI eq 'NRC' ? 'NIRCAM' : uSI)

	; get siaf

	siaf_info=jwst_read_si_siaf(si,verbose=verbose,debug=debug,redo=redo)
	if verbose then help,siaf_info,/str
	v00=jwst_si_xyidl_to_v23([0,0],si,apername,v2ref=0,v3ref=0,verbose=verbose)
	v00v23=v00.v23
	f00=jwst_si_v23_to_xyidl(v00.v23,out_si,out_apername,v2ref=0,v3ref=0,verbose=verbose)
	f00xy=f00.xyidl
	;
	; 1) Convert the dither from NIRCAM [X,Y] to [v2,v3]
	;
	if verbose then help,apername,out_apername
	v23=jwst_si_xyidl_to_v23(dither,uSI,apername,v2ref=0,v3ref=0,verbose=verbose)
	if verbose then message,/info,'Commanded DITHER in [V2,V3] = ['+string1f(v23.v2,format=FF)+','+string1f(v23.v3,format=FF)+']""'
	f23=jwst_si_v23_to_xyidl([v23.v2,v23.v3],out_SI,out_apername,v2ref=0,v3ref=0,verbose=verbose)
	;
	; 2) Translate the dither from [v2,v3] to FGS [X,Y]
	;
	if verbose then message,/info,'Commanded DITHER in FGS [Xidl,Yidl] = ['+string1f(f23.xidl,format=FF)+','+string1f(f23.yidl,format=FF)+']""'
	SAM_Calculated=f23.xyidl
	sam={si:si,uSI:uSI,apername:apername,dither:dither,siaf_info:siaf_info,$
		sam_calculated:SAM_Calculated,V23:v23,f23:f23,out_si:out_si,out_apername:out_apername}
	return,sam
end
