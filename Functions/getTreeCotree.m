function [ Tree , Cotree ] = getTreeCotree( Graph , nearEls )
    if isscalar( fieldnames( Graph ) )
        [ tree , cotree ] = findUsualTreeCotree( Graph.G , nearEls );
        Tree = struct( 'tree' , tree );
        Cotree = struct( 'cotree' , cotree );
    else
        [ tree_V , cotree_V , tree_I , cotree_I ] = findCommTreeCotree( Graph.G_V , Graph.G_I , nearEls );
        Tree = struct( 'tree_V' , tree_V , 'tree_I' , tree_I );
        Cotree = struct( 'cotree_V' , cotree_V , 'cotree_I' , cotree_I );
    end
end

function [ tree , cotree ] = findUsualTreeCotree( G , nearEls )
    [ table_init , elIdx_init ] = chooseElems( G , nearEls );
    table_tree = table_init;
    elIdx = elIdx_init;
    kk = 1;
    ii = size( table_tree , 1 ) + 1;
    while ii < numnodes( G )
        row = G.Edges( elIdx( kk ) , : );
        table_tree = [ table_tree ; row ];
        tree = graph( table_tree );
        if hascycles( tree )
            table_tree( end , : ) = [ ];
            kk = kk + 1;
        else
            elIdx( kk ) = [ ];
            ii = ii + 1;
            kk = 1;
        end
    end
    tree = digraph( table_tree );
    idx_tree = find( ismember( G.Edges.ID , tree.Edges.ID ) );
    cotree = rmedge( G , idx_tree );
    save( 'Output\parsingResults.mat' , 'tree' , 'cotree' , '-append' );
end

function [ tree_V , cotree_V , tree_I , cotree_I ] = findCommTreeCotree( G_V , G_I , nearEls )
    [ table_V_init , table_I_init , elIdx_init , nEl_init ] = chooseCommElems( G_V , G_I , nearEls );
    table_tree_V = table_V_init;
    table_tree_I = table_I_init;
    elIdx = elIdx_init;
    kk = 1;
    ii = size( table_tree_V , 1 ) + 1;
    while ii < numnodes( G_V )
        row_V = G_V.Edges( elIdx( kk ) , : );
        row_I = G_I.Edges( G_I.Edges.ID == row_V.ID , : );
        table_tree_V = [ table_tree_V ; row_V ];
        table_tree_I = [ table_tree_I ; row_I ];
        tree_V = graph( table_tree_V );
        tree_I = graph( table_tree_I );   
        if hascycles( tree_V ) || hascycles( tree_I )
            table_tree_V( end , : ) = [ ];
            table_tree_I( end , : ) = [ ];
            kk = kk + 1;
        else
            elIdx( kk ) = [ ];
            kk = 1;
            ii = ii + 1;
        end
        if kk > length( elIdx )
            table_tree_V = table_V_init;
            table_tree_I = table_I_init;
            elIdx = elIdx_init( randperm( nEl_init ) );
            kk = 1;
            ii = size( table_V_init , 1 ) + 1;
        end
    end
    tree_V = digraph( table_tree_V );
    tree_I = digraph( table_tree_I );
    idx_tree_V = find( ismember( G_V.Edges.ID , tree_V.Edges.ID ) );
    idx_tree_I = find( ismember( G_I.Edges.ID , tree_I.Edges.ID ) );
    cotree_V = rmedge( G_V , idx_tree_V );
    cotree_I = rmedge( G_I , idx_tree_I );
    save( 'Output\parsingResults.mat' , 'tree_V' , 'cotree_V' , 'tree_I' , 'cotree_I' , '-append' );
end

function [ table_V_upd , table_I_upd , elIdx , nEl ] = chooseCommElems( G_V , G_I , nearEls )
    checkUserIn( G_V , nearEls );
    table_V_upd = cell2table( cell( 0 , 4 ) , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    table_I_upd = cell2table( cell( 0 , 4 ) , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    nEl = numedges( G_V );
    elIdx = randperm( nEl , nEl );
    for ii = 1 : length( nearEls )
        row_V_idx = find( G_V.Edges.ID == nearEls( 1 ) );
        row_I_idx = find( G_I.Edges.ID == nearEls( 1 ) );
        row_V = G_V.Edges( row_V_idx , : );
        row_I = G_I.Edges( row_I_idx , : );
        table_V_upd = [ table_V_upd ; row_V ];
        table_I_upd = [ table_I_upd ; row_I ];
        tree_V = graph( table_V_upd );
        tree_I = graph( table_I_upd );
        if hascycles( tree_V ) || hascycles( tree_I )
            table_V_upd( end , : ) = [ ];
            table_I_upd( end , : ) = [ ];
        else
            elIdx( elIdx == row_V_idx ) = [ ];
            nearEls( 1 ) = [ ];
            nEl = nEl - 1;
        end
    end
end

function [ table_upd , elIdx ] = chooseElems( G , nearEls )
    checkUserIn( G , nearEls );
    table_upd = cell2table( cell( 0 , 4 ) , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    nEl = numedges( G );
    elIdx = randperm( nEl , nEl );
    for ii = 1 : length( nearEls )
        row_idx = find( G.Edges.ID == nearEls( 1 ) );
        row = G.Edges( row_idx , : );
        table_upd = [ table_upd ; row ];
        tree = graph( table_upd );
        if hascycles( tree )
            table_upd( end , : ) = [ ];
        else
            elIdx( elIdx == row_idx ) = [ ];
            nearEls( 1 ) = [ ];
            nEl = nEl - 1;
        end
    end
end

function checkUserIn( G , nearEls )
    if length( unique( nearEls ) ) > numedges( G )
        error( 'Too many specified elements for the given network' );
    end
    if any( ~ismember( string( nearEls ) , G.Edges.ID ) )
        error( 'One or more of the specified elements are not present in the given network' );
    end
end
