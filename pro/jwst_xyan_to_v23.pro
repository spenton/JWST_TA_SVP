;+
; FUNCTION: JWST_XYAN_TO_V23
;
; USAGE: V23=JWST_XYAN_TO_V23(XAN,YAN[,in_degrees=in_degrees][,in_radians=in_radians])
;-
function jwst_xyan_to_v23,xan,yan,in_degrees=in_degrees,in_radians=in_radians
	if n_elements(in_degrees) ne 1 then in_degrees=1
	if n_elements(in_radians) ne 1 then in_radians=0
		nx=n_elements(xan)
		ny=n_elements(yan)
		if nx ne ny then message,'ERROR: XAN and YAN must have the same number of elements !'
		rcs_id="$Id: jwst_xyan_to_v23.pro,v 1.1 2018/04/10 14:23:57 penton Exp penton $"
		v2=(in_degrees ? 3600.0D : 1.0D)*double(xan)
		v3=(in_degrees ? 3600.0D : 1.0D)*double(yan+0.13D)
		v23={n:nx,v2:v2,v3:v3,xan:xan,yan:yan,in_degrees:in_degrees,in_radians:in_radians,rcs_id:rcs_id}
	return,v23
end
