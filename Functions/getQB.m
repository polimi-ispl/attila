function [ Q , B ] = getQB( Tree , Cotree , order )
    if isscalar( fieldnames( Tree ) )
        [ Q , B ] = getUsualQB( Tree.tree , Cotree.cotree , order );
        Q = struct( 'Q' , Q );
        B = struct( 'B' , B );
    else
        [ Q_V , Q_I , B_V , B_I ] = getVoltCurrQB( Tree.tree_V , Cotree.cotree_V , Tree.tree_I , Cotree.cotree_I , order );
        Q = struct( 'Q_V' , Q_V , 'Q_I' , Q_I );
        B = struct( 'B_V' , B_V , 'B_I' , B_I );
    end
end

function [ Q , B ] = getUsualQB( tree , cotree , order )
    t = numedges( tree );
    l = numedges( cotree );
    At = full( incidence( tree ) );
    Ac = full( incidence( cotree ) );
    At = At( : , order.Tree );
    Ac = Ac( : , order.Cotree );
    F = pinv( At ) * Ac;
    F( abs( F ) <= 1e-14 ) = 0;
    Q = [ eye( t ) , F ];
    B = [ - F' , eye( l ) ];
    save( 'Output\parsingResults.mat' , 'F' , '-append' );
end

function [ Q_V , Q_I , B_V , B_I ] = getVoltCurrQB( tree_V , cotree_V , tree_I , cotree_I , order )
    t = numedges( tree_V );
    l = numedges( cotree_V );
    At_V = full( incidence( tree_V ) ); 
    Ac_V = full( incidence( cotree_V ) ); 
    At_I = full( incidence( tree_I ) ); 
    Ac_I = full( incidence( cotree_I ) );
    At_V = At_V( : , order.Tree( : , 1 ) );
    Ac_V = Ac_V( : , order.Cotree( : , 1 ) );
    At_I = At_I( : , order.Tree( : , 2 ) );
    Ac_I = Ac_I( : , order.Cotree( : , 2 ) );
    F_V = pinv( At_V ) * Ac_V;
    F_I = pinv( At_I ) * Ac_I;
    F_V( abs( F_V ) <= 1e-14 ) = 0;
    F_I( abs( F_I ) <= 1e-14 ) = 0;
    Q_V = [ eye( t ) , F_V ];
    Q_I = [ eye( t ) , F_I ];
    B_V = [ - F_V' , eye( l ) ];
    B_I = [ - F_I' , eye( l ) ];
    save( 'Output\parsingResults.mat' , 'F_V' , 'F_I' , '-append' );
end
