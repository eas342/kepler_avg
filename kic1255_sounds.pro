pro kic1255_sounds,detrend=detrend,simulate=simulate,$
                   interpol=interpol
;; Makes a wav file of the time series as a possible outreach activity/idea
;; detrend - do a piecewise de-trend of the time series
;; simulate - do simulated sounds

  if n_elements(n) EQ 0 then n = 0
  periodP = 0.653561D
  refEpoch = 2454833D ;; Saul's reference epoch (same as Kep)

;  kepRef = 2454833.0D ;; JD reference

;  filen = '../kep_data/kplr012557548-2012121044856_slc.fits'
;  filen = '../kep_data/kplr012557548-2012151031540_slc.fits'
;  filen = '../kep_data/kplr012557548-2012179063303_slc.fits'
  filen = '../kep_data/kplr012557548-2012179063303_llc.fits'
;  filen = '../kep_data/kplr012557548-2012211050319_slc.fits'
;  filen = '../kep_data/kplr012557548-2012242122129_slc.fits'
;  filen = '../kep_data/kplr012557548-2012277125453_slc.fits'
;  filen = '../kep_data/kplr012557548-2012277125453_llc.fits'
; filen = '../kep_data/kplr012557548-2013011073258_llc.fits'


  data = mrdfits(filen,1,header)
  kepRef = double(fxpar(header,'BJDREFI')) + double(fxpar(header,'BJDREFF'))

  nstart = ceil((min(data.time + kepRef) - refEpoch)/periodP)
  subtractEpoch = (double(nstart) + double(n) ) * periodP ;; epoch to subtract

  x = (data.time + kepRef - refEpoch - subtractEpoch) / periodP
  y = data.sap_flux

  plot,x,y,ystyle=16
  if keyword_set(detrend) then begin
     blocksize = 300l
     nFull = n_elements(y)
     nblocks = ceil(float(nFull)/float(blocksize))
     yModelFull = fltarr(nFull)
     for i=0l,nblocks-1l do begin
        bstart = i * blocksize
        bEnd = min([bstart + blocksize-1l,nFull-1l])
        rPoly = ev_robust_poly(x[bstart:bend],y[bstart:bend],3)
        ymodelFull[bstart:bend] = poly(x[bstart:bend],rPoly)
        oplot,x[bstart:bend],yModelFull[bstart:bend],color=mycol('red')
     endfor

     oplot,x,ymodelFull,color=mycol('red')
     y = y/ymodelFull
     plot,x,y,ystyle=16
  endif

  goodp = where(finite(y))
  ysub = y[goodp] - median(y)
  ysound = long(ysub * 1E4)
;; Repeat
  if keyword_set(detrend) then begin
     ysound = ysound * (-1E4)
  endif else ysound = ysound * (-1E)


;; Interpolate long term sequences
if keyword_set(interpol) then begin
;  yrep = rebin(ysound,n_elements(ysound) * 700l)
  yrep = rebin(ysound,n_elements(ysound) * 50l)
endif else begin
;; Repeats multiple times
   nreps = 1l
   for i=0l,nreps-1l do begin
      if i EQ 0 then yrep = ysound else begin
         yrep = [yrep,ysound]
      endelse
   endfor
   
endelse
;yrep = fft(yrep)
;xsound = findgen(2l^17)
;ysound = sin(xsound * 2E * !PI/float(44100) * 60E * 5E) * 1E4
;yrep = ysound
;stop
  if keyword_set(simulate) then begin
     yrep = (randomu(1,1E5) - 0.5E) * 1E4
     outName = 'sounds/simulated_sounds.wav'
  endif else begin
     outName = 'sounds/kic1255_sounds.wav'
  endelse
;  write_wav,'sounds/kic1255_sounds.wav',ysound,500E
;  write_wav,'sounds/kic1255_sounds.wav',yrep,6E4

  write_wav,outName,yrep,44100

end
