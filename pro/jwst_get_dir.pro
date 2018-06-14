; docformat = 'rst'

;+
; Set the directory base for SVP's JWST IDL code
;
; :Author:
;    Steven V. Penton
;
; :Copyright:
;    None
;
; :Requires:
;    IDL 8+
;
; :Examples:
;    For example::
;
;    IDL> jwst_base_dir=jwst_get_dir(verbose=verbose,nircam=nircam)
;
; :Keywords:
;
;    fgs : in, optional, type=boolean
;       if set, set directory to base+'FGS/'
;    nircam : in, optional, type=boolean
;       if set, set directory to base+'NIRCAM/'
;    niriss : in, optional, type=boolean
;       if set, set directory to base+'NIRISS/'
;    nirspec : in, optional, type=boolean
;       if set, set directory to base+'NIRSPEC/'
;    miri : in, optional, type=boolean
;       if set, set directory to base+'MIRI/'
;    siaf : in, optional, type=boolean
;       if set, set directory to base+'SIAF/'
;    png : in, optional, type=boolean
;       if set, add "png/" to the end of the output directory
;    txt : in, optional, type=boolean
;       if set, add "txt/" to the end of the output directory
;    dat : in, optional, type=boolean
;       if set, add "dat/" to the end of the output directory
;    vfiles : in, optional, type=boolean
;       if set, add "vfiles/" to the end of the output directory
;    verbose : in, optional, type=boolean
;       if set, print informational messages
;    debug : in, optional, type=boolean
;       if set, output debugging information
;    version : in, optional, type=boolean
;       if set, determines which siaf file to read (1=Build 7.0, 2=Build 7.1)
;       default, version=2
;-
function jwst_get_dir,txt=txt,png=png,vfiles=vfiles,siaf=siaf,dat=dat,$
	fgs=fgs,niriss=niriss,nircam=nircam,miri=miri,nirspec=nirspec,$
	verbose=verbose,debug=debug,version=version
	if n_elements(version) ne 1 then version=2 ; (1=Build 7.0, 2=Build 7.1)
	if n_elements(miri) ne 1 then miri=0
	if n_elements(fgs) ne 1 then fgs=0
	if n_elements(nircam) ne 1 then nircam=0
	if n_elements(nirspc) ne 1 then nirspec=0
	if n_elements(niriss) ne 1 then niriss=0
	if n_elements(siaf) ne 1 then siaf=0
	if n_elements(dat) ne 1 then dat=0
	if n_elements(txt) ne 1 then txt=0
	if n_elements(png) ne 1 then png=0
	if n_elements(vfiles) ne 1 then vfiles=0
	basedir='~/Box\ Sync/SPENTON/JWST/'
	rcs_id="$Id: jwst_get_dir.pro,v 1.3 2018/04/10 14:23:57 penton Exp penton $"
	rdir=basedir
	case 1 of
		niriss : rdir+='NIRISS/'
		nircam : rdir+='NIRCAM/'
		miri   : rdir+='MIRI/'
		nirspec: rdir+='NIRSPEC/'
		fgs    : rdir+='FGS/'
		else :
	endcase
	;
	; Preference is alphabetical
	;
	case 1 of
		dat : rdir+='dat/'
		png : rdir+='png/'
		siaf : rdir=basedir+'siaf/'+(version eq 2 ? 'xml/' : 'csv/')
		txt : rdir+='txt/'
		vfiles : rdir+='vfiles/'
	else :
		endcase
	return,rdir
end
