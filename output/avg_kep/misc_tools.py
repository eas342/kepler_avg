from astropy.io import ascii, fits

def make_k1255_fits():
    ### Make a FITS file for KIC 12557548
    dat = ascii.read('avg_bin_kep.csv')
    
    tHDU = fits.table_to_hdu(dat)
    tHDU.header['TUNIT'] = ('Orbital Phase', 'Units of of time axis')
    tHDU.header['PERIOD'] = (0.6535538 , 'Orbital Period in days, van Werkhoven 2014')
    tHDU.header['BUNIT'] = ('Norm Flux', 'Units of Y axis')
    prim = fits.PrimaryHDU()
    prim.header['OBJECT'] = ('KIC 12557548', 'Object')
    prim.header['DATYPE'] = ('Light curve', 'Average Kepler light curve')
    
    HDUList = fits.HDUList([prim,tHDU])
    
    HDUList.writeto('avg_bin_kep.fits',overwrite=True)

if __name__ == '__main__':
    make_k1255_fits()
