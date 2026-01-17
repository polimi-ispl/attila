function [ solv_fun ] = getIterFunc( iterSol )
    switch iterSol
        case 'SIM'
            solv_fun = @( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L ) SIM( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L );
        case 'WDNR'
            solv_fun = @( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L ) WDNR( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L );
        case 'WDFNR'
            solv_fun = @( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L ) WDFNR( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L );
        case 'EFP'
            solv_fun = @( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L ) EFP( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L );
        case 'WDPP'
            solv_fun = @( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L ) WDPP( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L );
        otherwise
            error( 'The specified iterative solver does not exist' );
    end
end

function [ a , b , v ] = SIM( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L )
    while norm( v - v_old ) >= tol_SOL 
        v_old = v;
        for ii = idx_nl
            b( ii ) = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        a = S * b;
        v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    end
end

function [ a , b , v ] = WDNR( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L )
    J_f = zeros( length( v ) );
    while norm( v - v_old ) >= tol_SOL 
        v_old = v;
        for ii = idx_nl
            [ b( ii ) , J_f( ii , ii ) ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        a = a - ( S - J_f ) \ ( S * a - b );
        v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    end
end

function [ a , b , v ] = WDFNR( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L )
    J_f = zeros( length( v ) );
    for ii = idx_nl
        [ b( ii ) , J_f( ii , ii ) ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
    end
    J_inv = inv( S - J_f );
    a = a - J_inv * ( S * a - b );
    v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    while norm( v - v_old ) >= tol_SOL 
        v_old = v;
        for ii = idx_nl
            [ b( ii ) , ~ ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        a = a - J_inv * ( S * a - b );
        v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    end
end

function [ a , b , v ] = EFP( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L )
    J_f = zeros( length( v ) );
    while norm( v - v_old ) >= tol_SOL 
        v_old = v;
        for ii = idx_nl
            [ b( ii ) , J_f( ii , ii ) ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        SJ = S * J_f;
        A = a - S * b;
        B = A;
        for jj = 1 : L
            A = SJ * A;
            B = B + A;
        end
        a = a - B;
        v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    end
end

function [ a , b , v ] = WDPP( a , b , v , v_old , rho , Z , S , scat_funcs , idx_nl , tol_SOL , L )
    J_f = zeros( length( v ) );
    while norm( v - v_old ) >= tol_SOL 
        v_old = v;
        for ii = idx_nl
            [ b( ii ) , J_f( ii , ii ) ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        J_inv = inv( S - J_f );
        a = a - J_inv * ( S * a - b );
        for ii = idx_nl
            [ b( ii ) , ~ ] = scat_funcs{ ii }( a( ii ) , Z( ii , ii ) );
        end
        a = a - J_inv * ( S * a - b );
        v = 0.5 * diag( Z ) .^ ( 1 - rho ) .* ( a + b );
    end
end