function jwst_get_si_info_from_siaf,SI,verbose=verbose
	if n_elements(verbose) ne 1 then verbose=0
	rcs_id="$Id: jwst_get_si_info_from_siaf.pro,v 1.2 2018/02/27 20:43:40 penton Exp $"
	uSI=strupcase(strtrim(SI,2))
	siaf=jwst_read_si_siaf(uSI,verbose=verbose)
	out={rcs_id:rcs_id,siaf:siaf,SI:SI}
	return,out
end
