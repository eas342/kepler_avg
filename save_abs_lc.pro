;; Save the absolute light curve. Useful for keeping track of
;; individual transits
pro save_abs_lc

for i=0,5-1 do begin
   case i of
      0: nm = '_lc'
      1: nm = '_lc_sec'
      2: nm = ''
      3: nm = '_sec'
      4: nm = 'k2_22'
      else: begin
         print,'nm not found'
      end
   endcase
   
   if nm EQ 'k2_22' then begin
      preName = ''
      targName = 'k2_22'
   endif else begin
      preName = 'avg_kep'
      targName = 'kic1255'
   endelse
   restore,'output/avg_kep/'+preName+nm+'.sav'
   outName = 'output/avg_kep/ind_events_'+targName+nm+'.csv'
   

   st1 = create_struct('MASTERX',masterx,'MASTERY',mastery,$
                       'ABSPHASE',masterT,'JD',masterJD)
   dat = struct_arrays(st1)
   
   write_csv,outName,dat,header=tag_names(dat)
endfor

end
