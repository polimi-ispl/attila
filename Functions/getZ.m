function [ Z ] = getZ( Tree , Cotree , order , f_s , eta )
    if isscalar( fieldnames( Tree ) )
        tree = Tree.tree;
        cotree = Cotree.cotree;
    else
        tree = Tree.tree_V;
        cotree = Cotree.cotree_V;
    end
    eta_0 = eta( 1 );
    t = numedges( tree );
    l = numedges( cotree );
    types = [ tree.Edges.Type( order.Tree( : , 1 ) ) ; cotree.Edges.Type( order.Cotree( : , 1 ) ) ];
    params = [ tree.Edges.Parameters( order.Tree( : , 1 ) , : ) ; cotree.Edges.Parameters( order.Cotree( : , 1 ) , : ) ];
    Z = zeros( l + t , 1 );
    for ii = 1 : l + t
        Z( ii ) = getElZ( types( ii ) , params( ii , : ) , f_s , eta_0 );
    end
    save( 'Output\parsingResults.mat' , 'Z' , '-append' );
end

function [ Z_el ] = getElZ( type , params , f_s , eta_0 )
    switch type
        case 'Vin'
            Z_el = params( 1 );
        case 'V'
            Z_el = params( 2 );
        case 'Iin'
            Z_el = params( 1 );
        case 'I'
            Z_el = params( 2 );
        case 'R'
            Z_el = params( 1 );
        case 'C'
            Z_el = eta_0 / ( params( 1 ) * f_s );
        case 'L'
            Z_el = params( 1 ) * f_s / eta_0;
        case 'D'
            Z_el = 1;
        otherwise
            error( 'Undefined element' );
    end
end
