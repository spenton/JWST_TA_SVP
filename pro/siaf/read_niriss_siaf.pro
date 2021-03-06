function read_niriss_siaf,redo=redo,verbose=verbose
	if n_elements(verbose) ne 1 then verbose=1
	if n_elements(redo) ne 1 then redo=1
	rcs_id="$Id: read_niriss_siaf.pro,v 1.3 2018/02/27 20:43:40 penton Exp $"
	;FF='(A,A,A,A,A,I,I,F,F,I,I,F,F,F,F,F,F,F,I,F,I,F,F,F,F,F,F,F,F,F,F,A,I,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F)'
	if redo then begin
		dir=jwst_get_dir()
		datdir=jwst_get_dir(/dat)
		txtdir=jwst_get_dir(/txt)
		siafdir=jwst_get_dir(/siaf)
		file='NIRISS_SIAF.txt'
		apercsvfile='NIRISS_SIAF_APERTURES.csv'
		scidlcsvfile='NIRISS_SIAF_SCI_IDL.csv'
		savefile='NIRISS_SIAF.dat'
		names="InstrName	AperName	DDCName	AperType	AperShape	XDetSize	YDetSize	XDetRef	YDetRef	XSciSize	YSciSize	XSciRef	YSciRef	XSciScale	YSciScale	V2Ref	V3Ref	V3IdlYAngle	VIdlParity	DetSciYAngle	DetSciParity	V3SciXAngle	V3SciYAngle	XIdlVert1	XIdlVert2	XIdlVert3	XIdlVert4	YIdlVert1	YIdlVert2	YIdlVert3	YIdlVert4	UseAfterDate	Comment	Sci2IdlDeg	Sci2IdlX00	Sci2IdlX10	Sci2IdlX11	Sci2IdlX20	Sci2IdlX21	Sci2IdlX22	Sci2IdlX30	Sci2IdlX31	Sci2IdlX32	Sci2IdlX33	Sci2IdlX40	Sci2IdlX41	Sci2IdlX42	Sci2IdlX43	Sci2IdlX44	Sci2IdlX50	Sci2IdlX51	Sci2IdlX52	Sci2IdlX53	Sci2IdlX54	Sci2IdlX55	Sci2IdlY00	Sci2IdlY10	Sci2IdlY11	Sci2IdlY20	Sci2IdlY21	Sci2IdlY22	Sci2IdlY30	Sci2IdlY31	Sci2IdlY32	Sci2IdlY33	Sci2IdlY40	Sci2IdlY41	Sci2IdlY42	Sci2IdlY43	Sci2IdlY44	Sci2IdlY50	Sci2IdlY51	Sci2IdlY52	Sci2IdlY53	Sci2IdlY54	Sci2IdlY55	Idl2SciX00	Idl2SciX10	Idl2SciX11	Idl2SciX20	Idl2SciX21	Idl2SciX22	Idl2SciX30	Idl2SciX31	Idl2SciX32	Idl2SciX33	Idl2SciX40	Idl2SciX41	Idl2SciX42	Idl2SciX43	Idl2SciX44	Idl2SciX50	Idl2SciX51	Idl2SciX52	Idl2SciX53	Idl2SciX54	Idl2SciX55	Idl2SciY00	Idl2SciY10	Idl2SciY11	Idl2SciY20	Idl2SciY21	Idl2SciY22	Idl2SciY30	Idl2SciY31	Idl2SciY32	Idl2SciY33	Idl2SciY40	Idl2SciY41	Idl2SciY42	Idl2SciY43	Idl2SciY44	Idl2SciY50	Idl2SciY51	Idl2SciY52	Idl2SciY53	Idl2SciY54	Idl2SciY55"
		message,/info,'READING '+siafdir+apercsvfile
		siaf_niriss_aper = READ_CSV(siafdir+apercsvfile, HEADER=ACsvHeader, N_TABLE_HEADER=1, TABLE_HEADER=CsvTableHeader,TYPES=TYPES_APER)
		siaf_niriss_sci_idl=READ_CSV(siafdir+scidlcsvfile, HEADER=SCsvHeader, N_TABLE_HEADER=1, TABLE_HEADER=CsvTableHeader,TYPES=TYPES_SCI_IDL)
		; rw 333 @ NOON
		;
		; First get the variables and save to an IDL savefile
		;
		na=n_elements(ACsvHeader)
		for i=0,na-1 do begin
			str=ACsvHeader[i]+'=siaf_niriss_aper.FIELD'+string1i(i+1,format='(I02)') ; +'"'
			st=execute(str)
			;print,i,str,ST
		endfor
		na=n_elements(SCsvHeader)
		for i=0,na-1 do begin
			str=SCsvHeader[i]+'=siaf_niriss_sci_idl.FIELD'+string1i(i+1,format='(I02)') ; +'"'
			st=execute(str)
			;print,i,str,ST
		endfor
		; Now create a structure for saving and returning
		;
		; First Pass, create the structure
		keywords=[ACsvHeader,SCsvHeader]
		nkey=n_elements(keywords)
		st=call_function('CREATE_STRUCT',"nkey",nkey,"list",keywords,name=keywords[0])
		keywords=[keywords,'NIRISS_SIAF']
		for i=0,nkey-1 do begin
			; destroy the obsolete structure
			delvar,dummy
			this_keyword=replace_minus_with_underscore(keywords[i])
			sname=replace_minus_with_underscore(keywords[i+1])
			str1='st={'+sname+' ,INHERITS '+this_keyword+','+this_keyword+':'+this_keyword+'}'
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
		help,st,/str
		niriss_siaf_str=st
		save,file=datdir+savefile,niriss_siaf_str,/compress,verbose=verbose
		heap_gc
	endif else begin
		restore,datdir+savefile,verbose=verbose
	endelse
	return,niriss_siaf_str
end

