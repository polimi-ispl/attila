function saveOutputSig( output , f_s , ext )
    if ext == ".wav"
        audiowrite( 'Output\outputSig.wav' , output , f_s )
    elseif ext == ".txt"
        t = ( 0 : length( output ) - 1 )' / f_s;
        out = [ t , output ];
        save( 'Output\outputSig.txt' , 'out' , '-ascii' );
    elseif ext == ".mat"
        M.t = ( 0 : length( output ) - 1 )' / f_s;
        M.sig = output;
        save( 'Output\outputSig.mat' , '-struct' , 'M' );
    else
        error( 'The output cannot be saved' );
    end
end
