function get_siaf_info,pid,rootname,shdr=shdr,verbose=verbose
	if n_elements(verbose) ne 1 then verbose=0
		spid=string1i(pid)
		rcs_id="$Id: jwst_get_siaf_info.pro,v 1.2 2018/02/27 20:43:40 penton Exp $"
		if verbose then message,/info,'Gathering SIAF information on PID = '+spid+' : '+rootname
		shdr=get_spt_hdr(pid,rootname)
		tuple=[["HOSV2CNT","V2 coordinate of aperture fiducial (arcsec)"],$
			["HOSV3CNT","V3 coordinate of aperture fiducial (arcsec)"],$
			["CMD_EXP","Commanded Exposure Time (sec)"],$
			["SAAAVOID","SAA model for SAA Avoidance (range 02-99)"],$
			["TARAQMOD","target acquisition mode (values 00, 01, 02, 03)"],$
			["PA_V3","position angle of V3-axis of HST (deg)"],$
			["APEROFFX","x comp of object offset in aperture (arcsec)"],$
			["APEROFFY","y comp of object offset in aperture (arcsec)"],$
			["ANGLESEP","ang separation of target from ref obj (arcsec)"],$
			["APEROBJ","si object aperture id"],$
			["APERSKY","si sky aperture id"],$
			["TARG_ID","SPSS target ID from proposal+target no."],$
			["OBSET_ID","observation set id"],$
			["CALIBRAT","calibrate data flag"],$
			["OBSERVTN","observation number (base 36)"],$
			["PROGRMID","program id (base 36)"],$
			["PROPOSID","PEP proposal identifier"],$
			["LINENUM","proposal logsheet line number"],$
			["FLTSWVER"," flight software version number"],$
			["OPUS_VER","data processing software system version"],$
			["APER_REF","aperture used for reference position"],$
			["DATE","date this file was written (yyyy-mm-dd)"],$
			["LAPADSTP","AD STEP"],$
			["LAPXDSTP","XD STEP"],$
			["V2APERCE","V2 APER"],$
			["V3APERCE","V3 APER"],$
			["LOMFLVDT","FOCUS LVDT STEP"],$
			["LOMFSTP","OSM1 FOCUS STEP"],$
			["LDCHVMNA","DCE HV output voltage monitor A"],$
			["LDCHVMNB","DCE HV output voltage monitor B"],$
			["LAPMPOS","LV59 APERTURE"]$
			]
			list=tuple[0,*]
			comment=tuple[1,*]
			n=n_elements(list)
			vhash=HASH()
			for k=0,n-1 do begin
				s=svppar(shdr,list[k])
				value=HASH(list[k],s)
				vhash+=value
			endfor
			return,{tuple:tuple,list:list,comment:comment,shdr:shdr,pid:pid,rootname:rootname,n:n,vhash:vhash,spid:spid}
end
