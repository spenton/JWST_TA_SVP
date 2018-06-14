;------------------------------------------------------------------------------
; tst_oss_nrc_swts_lwbrt2_fits.prc
; Revision 1.0
;
; PURPOSE: 
;    Procedure to setup the NIRCam SWTS to use a Long Wave A5 Bright 2 FITS 
;    image file in the Certification Lab.
;
; INPUT PARAMETERS:  NONE
;
; OUTPUT PARAMETERS: 
;   result   OPT  Script run status [SUCCESS | FAILURE]
;
; COMMAND SEQUENCES (SCS/RTS):
; CECIL SCRIPTS: 
;     itst_oss_def.h
; JAVASCRIPTS:       NONE      
; LOAD DATA:         NONE
;
; PREREQUISITES:
;     CCTS 2.2 with EGSE support.
;     NIRCam SWTS running.
;    
; CARD/OLD:            None - SWTS setup only.
; REFERENCE DOCUMENTS: NONE
;
; DISPLAY PAGES:       ITST_IES_SIM_STATUS
; ESTIMATED RUNTIME:   10 sec
; EXECUTION CATEGORY:  Normal
;
; HISTORY: 
;    23-nov-2016 kwc Initial version.
;------------------------------------------------------------------------------

PROC tst_oss_nrc_swts_lwbrt2_fits ( STRING result )

   ; Include file for global variables.

   #INCLUDE "itst_oss_def.h";

   result = "SUCCESS";

   ;---------------------------------------------------------------------------
   ; Define a FITS test image in the Certification lab.
   ; The file should be in C:\SWTS_DATA\SCD
   ;---------------------------------------------------------------------------

   #GIES_NC_EXEC ARG1="swts nircamsim a txpattern fits ta_sample_data_NRCA5_6frames.fits";
   wait ITST_CMD_METERING_WAIT;

   #GIES_NC_EXEC ARG1="swts nircamsim b txpattern fits ta_sample_data_NRCA5_6frames.fits";
   wait ITST_CMD_METERING_WAIT;

   sysalert INFO, "Procedure tst_oss_nrc_swts_lwbrt2_fits completed";
   printf "NIRCam SWTS using FITS LW BRIGHT2 Image ta_sample_data_NRCA5_6frames.fits."

ENDPROC
