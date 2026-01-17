function [ R_th_funcs ] = getThevRes( Tree , Cotree , order )
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
    R_th_funcs = cell( t + l , 1 );
    for ii = 1 : t + l
        R_th_funcs{ ii } = getElThevRes( types( ii ) , params( ii , : ) );
    end
    save( 'Output\parsingResults.mat' , 'R_th_funcs' , '-append' );
end

function [ elRthFun ] = getElThevRes( type , params )
    switch type
        case 'Vin'
            elRthFun = @( v , i ) 0;
        case 'V'
            elRthFun = @( v , i ) 0;
        case 'Iin'
            elRthFun = @( v , i ) 0;
        case 'I'
            elRthFun = @( v , i ) 0;
        case 'R'
            elRthFun = @( v ) 0;
        case 'C'
            elRthFun = @( v , i ) 0;
        case 'L'
            elRthFun = @( v , i ) 0;
        case 'D'
            elRthFun = @( v , i ) extendedSchockleyDiodeRes( v , i , params( 1 ) , params( 2 ) , params( 3 ) , params( 4 ) , params( 5 ) );
        otherwise
            error( 'Undefined element' );
    end
end
