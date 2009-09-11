;
; 9 September 2009.
;
; Prep Quicklook EIT images for use with the Helioviewer Project
;
; Gets today's date (UTC) and looks for new EIT files once every 15 minutes.
;
; Steps taken: Load FITS data, prep + calibrate image, write JP2
; file.  No intermediate data written
;
; sudo /sbin/mount 129.165.40.191:/Volumes/eit /Users/ireland/SOHO/EIT
; from a X11 term
;
; USER - set the start date and end date of the range of EIT data you
;        are interested in.  The program will then create JP2 files in
;        the correct directory structure for use with the Helioviewer
;        project.
;
;
progname = 'eit_prep2jp2_auto1' ; the program name
nickname = 'EIT' ; instrument nickname
;
; Get the observer details
;
oidm = JI_HV_OIDM2(nickname)
;
; Storage locations
;
storage = JI_HV_STORAGE()
;
; Infinite loop
;
repeat begin
;
; Get today's date in UT
;
   get_utc,utc,/ecs,/date_only
   date_start = utc
   date_end   = utc
   print,' '
   print,progname + ': Processing... ' + utc
;
; Create a simple hvs structure that carries date information
;
   hvs = {observatory:'',instrument:'',detector:'',measurement:'',$
          yy:strmid(utc,0,4),mm:strmid(utc,5,2),dd:strmid(utc,8,2)}
;
; Create the subdirectory for the log file
;
   logfile_directory = JI_WRITE_LIST_JP2_MKDIR(hvs,storage.hvs_location)
;
; ===================================================================================================
;
; Start timing
;
   s0 = systime(1)
;
; The filename for a file which will contain the locations of the
; JP2 log files
;
   filename = nickname + '_' + ji_txtrep(date_start,'/','_') + '-' + ji_txtrep(date_end,'/','_') + '.log'
;
; Create the location of the listname
;
   listname = logfile_directory + filename + '.prepped.txt'
;
; Write direct to JP2 from FITS
;
   prepped = JI_EIT_WRITE_HVS(date_start,date_end,storage.jp2_location)
;
; Save the log file
;
   wrt_ascii,prepped,listname
;
; Timing stats
;
   n1 = n_elements(prepped)
   s1 = systime(1)
   print,' '
   print,progname + ': most recent file processed = '+prepped[n_elements(prepped)-1]   
   print,'Total number of files ',n1
   print,'Total time taken ',s1-s0
   print,'Average time taken ',(s1-s0)/float(n1)
   print,'Last run completed at ',systime(0)
   print,'Fixed wait time of 15 minutes now progressing.'
;
; Wait 15 minutes before looking for more data
;
   wait,15*60

endrep until 1 eq 0

end