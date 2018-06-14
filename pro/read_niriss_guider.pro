function read_niriss_guider,visit42=visit42
	if n_elements(visit42) ne 1 then visit42=0
	si='NIRISS'
	ndir=jwst_get_dir(/niriss)
	txtdir=ndir+'Visits/'
	gfile=(visit42 ? 'guider42.txt' : 'guider.txt')
	svp_readcol,txtdir+gfile,Visit,xidl,yidl,format='(A,F,F)'

	uvisit=uniq(Visit)
	nu=n_elements(uvisit)
	uvisits=Visit[uvisit]
	vcount=fltarr(nu)
	last_idls=(penultimate_idls=fltarr(2,nu))
	for i=0,nu-1 do begin
		index=where(Visit eq uvisits[i],ct)
		vcount[i]=ct
		xidls=xidl[index]
		yidls=yidl[index]
		last_idls[*,i]=[xidls[-1],yidls[-1]]
		penultimate_idls[*,i]=[xidls[-2],yidls[-2]]
	endfor
	out={xidl:xidl,yidl:yidl,visit:visit,gfile:gfile,txtdir:txtdir,nu:nu,$
		last_idls:last_idls,penultimate_idls:penultimate_idls,si:si,visit42:visit42,$
		gfile:gfile}

	forprint,penultimate_idls[0,*],penultimate_idls[1,*],last_idls[0,*],last_idls[1,*],$
		penultimate_idls[0,*]-last_idls[0,*],penultimate_idls[1,*]-last_idls[1,*]
	return,out
end
