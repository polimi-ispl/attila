function [ R_th ] = antiExtSchockleyDiodeRes( v , i , I_s , eta , V_th , R_s , R_p )
    df_i = - 2 * I_s * R_s * cosh( ( v - R_s * i ) / ( eta * V_th ) ) / ( eta * V_th ) - R_s / R_p - 1;
    df_v = 2 * I_s * cosh( ( v - R_s * i ) / ( eta * V_th)  ) / ( eta * V_th ) + 1 / R_p;
    R_th = - df_i / df_v;
end