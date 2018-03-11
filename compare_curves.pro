pro compare_curves

restore,'/Users/bokonon/triplespec/corot1/pro/data/kepler_curves/phase_folded_kepler_all_kic1255.sav'

;Re-normalize and overplot (after using bin_kepler_multi)
offp = where(phaseX LT -0.1 OR phaseX GT 0.17)
normVal = median(kfluxS[offp])
renorm = kfluxS/normVal
oplot,phaseX,renorm,color=mycol('yellow')

end
