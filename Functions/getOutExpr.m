function [ out_fun ] = getOutExpr( order , Graph , Z , rho , outNode )
    if isscalar( fieldnames( Graph ) )
        G = Graph.G;
    else
        G = Graph.G_V;
    end 
    GND = min( G.Edges.EndNodes , [ ] , 'all' ); 
    G_aux = graph( G.Edges );
    [ path , ~ , outEdges ] = shortestpath( G_aux , GND , outNode + 1 );
    outElems = G_aux.Edges.ID( outEdges , : );
    out_fun = @( a , b ) 0;
    for ii = 1 : length( outElems )
        idx_outEl = find( order.IDs == outElems( ii ) );
        endNodes = table2array( G.Edges( G.Edges.ID == outElems( ii ) , 1 ) );
        if path( ii ) == endNodes( 1 ) && path( ii + 1 ) == endNodes( 2 )
            sgn = - 1;
        elseif path( ii + 1 ) == endNodes( 1 ) && path( ii ) == endNodes( 2 )
            sgn = 1;
        else
            error( 'Output signal path does not match output elements, something went wrong')
        end
        out_fun = @( a , b ) out_fun( a , b ) + sgn * Z( idx_outEl ) ^ ( 1 - rho ) * ( a( idx_outEl ) + b( idx_outEl ) ) / 2;
    end
    save( 'Output\parsingResults.mat' , 'out_fun' , '-append' );
end
