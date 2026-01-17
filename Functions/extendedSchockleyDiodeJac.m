function [ b , J_f ] = extendedSchockleyDiodeJac( a , Z , rho , I_s , eta , V_th , R_s , R_p )
    alpha = ( 2 * R_p * I_s * Z ^ rho + a * ( R_p + R_s - Z ) ) / ( R_p + R_s + Z );
    beta = 2 * eta * V_th * Z ^ rho / ( R_s + Z );
    gamma = R_p * I_s * ( R_s + Z ) / ( eta * V_th * ( R_p + R_s + Z ) );
    delta = a * ( Z - R_s ) / ( 2 * eta * V_th * Z ^ rho );
    W = enhancedOmegaW( log( gamma ) + delta + alpha / beta );
    b = alpha - beta * W;
    dalpha_a = ( R_p + R_s - Z ) / ( R_p + R_s + Z );
    ddelta_a = ( Z - R_s ) / ( 2 * eta * V_th * Z ^ rho );
    J_f = dalpha_a - W * ( beta * ddelta_a + dalpha_a ) / ( 1 + W );
end
