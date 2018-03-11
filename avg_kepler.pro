pro avg_kepler,showplot=showplot,fchoice=fchoice
;; Makes an average Kepler light curve
;; show intermediate step of baseline fitting
;; fchoice - choose a particular file for the Average Kepler transit

;;Find all short cadence files
cd,current=currentd
fl = file_search(currentd+'/../kep_data/*_slc.fits')
if n_elements(fchoice) NE 0 then begin
   if fchoice LT 0 or fchoice GT n_elements(fl) - 1l then begin
      print,'Invalid file choice'
      return
   endif else begin
      tempfl = fl
      fl = tempfl[fchoice]
   endelse
endif

nfiles = n_elements(fl)

;; reference epoch
myref = 2454833.039D ;; actually from Saul's light curve minimum
myP = 0.6535538D ;; Van Werkhoven period

fitSize = 0.28D
transL = 0.12
transR = 0.15
npoly = 2
sigRef = 8E

for i=0l,nfiles-1l do begin
   d = mrdfits(fl[i],1,header) ;; data
   kepRef = double(fxpar(header,'BJDREFI')) + double(fxpar(header,'BJDREFF'))
   t = d.time + kepRef - myref ;; BJD from ref
   tperiod = (t / myP); mod 1.0D
   minT = ceil(min(tperiod))
   maxT = floor(max(tperiod))
   nTrans = maxT - minT + 1l
   y = d.sap_flux
   for j=0l,nTrans-1l do begin
      cent = double(j) + double(minT)
      localP = where(tperiod GT cent - fitSize  and $
                     tperiod LE cent + fitSize)
      outP = where((tperiod GT cent - fitsize and $
                    tperiod LE cent - transL) OR $
                   (tperiod GT cent + transR and $
                    tperiod LE cent + fitsize))
      if localP EQ [-1] then begin
         goodp = [-1]
      endif else begin
         xtemp = tperiod[localP] - cent
         ytemp = y[localP]
         xout = tperiod[outP] - cent
         yout = y[outP]
;      ypoly = ev_robust_poly(xout,double(yout),npoly)
         goodp = where(abs(yout - median(yout)) LT robust_sigma(yout) * 8E)
      endelse
      if goodp NE [-1] then begin
         xout = xout[goodp]
         yout = yout[goodp]
         ypoly = poly_fit(xout,double(yout),npoly)
         ymod = poly(xtemp,ypoly)
         yNorm = ytemp / ymod
         if keyword_set(showplot) then begin
            plot,xtemp,ytemp,ystyle=16
;         oplot,xout,yout,color=mycol('yellow')
            oplot,xtemp,ymod,color=mycol('red')
            stop
         endif
         if n_elements(masterX) EQ 0 then begin
            masterx = xtemp
            masterY = yNorm
         endif else begin
            masterx = [masterx,xtemp]
            mastery = [mastery,yNorm]
         endelse
      endif else begin
;         print,"No Valid points found! Returning"
;         return
      endelse
   endfor
   
endfor

save,masterx,mastery,filename='output/avg_kep/avg_kep.sav'
end
