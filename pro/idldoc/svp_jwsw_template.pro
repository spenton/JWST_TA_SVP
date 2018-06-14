; docformat = 'rst'

;+
; Generic template for SVPcode procedure. Insert the purpose of the routine here..
;
; :Author:
;    Steven V. Penton
;
; :Copyright:
;    None
;
; :Requires:
;    IDL 8+
;
; :Keywords:
;    var1_req : in, required, type=string
;       root of directory hierarchy to document
;    var_qpt : in, optional, type=string
;       directory to place output
;
;    verbose : in, optional, type=boolean
;       if set, print informational messages
;    debug : in, optional, type=boolean
;       if set, output debugging information
;-
pro SVPcode,verbose=verbose,debug=debug
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0

	rcs_id="$Id$"
end
