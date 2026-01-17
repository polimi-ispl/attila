function [ S , S_fun ] = getS( Z , rho , Q , B )
    if isscalar( fieldnames( Q ) )
        [ S , S_fun ] = getUsualS( Z , rho , Q.Q , B.B );
    else
        [ S , S_fun ] = getVoltCurrS( Z , rho , Q.Q_V , Q.Q_I , B.B_V , B.B_I );
    end
end

function [ S , S_fun ] = getUsualS( Z , rho , Q , B )
    t = size( Q , 1 );
    l = size( B , 1 );
    Z = diag( Z );
    if t < l
        S = 2 * Z ^ ( rho - 1 ) * Q' * ( ( Q * ( Z \ Q' ) ) \ Q ) * Z ^ ( - rho ) - eye( t + l );
        S_fun = @( Z ) 2 * Z ^ ( rho - 1 ) * Q' * ( ( Q * ( Z \ Q' ) ) \ Q ) * Z ^ ( - rho ) - eye( t + l );
        save( 'Output\parsingResults.mat' , 'Q' , '-append' );
    else
        S = eye( t + l ) - 2 * Z ^ rho * B' * ( ( B * Z * B' ) \ B ) * Z ^ ( 1 - rho );
        S_fun = @( Z ) eye( t + l ) - 2 * Z ^ rho * B' * ( ( B * Z * B' ) \ B ) * Z ^ ( 1 - rho );
        save( 'Output\parsingResults.mat' , 'B' , '-append' );
    end
    save( 'Output\parsingResults.mat' , 'S' , 'S_fun' , '-append' );
end

function [ S , S_fun ] = getVoltCurrS( Z , rho , Q_V , Q_I , B_V , B_I )
    t = size( Q_V , 1 );
    l = size( B_V , 1 );
    Z = diag( Z );
    if t < l
        S = 2 * Z ^ ( rho - 1 ) * Q_V' * ( ( Q_I * ( Z \ Q_V' ) ) \ Q_I ) * Z ^ ( - rho ) - eye( t + l );
        S_fun = @( Z ) 2 * Z ^ ( rho - 1 ) * Q_V' * ( ( Q_I * ( Z \ Q_V' ) ) \ Q_I ) * Z ^ ( - rho ) - eye( t + l );
        save( 'Output\parsingResults.mat' , 'Q_V' , 'Q_I' , '-append' );
    else
        S = eye( t + l ) - 2 * Z ^ rho * B_I' * ( ( B_V * Z * B_I' ) \ B_V ) * Z ^ ( 1 - rho );
        S_fun = @( Z ) eye( t + l ) - 2 * Z ^ rho * B_I' * ( ( B_V * Z * B_I' ) \ B_V ) * Z ^ ( 1 - rho );
        save( 'Output\parsingResults.mat' , 'B_V' , 'B_I' , '-append' );
    end
    save( 'Output\parsingResults.mat' , 'S' , 'S_fun' , '-append' );
end
