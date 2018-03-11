pro fit_kepler
;; Fit average short-cadence Kepler transit with analytical model

restore,'output/avg_kep/avg_bin_kep.sav'
;binmid,ybin,binwidths,stdevArr

expr = 'cloud_func(X,P)'
;start = [0.005, 0.00,0.1,0.1]
start = [0.001E,0.0009E, 0.012E,1.1E, 26E,3.2E]
nparams = n_elements(start)
pi = replicate({fixed:0, limited:[0,0], limits:[0.0E,0.0E]},nparams)
;pi[1].fixed = 1
result = mpfitexpr(expr,binmid,ybin,stdevArr,start,parinfo=pi,perr=punct);,/quiet)
ymodel = expression_eval(expr,binmid,result)

plot,binmid,ybin,psym=3,ystyle=16,/nodata
oploterror,binmid,ybin,binwidths,stdevArr,psym=3
oplot,binmid,ymodel,color=mycol('yellow')

end

