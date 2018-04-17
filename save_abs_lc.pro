;; Save the absolute light curve. Useful for keeping track of
;; individual transits
pro save_abs_lc

for i=0,2-1 do begin
   if i EQ 0 then begin
      nm = ''
   endif else begin
      nm = '_sec'
   endelse
   restore,'output/avg_kep/avg_kep_lc'+nm+'.sav'
   outName = 'output/avg_kep/ind_events_kic1255_lc'+nm+'.csv'
   

   st1 = create_struct('MASTERX',masterx,'MASTERY',mastery,$
                       'ABSPHASE',masterT,'JD',masterJD)
   dat = struct_arrays(st1)
   
   write_csv,outName,dat,header=tag_names(dat)
endfor

end
