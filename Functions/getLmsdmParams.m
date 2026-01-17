function [ nBuff , eta , mu ] = getLmsdmParams( method )
    switch method
        case 'Backward Euler'
            eta = 1;
            mu = 1;
            nBuff = 1;
        case 'Trapezoidal'
            eta = [ 1 , 1 ] / 2;
            mu = 1;
            nBuff = 1;
        case 'BDF2'
            eta = 2 / 3;
            mu = [ 4 , - 1 ] / 3;
            nBuff = 2;
        case 'AM2'
            eta = [ 5 , 8 , - 1 ] / 12;
            mu = 1;
            nBuff = 2;
        case 'BDF3'
            eta = 6 / 11;
            mu = [ 18 , - 9 , 2 ] / 11;
            nBuff = 3;
        case 'AM3'
            eta = [ 9 , 19 , - 5 , 1 ] / 24;
            mu = 1;
            nBuff = 3;
        case 'BDF4'
            eta = 12 / 25;
            mu = [ 48 , - 36 , 16 , - 3 ] / 25;
            nBuff = 4;
        otherwise
            error( 'Undefined Linear Multi-Step Discretization Method' );
    end
end
