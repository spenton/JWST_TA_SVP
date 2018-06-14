pro make_jwst
	rcs_id="$Id: make_jwst.pro,v 1.1 2018/02/15 19:57:05 penton Exp $"
	dir='~/Desktop/JWST'
	pushd,dir
	jwst=15
	nhst=167
	read_jpeg,'full_web.jpg',full
	full_x=350
	full_y=258
	f_nhst=fltarr(3,full_x,full_y)
	f_jwst=fltarr(3,full_x,full_y)
	f0=reform(full[0,*,*])
	f1=reform(full[1,*,*])
	f2=reform(full[2,*,*])
	nhst_y=full_y*float(nhst)/full_x
	jwst_y=full_y*float(jwst)/full_x
	help,nhst_y,jwst_y,f0,f1,f2

	f_nhst[0,*,*]=frebin(frebin(f0,nhst,nhst_y),full_x,full_y)
	f_nhst[1,*,*]=frebin(frebin(f1,nhst,nhst_y),full_x,full_y)
	f_nhst[2,*,*]=frebin(frebin(f2,nhst,nhst_y),full_x,full_y)

	f_jwst[0,*,*]=frebin(frebin(f0,jwst,jwst_y),full_x,full_y)
	f_jwst[1,*,*]=frebin(frebin(f1,jwst,jwst_y),full_x,full_y)
	f_jwst[2,*,*]=frebin(frebin(f2,jwst,jwst_y),full_x,full_y)

	write_jpeg,'jwst.jpg',f_jwst,/true
	write_jpeg,'nhst.jpg',f_nhst,/true

	popd
end
