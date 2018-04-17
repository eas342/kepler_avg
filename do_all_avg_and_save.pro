pro do_all_avg_and_save
;; Does all the steps of fitting each transit, saving all results
;; then averaging and returning a nice CSV file
  targs = ['KIC1255','KIC1255LC','K2-22','HAT-P-7']
  
  for i=0l,n_elements(targs)-1l do begin
     avg_kepler,targ=targs[i]
     bin_kepler_multi,targ=targs[i]
     save_bin_lc,targ=targs[i]
  endfor

end
