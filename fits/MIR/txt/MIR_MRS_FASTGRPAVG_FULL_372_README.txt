README for MIR_MRS_FASTGRPAVG_FULL_372.fits, hareafter referred to as Delivered_FITS_File.
- Size and location of ROIs are taken from the the MIRI SIAF excel file: MIRI_SIAF.xml
- All {X,Y} locations are given using the SIAF pixel location scheme - note this coordinate system is the same as the one used in DS9.
- Delivered_FITS_File generated from CV3 FITS file MIRM107-E-6021041029_1_493_SE_2016-01-21T04h22m18.fits, hereafter referred to as Origin_FITS_File,  located in /ifs/jwst/wit/miri/pipelinetests/testdata/
- Delivered_FITS_File is for use in testing READOUT = FASTGRPAVG
- Origin_FITS_File has FAST readout pattern
- Delivered_FITS_File has NGROUP = 372
- For each image in Delivered_FITS_File, every 5th column of the image contains reference pixels
- 1 ROI locations for this subarray, with 1 point source located in each ROI.
- Point source placed randomly in each ROI at an integer pixel location.
- Each point source in Delivered_FITS_File is a copy and pasted 3x3 cut out of a CV3 point source in Origin_FITS_File, whose center pixel is located at {X,Y} = {701, 451} in Origin_FITS_File. 
- For each image in Delivered_FITS_File, the center pixel for the injected point source(s) are located at:
	{X,Y}= {937, 953}
- Origin_FITS_File contains 5 integrations with 20 groups each. 
- Delivered_FITS_File made with the last NGROUP groups of the last integration of the Origin_FITS_File. If NGROUP > the number of frames contained in the last integration of Origin_FITS_File, then extra data was made (taken from Origin_FITS_File) to extend the integration.  
- Only the following FITS keywords are accounted for in the Delivered_FITS_File: 'FILENAME', ‘READOUT’, 'NGROUP', 'TFRAME', 'NINT', 'SUBARRAY', 'NAXIS', 'NAXIS1', 'NAXIS2', 'NAXIS3', 'INTTIME', 'EXPTIME', 'NCOLS', 'NROWS', 'BSCALE', 'BZERO', 'BITPIX’. All other keywords were directly inherited from Origin_FITS_File and have not been verified to be correct.

Delivery made by J. Brendan Hagan for OSS target acquisition testing.
Delivery Date: Thu 8 Mar 2018