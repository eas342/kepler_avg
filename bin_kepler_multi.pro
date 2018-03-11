pro bin_kepler_multi,zoomIn=zoomIn,targ=targ
;; bins together all the phased, baseline-removed Kepler data
;; zoomIn - zooms in to show the pre-transit flux increase
;; targ - Specify target, otherwise, it looks at Kepler SC data for
;;        KIC 12557548b
;; 

if n_elements(targ) EQ 0 then targ='KIC1255'
case targ of
   'KIC1255': begin
      restore,'output/avg_kep/avg_kep.sav'
      outName='output/avg_kep/avg_bin_kep.sav'
      binsize = 0.01E
   end
   'K2-22': begin
      restore,'output/avg_kep/k2_22.sav'
      outName='output/avg_kep/avg_bin_k2_22.sav'
      binsize = 0.01E
      oreject= 2.0
   end
endcase



binbeg = -0.25E
binEnd = 0.25E
nbin = (binEnd - binbeg)/binsize
binstarts = findgen(nbin) * binsize + binbeg
binwidths = fltarr(nbin) + binsize
binmid = binstarts + binwidths * 0.5E

offp = where(masterX LT -0.1)
rsigma = robust_sigma(mastery[offp])
yerr = rsigma + fltarr(n_elements(masterX))
ybin = avg_series(masterx,mastery,yerr,binstarts,binwidths,stdevArr=stdevArr,oreject=oreject)

if keyword_set(zoomin) then begin
 custyRange=[0.9995,1.0005]
endif else custyRange = [0.993,1.001]
plot,binmid,ybin,psym=3,$
     yrange=custyRange,ystyle=1
oploterror,binmid,ybin,binwidths * 0.5E,stdevArr

save,binmid,ybin,binwidths,stdevArr,filename=outName

end
