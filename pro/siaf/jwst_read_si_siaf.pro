
;+
;	NAME: JWST_READ_SI_SIAF
;
;	USAGE: siaf=JWST_READ_SI_SIAF(SI[,redo=redo][,verbose=verbose][,debug=debug],[version=version])
;
;	AUTHOR: Steven Penton
;
;	RCS_ID: "$Id: jwst_read_si_siaf.pro,v 1.3 2018/03/15 12:12:32 penton Exp $"
;-
function jwst_read_si_siaf,SI,redo=redo,verbose=verbose,debug=debug,version=version
	if n_elements(version) ne 1 then version=2 ; (1=Build 7.0, 2=Build 7.1)
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(redo) ne 1 then redo=0
	dir=jwst_get_dir()
	datdir=jwst_get_dir(/dat)
	txtdir=jwst_get_dir(/txt)
	siafdir=jwst_get_dir(/siaf,version=version) ; here is where the actual siaf files live
	uSI=strupcase(strtrim(SI,2))
	uSI=(uSI eq 'NRC' ? 'NIRCAM' : uSI)
	uSI=(uSI eq 'NRS' ? 'NIRSPEC' : uSI)
	sv=string1i(version)
	sver='_v'+sv
	savefile=uSI+'_SIAF'+sver+'.dat'
	if redo then begin
		if (verbose ge 1) then begin
			message,/info,'RE-CREATING the JWST SIAF for '+uSI+' and CREATING SAVEFILE as '+datdir+savefile
			message,/info,'Version = '+sv
		endif
		case version of
			1: begin
				apercsvfile=uSI+'_SIAF_APERTURES.csv'
				scidlcsvfile=uSI+'_SIAF_SCI_IDL.csv'
				names="InstrName	AperName	DDCName	AperType	AperShape	XDetSize	YDetSize	XDetRef	YDetRef	XSciSize	YSciSize	XSciRef	YSciRef	XSciScale	YSciScale	V2Ref	V3Ref	V3IdlYAngle	VIdlParity	DetSciYAngle	DetSciParity	V3SciXAngle	V3SciYAngle	XIdlVert1	XIdlVert2	XIdlVert3	XIdlVert4	YIdlVert1	YIdlVert2	YIdlVert3	YIdlVert4	UseAfterDate	Comment	Sci2IdlDeg	Sci2IdlX00	Sci2IdlX10	Sci2IdlX11	Sci2IdlX20	Sci2IdlX21	Sci2IdlX22	Sci2IdlX30	Sci2IdlX31	Sci2IdlX32	Sci2IdlX33	Sci2IdlX40	Sci2IdlX41	Sci2IdlX42	Sci2IdlX43	Sci2IdlX44	Sci2IdlX50	Sci2IdlX51	Sci2IdlX52	Sci2IdlX53	Sci2IdlX54	Sci2IdlX55	Sci2IdlY00	Sci2IdlY10	Sci2IdlY11	Sci2IdlY20	Sci2IdlY21	Sci2IdlY22	Sci2IdlY30	Sci2IdlY31	Sci2IdlY32	Sci2IdlY33	Sci2IdlY40	Sci2IdlY41	Sci2IdlY42	Sci2IdlY43	Sci2IdlY44	Sci2IdlY50	Sci2IdlY51	Sci2IdlY52	Sci2IdlY53	Sci2IdlY54	Sci2IdlY55	Idl2SciX00	Idl2SciX10	Idl2SciX11	Idl2SciX20	Idl2SciX21	Idl2SciX22	Idl2SciX30	Idl2SciX31	Idl2SciX32	Idl2SciX33	Idl2SciX40	Idl2SciX41	Idl2SciX42	Idl2SciX43	Idl2SciX44	Idl2SciX50	Idl2SciX51	Idl2SciX52	Idl2SciX53	Idl2SciX54	Idl2SciX55	Idl2SciY00	Idl2SciY10	Idl2SciY11	Idl2SciY20	Idl2SciY21	Idl2SciY22	Idl2SciY30	Idl2SciY31	Idl2SciY32	Idl2SciY33	Idl2SciY40	Idl2SciY41	Idl2SciY42	Idl2SciY43	Idl2SciY44	Idl2SciY50	Idl2SciY51	Idl2SciY52	Idl2SciY53	Idl2SciY54	Idl2SciY55"
				if (verbose ge 1) then message,/info,'READING '+siafdir+apercsvfile
				siaf_SI_aper	=READ_CSV(siafdir+apercsvfile, HEADER=ACsvHeader, N_TABLE_HEADER=1, TABLE_HEADER=CsvTableHeader,TYPES=TYPES_APER)
				if (verbose ge 1) then message,/info,'READING '+siafdir+scidlcsvfile
				siaf_SI_sci_idl	=READ_CSV(siafdir+scidlcsvfile, HEADER=SCsvHeader, N_TABLE_HEADER=1, TABLE_HEADER=CsvTableHeader,TYPES=TYPES_SCI_IDL)
				;
				; First get the variables and save to an IDL savefile
				;
				na=n_elements(ACsvHeader)
				for i=0,na-1 do begin
					str=ACsvHeader[i]+'=siaf_SI_aper.FIELD'+string1i(i+1,format='(I02)') ; +'"'
					st=execute(str)
				endfor
				na=n_elements(SCsvHeader)
				for i=0,na-1 do begin
					str=SCsvHeader[i]+'=siaf_SI_sci_idl.FIELD'+string1i(i+1,format='(I02)') ; +'"'
					st=execute(str)
				endfor
				;
				; Now create a structure for saving and returning
				;
				; First Pass, create the structure
				keywords=[ACsvHeader,SCsvHeader]
				nkey=n_elements(keywords)
				keyname=strarr(nkey+2)
				t=systime(1)-1.472341e+09
				t*=float(nkey)
				sr=randomu(t,nkey+2)

				for i=0,n_elements(sr)-1 do begin
					s=string1f(sr[i],format='(F14.12)')
					ss=strtrim(strmid(s,2,11),2)
					keyname[i]='S'+ss+'q'
				endfor

				;keyname[nkey-1]=uSI+'_SIAF'
				st=call_function('CREATE_STRUCT',"nkey",nkey,"list",keywords,name=keyname[0])
				for i=0,nkey-1 do begin
					this_keyword=replace_minus_with_underscore(keywords[i])
					str1='st={'+keyname[i+1]+' ,INHERITS '+keyname[i]+','+this_keyword+':'+this_keyword+'}'
					r=execute(str1)
				endfor
				;
				; 2nd pass, fill the structure
				st.nkey=nkey
				st.list=replace_minus_with_underscore(keywords[0:-2])
				for i=0,nkey-1 do begin
					this_keyword=replace_minus_with_underscore(keywords[i])
					str2='st.'+this_keyword+'='+this_keyword
					r=execute(str2)
				endfor
				str=uSI+"_siaf_str=st"
				r=execute(str)
				str="save,file=datdir+savefile,"+uSI+"_siaf_str,/compress,verbose=verbose"
				r=execute(str)
				heap_gc
			if debug then stop
			str="siaf_str="+uSI+"_siaf_str"
			r=execute(str)
		end
	2: begin
		;
		; Insert .xml reader for version 2 here
		;
		xml_file=uSI+'_SIAF.xml'
		help,xml_file,siafdir
		xml=read_xml(siafdir+xml_file)
		help,xml,/str
		stop
	;FGS_SIAF.xml
	;MIRI_SIAF.xml
	;NIRCam_SIAF.xml
	;NIRISS_SIAF.xml
	;NIRSpec_SIAF.xml

		end
	else: message,"Error: Version must be 1 (Build 7.0) or 2 (Build 7.1)"
	endcase
	;
	endif else begin
		if (verbose gt 1) then begin
			message,/info,'RESTORING the JWST SIAF for '+uSI+' from '+datdir+savefile
			message,/info,'Version = '+sv
		endif
		restore,datdir+savefile,verbose=(verbose ge 2)
		str="siaf_str="+uSI+"_siaf_str"
		r=execute(str)
	endelse

	return,siaf_str
end
