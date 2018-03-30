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
     'KIC1255LC': begin
        restore,'output/avg_kep/avg_bin_kep_lc.sav'
        outName='output/avg_kep/avg_bin_kep_lc.csv'
     end
     'K2-22': begin
        restore,'output/avg_kep/avg_bin_k2_22.sav'
        outName='output/avg_kep/avg_bin_k2_22.csv'
     end
     'HAT-P-7': begin
        restore,'output/avg_kep/avg_bin_hat_p_7.sav'
        outName='output/avg_kep/avg_bin_hat_p_7.csv'
     end
     'TrES-2': begin
        restore,'output/avg_kep/avg_bin_tres_2.sav'
        outName='output/avg_kep/avg_bin_tres_2.csv'
     end
  endcase

  st1 = create_struct('BINMID',BINMID,'BINWIDTHS',BINWIDTHS,'STDEV',STDEVARR,'YBIN',YBIN,$
                      'STDEVSPREAD',stdevSpread)
  dat = struct_arrays(st1)

  write_csv,outName,dat,header=tag_names(dat)

end
