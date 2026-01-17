function [ b ] = antiExtSchockleyDiodeScat( a , Z , rho , I_s , eta , V_th , R_s , R_p )
    alpha = ( 2 * R_p * I_s * Z ^ rho + abs( a ) * ( R_p + R_s - Z ) ) / ( R_p + R_s + Z );
    beta = 2 * eta * V_th * Z ^ rho / ( R_s + Z );
    gamma = R_p * I_s * ( R_s + Z ) / ( eta * V_th * ( R_p + R_s + Z ) );
    delta = abs( a ) * ( Z - R_s ) / ( 2 * eta * V_th * Z ^ rho );
    b = sign( a ) * ( alpha - beta * enhancedOmegaW( log( gamma ) + delta + alpha / beta ) );
end
