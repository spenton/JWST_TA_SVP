pro nircam_dither_test,redo=redo,verbose=verbose,debug=debug
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0
	if n_elements(redo) ne 1 then redo=0

NDITHERS=4
dithers=[[6.0,-49.0],[3.0,14.0],[5.0,27.0],[1.0,-10.0]]
VISIT='V82800006012'
GSRA=80.2769
GSDEC=-69.5223

GSPA=129.078
GSX=-1.01155
GSY=46.329
GSPASCI=126.525
GSXSCI=-64.5821

GSYSCI=55.7948
;LSST=2025-001/02:30:00;

;  ACT ,02 ,FGSMAIN ,
DETECTOR='GUIDER1'
DDC='NRCALL_CNTR'
GSCOUNTS=153846

GSTHRESH=53846
GSROLLID=129.078
GSXID=-1.01155
GSYID=46.329

GSROLLSCI=126.525
GSXSCI=-64.5821
GSYSCI=55.7948
GSDEC=-69.5223

GSRA=80.2769;

;ACT ,03 ,FGSVERMAIN;

SI='NRC';
;CONFIG=NRCALL ,TARGTYPE=EXTERNAL ,DITHERID=1

NINTS=2
NGROUPS=4
FILTSHORTA='F140M'
FILTLONGA='F250M'

FILTSHORTB='F140M'
FILTLONGB='F250M'
	visit='V82800006012_2018058000847']

	;2018:058:00:36:06.362	AD	FSW	8232	Dither SAM (x, y) = 5.00572465, -49.1115370
	;2018:058:00:52:21.727	AD	FSW	8232	Dither SAM (x, y) = 3.28310867, 13.9363230
	;2018:058:01:07:55.234	AD	FSW	8232	Dither SAM (x, y) = 5.54615622, 26.8931183
	;2018:058:01:24:08.037	AD	FSW	8232	Dither SAM (x, y) = 0.797134789, -10.0182127

	sams=[[5.00572465, -49.1115370],[3.28310867, 13.9363230],[5.54615622, 26.8931183],[0.797134789, -10.0182127]]
	dithers=[[6.0,-49.0],[3.0,14.0],[5.0,27.0],[1.0,-10.0]]
	apertures='NRC'+['A1','A2','A3','A4','A5','B1','B2','B3','B4','B5']+'_FULL_OSS'
	apertures=[apertures,'NRCALL_CNTR']
	napers=n_elements(apertures)

	for a=0,napers-1 do begin
	apername=apertures[a]
	for d=0,ndithers-1 do begin
		dither=dithers[*,d]
		sam=sams[*,d]
		out=jwst_dither_to_sam(dither,'NIRCAM',apername,verbose=verbose,debug=0)
		diff=sam-out.sam_calculated
		diff2=sqrt(diff[0]^2+diff[1]^2)
		print,apername,d,dither,sam,out.sam_calculated,diff,diff2,format='(A,"	",I1,"	",9("	",F10.6))'
	endfor
	endfor

end
