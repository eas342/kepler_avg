pro plot_kep,n=n,bin=bin,phase=phase,printmin=printmin
 ;; plots Kepler data
;; n is the transit number (from 1198.0)
;; bin secifies whether to bin data
;; phase changes the x coordinate to orbital phase

;  data =
;  mrdfits('../kep_data/kplr012557548-2009166043257_llc.fits',1)
;  plot,data.time,data.sap_flux,ystyle=16,xrange=[148,152]

;  data =  mrdfits('../kep_data/kplr012557548-2012121044856_slc.fits',1)
;  data =
;  mrdfits('../kep_data/kplr012557548-2012004120508_llc.fits',1)
  ;; USE 12 for short cadence
;  filen = choose_file(searchDir='../kep_data',filetype='.fits')

  if n_elements(n) EQ 0 then n = 0
  periodP = 0.653561D
  refEpoch = 2454833D ;; Saul's reference epoch (same as Kep)

;  kepRef = 2454833.0D ;; JD reference

;  filen = '../kep_data/kplr012557548-2012121044856_slc.fits'
;  filen = '../kep_data/kplr012557548-2012151031540_slc.fits'
;  filen = '../kep_data/kplr012557548-2012179063303_slc.fits'
;  filen = '../kep_data/kplr012557548-2012179063303_llc.fits'
  filen = '../kep_data/kplr012557548-2012211050319_slc.fits'
;  filen = '../kep_data/kplr012557548-2012242122129_slc.fits'
;  filen = '../kep_data/kplr012557548-2012277125453_slc.fits'
;  filen = '../kep_data/kplr012557548-2012277125453_llc.fits'
; filen = '../kep_data/kplr012557548-2013011073258_llc.fits'


  data = mrdfits(filen,1,header)
  kepRef = double(fxpar(header,'BJDREFI')) + double(fxpar(header,'BJDREFF'))

  nstart = ceil((min(data.time + kepRef) - refEpoch)/periodP)
  subtractEpoch = (double(nstart) + double(n) ) * periodP ;; epoch to subtract

  x = (data.time + kepRef - refEpoch - subtractEpoch) * 24D
  y = data.sap_flux

  sides = where((x GT -10 and x LE -5) OR (x GT 5 and x LE 10))
  ynorm = y/median(y[sides])

  if keyword_set(phase) then begin
     x = x / (24D * periodP) - 0.04 ;; instead of an arbitrary reference, this goes to phase minimum
     myXtitle='Orbital Phase'
     myXrange = [-0.1,0.15]
  endif else begin
     myXtitle='Time (hrs)'
     myXrange= [-3,5]
  endelse
;  plot,x,ynorm,yrange=[0.95,1.05]


  myYtitle='Normalized Flux'

  if keyword_set(bin) then begin
;     binSize = 0.25 ;; hours
     binSize = 0.1 ;; hours
     binStart = -6E
     if keyword_set(phase) then begin
        binSize = binSize/(24D * periodP)
        binStart = binStart/(24D * periodP)
     endif
     nBin = 2l * round(abs(binStart) / binsize) + 1l
     binLoc = findgen(nBin) * binSize + binStart
     binWidths = fltarr(nBin) + binSize
     binStarts = binLoc - binWidths/2E
     nYpts = n_elements(ynorm)
     yBin = avg_series(x,ynorm,fltarr(nYpts) + 1E,binStarts,binWidths,stdevArr=stdevArr)
     plot,binLoc,yBin,yrange=[0.985,1.01],xrange=myXrange,$
          xtitle=myXtitle,ytitle=myMytitle,/nodata
     oploterror,binLoc,yBin,fltarr(nBin),stdevArr,/nohat
  endif else begin
     plot,x,ynorm,yrange=[0.975,1.015],xrange=myXrange,$
          xtitle=myXtitle,ytitle=myYtitle
  endelse

  if keyword_set(printmin) then begin
     if keyword_set(bin) then begin
        tconsid = where(binLoc GT myxrange[0] and binLoc LT myxrange[1])
        print,'Min flux (binned) = ',min(yBin[tconsid],/nan)
     endif else begin
        tconsid = where(x GT myxrange[0] and x LT myxrange[1])
        print,'Min flux = ',min(ynorm[tconsid],/nan)
     endelse
  endif

  showRef = date_conv(refEpoch + subtractEpoch,'FITS')
  if keyword_set(psplot) then myCharsize=0.5 else myCharsize=1.0
  legend,[showRef],/bottom,charsize=myCharsize
end
