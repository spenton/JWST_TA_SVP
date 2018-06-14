pro read_niriss_siaf_mini
	rcs_id="$Id: read_niriss_siaf_mini.pro,v 1.2 2018/02/27 20:43:40 penton Exp $"

	FF='(A,A,A,A,A,I,I,F,F,I,I,F,F,F,F,F,F,F,I,F,I,F,F,F,F,F,F,F,F,F,F,A,I,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F)'
	dir=jwst_get_dir()
	datdir=jwst_get_dir(/dat)
	txtdir=jwst_get_dir(/txt)
	siafdir=jwst_get_dir(/siaf)
	file='NIRISS_SIAF_mini.txt'
	savefile='NIRISS_SIAF_mini.dat'
	names="InstrName	AperName	DDCName	AperType	V2Ref	V3Ref'
	message,/info,'READING '+siafdir+file
	svp_readcol,siafdir+file,InstrName,AperName,DDCName,AperType,V2Ref,V3Ref
	svp_forprint,InstrName,AperName,DDCName,AperType,V2Ref,V3Ref
	stop
end

