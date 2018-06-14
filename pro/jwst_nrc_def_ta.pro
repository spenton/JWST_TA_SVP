function jwst_nrc_def_ta,verbose=verbose,debug=debug
	if n_elements(debug) ne 1 then debug=0
	if n_elements(verbose) ne 1 then verbose=0

; //-------------------------------------------------------------------------
; //   NRCDEFTA
; //
; //   COMPATIBILITY:  ISIM IC14
; //
; //   PURPOSE:
; //      A function that will return the config. and wheel positions used
; //      for target acquisition
; //
; //   SP PARAMETERS:     NONE
; //
; //   INPUT PARAMETERS:
; //      sci_subarray    OPT  Science subarray (Time Series only)
; //      ta_subarray     REQ  Name of the Target Acq. subarray
; //
; //   SHARED PARAMETERS: NONE
; //
; //   GLOBAL PARAMETERS: NONE
; //
; //   OUTPUT PARAMETERS:
; //      mask_aperture   Aperture of the coronagraphic mask
; //      ta_aperture     Aperture name
; //      ta_config       SCA configuration
; //      ta_filterArray  Filter names Array [longA, longB, shortA, shortB]
; //      ta_pupilArray   Pupil names Array [longA, longB, shortA, shortB]
; //      ta_v2Ref        V2 reference pixel (arc sec)
; //      ta_v3Ref        V3 reference pixel (arc sec)
; //
; //   RETURN VALUE:
; //                        Boolean true if the activity was successful
; //                        Boolean false if any part of the activity failed
; //
; //   HISTORY:
; //      10-jul-2007  mma  Initial version
; //      19-sep-2008  mma  Revised TA Use case
; //      15-apr-2016  mma  TA III
; //      10-feb-2017  mma  Added LOS, Time-Series Grism, Time-Series TA
; //                        Using subarray name for the switch statement
; //      20-jul-2017  mma  Revised V2, V3 refs. (Mar 2017 SIAF)
; //      20-oct-2017  mma  Revised V2, V3 refs. (Oct 2017 SIAF)
; //                        Reference point is center of TA subarray
; //                        Added science subarray parameter
; //                        for Time Series TA - Lien 6067
; //-------------------------------------------------------------------------
; function nrcdefta(ta_subarray, sci_subarray, &ta_config,
;                     &ta_filterArray, &ta_pupilArray, &ta_aperture,
;                     &mask_aperture, &ta_v2Ref, &ta_v3Ref) {

	rcs_id="$Id: jwst_nrc_def_ta.pro,v 1.2 2018/03/15 17:38:58 penton Exp $"

sub={'NRC_subarray', name:'',type:'',ta_aperture:"",mask_aperture:"",sci_aperture:"N/A",$
	ta_filterarray:strarr(4),$
	ta_pupilArrray:strarr(4),$
	ta_v2Ref:0.0D,ta_v3Ref:0.0D}

nrc_info=strarr(sub,30)

;    switch (ta_subarray) {
;       //**********************
;       //*   Coronagraphy TA  *
;       //**********************
	nrc_info[0:19].type='Coronagraphy TA'

	nrc_info[0].name="SUBNDA210R"
		nrc_info[0].ta_aperture = "NRCA2_FULL_OSS" ;
		nrc_info[0].mask_aperture = "NRCA2_TAMASK210R"
		nrc_info[0].ta_config = "NRCA2" ;
		nrc_info[0].ta_filterArray = ["NULL", "NULL", "F210M", "NULL"] ;
		nrc_info[0].ta_pupilArray = ["NULL", "NULL", "MASKRND", "NULL"] ;
		nrc_info[0].ta_v2Ref = 134.943885 ;
		nrc_info[0].ta_v3Ref = -412.893753 ;

		nrc_info[1].name="SUBFSA210R"
		nrc_info[1].ta_aperture = "NRCA2_FULL_OSS" ;
		nrc_info[1].mask_aperture = "NRCA2_FSTAMASK210R"
		nrc_info[1].ta_config = "NRCA2" ;
		nrc_info[1].ta_filterArray = ["NULL", "NULL", "F210M", "NULL"] ;
		nrc_info[1].ta_pupilArray = ["NULL", "NULL", "MASKRND", "NULL"] ;
		nrc_info[1].ta_v2Ref = 130.518619 ;
		nrc_info[1].ta_v3Ref = -412.924356 ;

		nrc_info[2].name="SUBNDB210R"
		nrc_info[2].ta_aperture = "NRCB1_FULL_OSS" ;
		nrc_info[2].mask_aperture = "NRCB1_TAMASK210R"
		nrc_info[2].ta_config = "NRCB1" ;
		nrc_info[2].ta_filterArray = ["NULL", "NULL", "NULL", "F210M"] ;
		nrc_info[2].ta_pupilArray = ["NULL", "NULL", "NULL", "MASKRND"] ;
		nrc_info[2].ta_v2Ref = -134.744707 ;
		nrc_info[2].ta_v3Ref = -409.304161;

		nrc_info[3].name="SUBNDA335R"
		nrc_info[3].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[3].mask_aperture = "NRCA5_TAMASK335R"
		nrc_info[3].ta_config = "NRCALONG" ;
		nrc_info[3].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[3].ta_pupilArray = ["MASKRND", "NULL", "NULL", "NULL"] ;
		nrc_info[3].ta_v2Ref = 117.539784 ;
		nrc_info[3].ta_v3Ref = -413.037640 ;

		nrc_info[4].name="SUBFSA335R"
		nrc_info[4].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[4].mask_aperture = "NRCA5_FSTAMASK335R"
		nrc_info[4].ta_config = "NRCALONG" ;
		nrc_info[4].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[4].ta_pupilArray = ["MASKRND", "NULL", "NULL", "NULL"] ;
		nrc_info[4].ta_v2Ref = 113.047508 ;
		nrc_info[4].ta_v3Ref = -413.065000 ;

		nrc_info[5].name="SUBNDB335R"
		nrc_info[5].ta_aperture = "NRCB5_FULL_OSS" ;
		nrc_info[5].mask_aperture = "NRCB5_TAMASK335R" ;
		nrc_info[5].ta_config = "NRCBLONG" ;
		nrc_info[5].ta_filterArray = ["NULL", "F335M", "NULL", "NULL"] ;
		nrc_info[5].ta_pupilArray = ["NULL", "MASKRND", "NULL", "NULL"] ;
		nrc_info[5].ta_v2Ref = -117.512994 ;
		nrc_info[5].ta_v3Ref = -409.519273 ;

		nrc_info[6].name="SUBNDA430R"
		nrc_info[6].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[6].mask_aperture = "NRCA5_TAMASK430R" ;
		nrc_info[6].ta_config = "NRCALONG" ;
		nrc_info[6].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[6].ta_pupilArray = ["MASKRND", "NULL", "NULL", "NULL"] ;
		nrc_info[6].ta_v2Ref = 97.323866;
		nrc_info[6].ta_v3Ref = -413.131749;

		nrc_info[7].name="SUBFSA430R"
		nrc_info[7].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[7].mask_aperture = "NRCA5_FSTAMASK430R" ;
		nrc_info[7].ta_config = "NRCALONG" ;
		nrc_info[7].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[7].ta_pupilArray = ["MASKRND", "NULL", "NULL", "NULL"] ;
		nrc_info[7].ta_v2Ref = 92.830319 ;
		nrc_info[7].ta_v3Ref = -413.142578 ;

		nrc_info[8].name="SUBNDB430R"
		nrc_info[8].ta_aperture = "NRCB5_FULL_OSS" ;
		nrc_info[8].mask_aperture = "NRCB5_TAMASK430R" ;
		nrc_info[8].ta_config = "NRCBLONG" ;
		nrc_info[8].ta_filterArray = ["NULL", "F335M", "NULL", "NULL"] ;
		nrc_info[8].ta_pupilArray = ["NULL", "MASKRND", "NULL", "NULL"] ;
		nrc_info[8].ta_v2Ref = -97.388601 ;
		nrc_info[8].ta_v3Ref = -409.590220 ;

		nrc_info[9].name="SUBNDASWBL"
		nrc_info[9].ta_aperture = "NRCA4_FULL_OSS" ;
		nrc_info[9].mask_aperture = "NRCA4_TAMASKSWB" ;
		nrc_info[9].ta_config = "NRCA4" ;
		nrc_info[9].ta_filterArray = ["NULL", "NULL", "F210M", "NULL"] ;
		nrc_info[9].ta_pupilArray = ["NULL", "NULL", "MASKBAR", "NULL"] ;
		nrc_info[9].ta_v2Ref = 77.494231 ;
		nrc_info[9].ta_v3Ref = -412.350388 ;

		nrc_info[10].name="SUBNDASWBS"
		nrc_info[10].ta_aperture = "NRCA4_FULL_OSS" ;
		nrc_info[10].mask_aperture = "NRCA4_TAMASKSWBS" ;
		nrc_info[10].ta_config = "NRCA4" ;
		nrc_info[10].ta_filterArray = ["NULL", "NULL", "F210M", "NULL"] ;
		nrc_info[10].ta_pupilArray = ["NULL", "NULL", "MASKBAR", "NULL"] ;
		nrc_info[10].ta_v2Ref = 57.306872 ;
		nrc_info[10].ta_v3Ref = -412.389179 ;

		nrc_info[11].name="SUBFSASWB"
		nrc_info[11].ta_aperture = "NRCA4_FULL_OSS" ;
		nrc_info[11].mask_aperture = "NRCA4_FSTAMASKSWB" ;
		nrc_info[11].ta_config = "NRCA4" ;
		nrc_info[11].ta_filterArray = ["NULL", "NULL", "F210M", "NULL"] ;
		nrc_info[11].ta_pupilArray = ["NULL", "NULL", "MASKBAR", "NULL"] ;
		nrc_info[11].ta_v2Ref = 67.405600 ;
		nrc_info[11].ta_v3Ref = -412.378899 ;

		nrc_info[12].name="SUBNDBSWBL"
		nrc_info[12].mask_aperture = "NRCB3_TAMASKSWB" ;
		nrc_info[12].ta_aperture = "NRCB3_FULL_OSS" ;
		nrc_info[12].ta_config = "NRCB3" ;
		nrc_info[12].ta_filterArray = ["NULL", "NULL", "NULL", "F210M"] ;
		nrc_info[12].ta_pupilArray = ["NULL", "NULL", "NULL", "MASKBAR"] ;
		nrc_info[12].ta_v2Ref = -39.682843 ;
		nrc_info[12].ta_v3Ref = -409.496535 ;

		nrc_info[13].name="SUBNDBSWBS"
		nrc_info[13].ta_aperture = "NRCB3_FULL_OSS" ;
		nrc_info[13].mask_aperture = "NRCB3_TAMASKSWBS" ;
		nrc_info[13].ta_config = "NRCB3" ;
		nrc_info[13].ta_filterArray = ["NULL", "NULL", "NULL", "F210M"] ;
		nrc_info[13].ta_pupilArray = ["NULL", "NULL", "NULL", "MASKBAR"] ;
		nrc_info[13].ta_v2Ref = -57.297841 ;
		nrc_info[13].ta_v3Ref = -409.512643 ;

		nrc_info[14].name="SUBNDALWBL"
		nrc_info[14].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[14].mask_aperture = "NRCA5_TAMASKLWBL" ;
		nrc_info[14].ta_config = "NRCALONG" ;
		nrc_info[14].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[14].ta_pupilArray = ["MASKBAR", "NULL", "NULL", "NULL"] ;
		nrc_info[14].ta_v2Ref = 57.148408 ;
		nrc_info[14].ta_v3Ref = -412.659300 ;

		nrc_info[15].name="SUBNDALWBS"
		nrc_info[15].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[15].mask_aperture = "NRCA5_TAMASKLWB" ;
		nrc_info[15].ta_config = "NRCALONG" ;
		nrc_info[15].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[15].ta_pupilArray = ["MASKBAR", "NULL", "NULL", "NULL"] ;
		nrc_info[15].ta_v2Ref = 39.473484 ;
		nrc_info[15].ta_v3Ref = -412.614749 ;

		nrc_info[16].name="SUBFSALWB"
		nrc_info[16].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[16].mask_aperture = "NRCA5_FSTAMASKLWB" ;
		nrc_info[16].ta_config = "NRCALONG" ;
		nrc_info[16].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[16].ta_pupilArray = ["MASKBAR", "NULL", "NULL", "NULL"] ;
		nrc_info[16].ta_v2Ref = 48.316779 ;
		nrc_info[16].ta_v3Ref = -412.644162 ;

		nrc_info[17].name="SUBNDBLWBL"
		nrc_info[17].ta_aperture = "NRCB5_FULL_OSS" ;
		nrc_info[17].mask_aperture = "NRCB5_TAMASKLWBL" ;
		nrc_info[17].ta_config = "NRCBLONG" ;
		nrc_info[17].ta_filterArray = ["NULL", "F335M", "NULL", "NULL"] ;
		nrc_info[17].ta_pupilArray = ["NULL", "MASKBAR", "NULL", "NULL"] ;
		nrc_info[17].ta_v2Ref = -57.080511 ;
		nrc_info[17].ta_v3Ref = -409.760660 ;

		nrc_info[18].name="SUBNDBLWBS"
		nrc_info[18].ta_aperture = "NRCB5_FULL_OSS" ;
		nrc_info[18].mask_aperture = "NRCB5_TAMASKLWB" ;
		nrc_info[18].ta_config = "NRCBLONG" ;
		nrc_info[18].ta_filterArray = ["NULL", "F335M", "NULL", "NULL"] ;
		nrc_info[18].ta_pupilArray = ["NULL", "MASKBAR", "NULL", "NULL"] ;
		nrc_info[18].ta_v2Ref = -77.250834 ;
		nrc_info[18].ta_v3Ref = -409.712441 ;

;       //*********************
;       //*   LOS jitter TA   *
;       //*********************

		nrc_info[20:21].type='LOS Jitter TA'
		nrc_info[20].name"SUB64FP1A"
		nrc_info[20].ta_aperture = "NRCA3_FULL_OSS" ;
		nrc_info[20].mask_aperture = "NA" ;
		nrc_info[20].sci_perture = "NRCA3_FP1_SUB64"
		nrc_info[20].ta_config = "NRCA3" ;
		nrc_info[20].ta_filterArray = ["NULL", "NULL", "F212N", "NULL"] ;
		nrc_info[20].ta_pupilArray = ["NULL", "NULL", "CLEAR", "NULL"] ;
		nrc_info[20].ta_v2Ref = 69.541661 ;
		nrc_info[20].ta_v3Ref = -515.657609 ;

		nrc_info[21].name"SUB64FP1B"
		nrc_info[21].ta_aperture = "NRCB4_FULL_OSS" ;
		nrc_info[21].mask_aperture = "NA" ;
		nrc_info[21].sci_aperture = "NRCB4_FP1_SUB64"
		nrc_info[21].ta_config = "NRCB4" ;
		nrc_info[21].ta_filterArray = ["NULL", "NULL", "NULL", "F212N"] ;
		nrc_info[21].ta_pupilArray = ["NULL", "NULL", "NULL", "CLEAR"] ;
		nrc_info[21].ta_v2Ref = -77.677421 ;
		nrc_info[21].ta_v3Ref = -500.897378 ;

;       //****************************
;       //*   Grism Time-Series TA   *
;       //****************************
		nrc_info[22].type='Grism Time-Series TA'
		nrc_info[22].name"SUB32TATSGRISM"
		nrc_info[22].ta_aperture = "NRCA5_FULL_OSS" ;
		nrc_info[22].mask_aperture = "NA" ;
		nrc_info[22].sci_aperture = "NRCA5_TAGRISMTS32"
		nrc_info[22].ta_config = "NRCALONG" ;
		nrc_info[22].ta_filterArray = ["F335M", "NULL", "NULL", "NULL"] ;
		nrc_info[22].ta_pupilArray = ["CLEAR", "NULL", "NULL", "NULL"] ;
		nrc_info[22].ta_v2Ref = 70.844963 ;
		nrc_info[22].ta_v3Ref = -541.844075 ;

;       //**********************
;       //*   Time-Series TA   *
;       //**********************
		nrc_info[23].type='Time Series TA'
		nrc_info[23].name="SUB32TATS"
		nrc_info[23].ta_aperture = "NRCB5_FULL_OSS" ;
		nrc_info[23].mask_aperture = "NA" ;
		nrc_info[23].ta_config = "NRCBLONG" ;
		nrc_info[23].ta_filterArray = ["NULL", "F335M", "NULL", "NULL"] ;
		nrc_info[23].ta_pupilArray = ["NULL", "CLEAR", "NULL", "NULL"] ;

		nrc_inf[24:28].type='SCI_SUBARRARY'
		nrc_info[24].name="FULL"
		nrc_info[24].sci_aperture = "NRCB5_FULLP"
		nrc_info[24].ta_v2Ref= -133.352480 ;
		nrc_info[24].ta_v3Ref= -446.930663 ;

		nrc_info[25].name="SUB400P"
		nrc_info[25].sci_aperture = "NRCB5_SUB400P"
		nrc_info[25].ta_v2Ref= -146.012309 ;
		nrc_info[25].ta_v3Ref= -432.204111 ;

		nrc_info[26].name="SUB160P"
		nrc_info[26].sci_aperture = "NRCB5_SUB160P"
		nrc_info[26].ta_v2Ref= -149.649394 ;
		nrc_info[26].ta_v3Ref= -428.482786 ;

		nrc_info[27].name="SUB64P"
		nrc_info[27].sci_aperture = "NRCB5_SUB64P"
		nrc_info[27].ta_v2Ref= -151.046632 ;
		nrc_info[27].ta_v3Ref= -427.408175 ;

		nrc_info[28].name="DEFAULT":
		nrc_info[28].sci_aperture = "NRCB5_FULLP"
		nrc_info[28].ta_v2Ref= -133.352480 ;
		nrc_info[28].ta_v3Ref= -446.930663 ;

	return,nrc_info
end
