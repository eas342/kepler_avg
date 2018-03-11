pro save_bin_lc,targ=targ
;; Save the binned light curve as FITS for easier reading in Python
;; targ - Specify target, otherwise, it looks at Kepler SC data for
;;        KIC 12557548b

  if n_elements(targ) EQ 0 then targ='KIC1255'
  case targ of
     'KIC1255': begin
        restore,'output/avg_kep/avg_bin_kep.sav'
        outName='output/avg_kep/avg_bin_kep.csv'
     end
     'K2-22': begin
        restore,'output/avg_kep/avg_bin_k2_22.sav'
        outName='output/avg_kep/avg_bin_k2_22.csv'
     end
  endcase

  st1 = create_struct('BINMID',BINMID,'BINWIDTHS',BINWIDTHS,'STDEV',STDEVARR,'YBIN',YBIN)
  dat = struct_arrays(st1)

  write_csv,outName,dat,header=tag_names(dat)

end
