function [ b , J_f ] = antiExtSchockleyDiodeJac( a , Z , rho , I_s , eta , V_th , R_s , R_p )
    alpha = ( 2 * R_p * I_s * Z ^ rho + abs( a ) * ( R_p + R_s - Z ) ) / ( R_p + R_s + Z );
    beta = 2 * eta * V_th * Z ^ rho / ( R_s + Z );
    gamma = R_p * I_s * ( R_s + Z ) / ( eta * V_th * ( R_p + R_s + Z ) );
    delta = abs( a ) * ( Z - R_s ) / ( 2 * eta * V_th * Z ^ rho );
    W = enhancedOmegaW( log( gamma ) + delta + alpha / beta );
    b = sign( a ) * ( alpha - beta * W );
    dalpha_a = sign( a ) * ( R_p + R_s - Z ) / ( R_p + R_s + Z );
    ddelta_a = sign( a ) * ( Z - R_s ) / ( 2 * eta * V_th * Z ^ rho );
    J_f = sign( a ) * ( dalpha_a - W * ( beta * ddelta_a + dalpha_a ) / ( 1 + W ) );
end
