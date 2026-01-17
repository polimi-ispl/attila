function [ nBuff , scat_funcs , S_fun , R_th_funcs , out_fun , order , Z , rho , solv_fun ] = buildWDF( netlistPath , outNode , f_s , lmsdm , waveType , nearEls , iterSol , app )
    rho = getWaveCoeff( waveType );
    [ nBuff , eta , mu ] = getLmsdmParams( lmsdm );
    [ netData , types ] = cleanNetlist( netlistPath );
    [ Graph , outNode ] = getGraph( netData , types , outNode );
    [ Tree , Cotree ] = getTreeCotree( Graph , nearEls );
    order = getOrd( Tree , Cotree , nearEls );
    [ Q , B ] = getQB( Tree , Cotree , order );
    Z = getZ( Tree , Cotree , order , f_s , eta );
    [ S , S_fun ] = getS( Z , rho , Q , B );
    scat_funcs = getScatRel( Tree , Cotree , order , rho , eta , mu , iterSol );
    R_th_funcs = getThevRes( Tree , Cotree , order );  
    out_fun = getOutExpr( order , Graph , Z , rho , outNode );
    solv_fun = getIterFunc( iterSol );
    plotNet( Graph , Tree , Cotree , app );
    %plotZS( order , Z , S , fontSize );
end
