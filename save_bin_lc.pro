pro save_bin_lc
;; Save the binned light curve as FITS for easier reading in Python

  restore,'output/avg_kep/avg_bin_kep.sav'

  st1 = create_struct('BINMID',BINMID,'BINWIDTHS',BINWIDTHS,'STDEV',STDEVARR,'YBIN',YBIN)
  dat = struct_arrays(st1)

  write_csv,'output/avg_kep/avg_bin_kep.csv',dat,header=tag_names(dat)

end
