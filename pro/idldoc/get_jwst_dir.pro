function get_jwst_dir,txt=txt,png=png,vfiles=vfiles,siaf=siaf,dat=dat,niriss=niriss
	if n_elements(niriss) ne 1 then niriss=0
	if n_elements(siaf) ne 1 then siaf=0
	if n_elements(dat) ne 1 then dat=0
	if n_elements(txt) ne 1 then txt=0
	if n_elements(png) ne 1 then png=0
	basedir='~/Box\ Sync/SPENTON/JWST/'
	rcs_id="$Id: get_jwst_dir.pro,v 1.2 2018/02/27 20:10:49 penton Exp $"
	rdir=basedir
	if txt then rdir+='txt/'
	if siaf then rdir+='siaf/'
	if png then rdir+='png/'
	if dat then rdir+='dat/'
	if niriss then rdir+='NIRISS/'
	return,rdir
end
