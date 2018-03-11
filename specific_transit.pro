pro specific_transit,psplot=psplot,bin=bin,n=n,$
                     gtcCompare=gtcCompare,$
                     phase=phase,printmin=printmin
;; psplot saves a postscript plot
;; bin does time binning
;; n specifies which transit to look at
;; gtcCompare overlays a GTC light curve
;; phase tells it to show the orbital phase instead of hours

;; Show some individual transits
  if keyword_set(psplot) then begin
     set_plot,'ps'
     !p.font=0
     plotprenm = 'plots/specific_transit'
     device,encapsulated=1, /helvetica,$
            filename=plotprenm+'.eps'
     device,xsize=14, ysize=10,decomposed=1,/color
     !p.thick=3
     !y.thick=3
     !x.thick=3
  endif
  if keyword_set(gtcCompare) then phase=1

   plot_kep,n=n,bin=bin,phase=phase,printmin=printmin

   if keyword_set(gtcCompare) then begin
      readcol,'../other_data/digitized_light_curve_2012_07_24.csv',$
              skipline=6,phase,flux,format='(F,F)'

      oplot,phase,flux,color=mycol('red')
   endif
   

  if keyword_set(psplot) then begin
     device, /close
     cgPS2PDF,plotprenm+'.eps'
     spawn,'convert -density 300% '+plotprenm+'.pdf '+plotprenm+'.png'
     device,decomposed=0
     set_plot,'x'
     !p.font=-1
     !p.thick=0
     !y.thick=0
     !x.thick=0
  endif


end
