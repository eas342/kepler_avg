pro transit_gallery,psplot=psplot,bin=bin
;; Show some individual transits
  if keyword_set(psplot) then begin
     set_plot,'ps'
     !p.font=0
     plotprenm = 'plots/kep_gallery'
     device,encapsulated=1, /helvetica,$
            filename=plotprenm+'.eps'
           device,xsize=20, ysize=14,decomposed=1,/color
  endif

!p.multi = [0,4,4]

;transNums = [0,2,3,4,6,7,8,9,10,14,15,18,21,24,25]
;ntrans = n_elements(transNums)
ntrans=16

for i=0l,ntrans-1l do begin
   plot_kep,n=i,bin=bin
endfor

  if keyword_set(psplot) then begin
     device, /close
     cgPS2PDF,plotprenm+'.eps'
     spawn,'convert -density 300% '+plotprenm+'.pdf '+plotprenm+'.png'
     device,decomposed=0
     set_plot,'x'
     !p.font=-1
  endif

!p.multi=0

end
