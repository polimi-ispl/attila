function [ scat_funcs ] = getScatRel( Tree , Cotree , order , rho , eta , mu , iterSol )
    if isscalar( fieldnames( Tree ) )
        tree = Tree.tree;
        cotree = Cotree.cotree;
    else
        tree = Tree.tree_V;
        cotree = Cotree.cotree_V;
    end 
    t = numedges( tree );
    l = numedges( cotree );
    types = [ tree.Edges.Type( order.Tree( : , 1 ) ) ; cotree.Edges.Type( order.Cotree( : , 1 ) ) ];
    params = [ tree.Edges.Parameters( order.Tree( : , 1 ) , : ) ; cotree.Edges.Parameters( order.Cotree( : , 1 ) , : ) ];
    scat_funcs = cell( t + l , 1 );
    for ii = 1 : t + l
        scat_funcs{ ii } = getElScatRel( types( ii ) , params( ii , : ) , rho , eta , mu , iterSol );
    end
    save( 'Output\parsingResults.mat' , 'scat_funcs' , '-append' );
end

function [ func ] = getElScatRel( type , params , rho , eta , mu , iterSol )
    switch type
        case 'Vin'
            func = @( a_buff , b_buff , x_in ) x_in * params( 1 ) ^ ( rho - 1 );
        case 'V'
            func = @( a_buff , b_buff , x_in ) params( 1 ) * params( 2 ) ^ ( rho - 1 );
        case 'Iin'
            func = @( a_buff , b_buff , x_in ) x_in * params( 1 ) ^ rho;
        case 'I'
            func = @( a_buff , b_buff , x_in ) params( 1 ) * params( 2 ) ^ rho;
        case 'R'
            func = @( a_buff , b_buff , x_in ) 0;
        case 'C'
            func = getDynElScatRel( eta , mu , 1 );
        case 'L'
            func = getDynElScatRel( eta , mu , -1 );
        case 'D'
            func = getDiodeScatRel( rho , params , iterSol );
        otherwise
            error( 'Undefined element' );
    end
end

function [ func_dyn ] = getDynElScatRel( eta , mu , sgn )
    if isscalar( eta )
        func_dyn = @( a_buff , b_buff , x_in ) mu * ( b_buff + sgn * a_buff ) / 2;
    else 
        func_dyn = @( a_buff , b_buff , x_in ) ( b_buff( 1 ) + sgn * a_buff( 1 ) + eta( 2 : end ) * ( sgn * a_buff - b_buff ) / eta( 1 ) ) / 2;
    end
end

function [ func_diode ] = getDiodeScatRel( rho , params , iterSol )
    switch iterSol
        case 'SIM'
            func_diode = @( a , Z ) extendedSchockleyDiodeScat( a , Z , rho , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        case 'WDNR'
            func_diode = @( a , Z ) extendedSchockleyDiodeJac( a , Z , rho , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        case 'WDFNR'
            func_diode = @( a , Z ) extendedSchockleyDiodeJac( a , Z , rho , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        case 'EFP'
            func_diode = @( a , Z ) extendedSchockleyDiodeJac( a , Z , rho , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        case 'WDPP'
            func_diode = @( a , Z ) extendedSchockleyDiodeJac( a , Z , rho , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        otherwise
            error( 'The specified iterative solver does not exist' );
    end
end
