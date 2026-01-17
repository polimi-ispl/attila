function [ order ] = getOrd( Tree , Cotree , nearEls )
    if isscalar( fieldnames( Tree ) )
        order = findUsualOrd( Tree.tree , Cotree.cotree , nearEls );
    else
        order = findVoltCurrOrd( Tree.tree_V , Cotree.cotree_V , Tree.tree_I , Cotree.cotree_I , nearEls );
    end
end

function [ order ] = findUsualOrd( tree , cotree , nearEls )
    idx_1 = find( ~ismember( tree.Edges.ID , string( nearEls ) ) );
    idx_2 = find( ismember( tree.Edges.ID , string( nearEls ) ) );
    idx_3 = find( ismember( cotree.Edges.ID , string( nearEls ) ) );
    idx_4 = find( ~ismember( cotree.Edges.ID , string( nearEls ) ) );
    ids = [ tree.Edges.ID( idx_1 ) ; tree.Edges.ID( idx_2 ) ; cotree.Edges.ID( idx_3 ) ; cotree.Edges.ID( idx_4 ) ];
    types = [ tree.Edges.Type( idx_1 ) ; tree.Edges.Type( idx_2 ) ; cotree.Edges.Type( idx_3 ) ; cotree.Edges.Type( idx_4 ) ];
    t = numedges( tree );
    l = numedges( cotree );
    ordTree = zeros( t , 1 );
    ordCotree = zeros( l , 1 );
    for ii = 1 : t
        ordTree( ii ) = find( tree.Edges.ID == ids( ii ) );
    end
    for ii = 1 : l
        ordCotree( ii ) = find( cotree.Edges.ID == ids( t + ii ) );
    end
    subdiv = zeros( 4 , 1 );
    subdiv( 1 ) = length( idx_1 );
    subdiv( 2 ) = length( idx_2 );
    subdiv( 3 ) = length( idx_3 );
    subdiv( 4 ) = length( idx_4 );
    subdiv = cumsum( subdiv );
    order = struct( 'IDs' , ids , 'Types' , types , 'Tree' , ordTree , 'Cotree' , ordCotree , 'SubDiv' , subdiv );
    save( 'Output\parsingResults.mat' , 'ids' , 'types' , '-append' );
end

function [ order ] = findVoltCurrOrd( tree_V , cotree_V , tree_I , cotree_I , nearEls )
    idx_1 = find( ~ismember( tree_V.Edges.ID , string( nearEls ) ) );
    idx_2 = find( ismember( tree_V.Edges.ID , string( nearEls ) ) );
    idx_3 = find( ismember( cotree_V.Edges.ID , string( nearEls ) ) );
    idx_4 = find( ~ismember( cotree_V.Edges.ID , string( nearEls ) ) );
    ids = [ tree_V.Edges.ID( idx_1 ) ; tree_V.Edges.ID( idx_2 ) ; cotree_V.Edges.ID( idx_3 ) ; cotree_V.Edges.ID( idx_4 ) ];
    types = [ tree_V.Edges.Type( idx_1 ) ; tree_V.Edges.Type( idx_2 ) ; cotree_V.Edges.Type( idx_3 ) ; cotree_V.Edges.Type( idx_4 ) ];
    t = numedges( tree_V );
    l = numedges( cotree_V );
    ordTree_V = zeros( t , 1 );
    ordTree_I = zeros( t , 1 );
    ordCotree_V = zeros( l , 1 );
    ordCotree_I = zeros( l , 1 );
    for ii = 1 : t
        ordTree_V( ii ) = find( tree_V.Edges.ID == ids( ii ) );
        ordTree_I( ii ) = find( tree_I.Edges.ID == ids( ii ) );
    end
    for ii = 1 : l
        ordCotree_V( ii ) = find( cotree_V.Edges.ID == ids( t + ii ) );
        ordCotree_I( ii ) = find( cotree_I.Edges.ID == ids( t + ii ) );
    end
    subdiv = zeros( 4 , 1 );
    subdiv( 1 ) = length( idx_1 );
    subdiv( 2 ) = length( idx_2 );
    subdiv( 3 ) = length( idx_3 );
    subdiv( 4 ) = length( idx_4 );
    subdiv = cumsum( subdiv );
    order = struct( 'IDs' , ids , 'Types' , types , 'Tree' , [ ordTree_V , ordTree_I ] , 'Cotree' , [ ordCotree_V , ordCotree_I ] , 'SubDiv' , subdiv );
    save( 'Output\parsingResults.mat' , 'ids' , 'types' , '-append' );
end
