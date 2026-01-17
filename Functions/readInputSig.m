function [ x_in , f_s ] = readInputSig( input , simTime , f_s )
    switch nargin
        case 2
            [ ~ , ~ , ext ] = fileparts( input );
            input = append( 'Input\' , input );
            if isfile( input ) && ext == ".wav"
                [ x_in , f_s ] = audioread( input );
            elseif isfile( input ) && ext == ".txt"
                M = readmatrix( input );
                f_s = 1 / ( M( 2 , 1 ) - M( 1 , 1 ) );
                x_in = M( : , 2 );
            elseif isfile( input ) && ext == ".mat"
                M = load( input );
                f_s = 1 / ( M.t( 2 ) - M.t( 1 ) );
                x_in = M.sig;
            else
                error( 'The input is not a compatible file' )
            end
         case 3
            if isa( input , 'function_handle' )
                t = 0 : 1 / f_s : simTime;
                x_in = input( t' );
            else
                error( 'The input is not a valid function handle' );
            end
        otherwise
            error( 'Incorrect number of inputs' );
    end
    simLen = simTime * f_s;
    if  simLen <= length( x_in )
        x_in = x_in( 1 : simLen );
    end
end
