;
; Visit24
;From guiding: guider 1, X ideal -38.944 Y ideal 28.479
; 2018:006:03:22:58.089	AD	FSW	8232	Dither SAM (x, y) = -0.133897232, -0.260026739
;
; start itst_oss_fgses_los_set ( "GUIDER1",-39.078,28.219)
; From guiding: guider 1, X ideal -39.078 Y ideal 28.219
; 2018:006:03:24:12.393	AD	FSW	8232	Dither SAM (x, y) = -0.192279290, 0.331307302
;
; start itst_oss_fgses_los_set ( "GUIDER1",-39.27,28.55)
;
; From guiding: guider 1 X ideal -39.27 Y ideal 28.55
;	2018:006:03:29:49.951	AD	FSW	8270	target location (v2, v3) = (-351.566018, -685.258708)
;	2018:006:03:29:50.954	AD	FSW	8231	TA SAM (x, y) = 0.497037285, -1.03568517
;
; detector coord (colCentroid, rowCentroid) = (834.420850, 86.2091045)
;
; last iteration diff (col, row) = (0.0266660809, 0.0180840470)
;
function jwst_t_to_a,v2a,v3a,v2t,v3t,verbose=verbose
	if n_elements(verbose) ne 1 then verbose=0

	; v2a = v2 Aperture in arcsec
	; v2t = v2 Target in arcsec

	rcs_id="$Id: jwst_t_to_a.pro,v 1.4 2018/02/27 20:53:12 penton Exp $"

	m1=(-1.0D)
	R3v2a=jwst_rot3(v2a,/in_arcsec)
	R2dv3=jwst_rot2((v3t-v3a),/in_arcsec)
	R2mv3a=jwst_rot2(m1*v3a,/in_arcsec)
	R2v3t=jwst_rot2(v3t,/in_arcsec)
	R2dv3=jwst_rot2((v3t-v3a),/in_arcsec)

	R3mv2t=jwst_rot3(m1*v2t,/in_arcsec)

	NM=R3v2a#(R2dv3#R3mv2t)
	NM2=R3v2a#(R2mv3a#(R2v3t#R3mv2t))

	if verbose then begin
		print,'--'
		print,R3v2a
		print,'--'
		print,R2dv3
		print,'--'
		print,R3mv2t
		print,'----'
		forprint,NM,NM2,NM-NM2
		print,'----'
	endif

	return,NM
end
