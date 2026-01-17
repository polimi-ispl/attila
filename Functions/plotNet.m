function plotNet( Graph , Tree , Cotree , app )
    if isscalar( fieldnames( Graph ) )
        plotTreeCotreeDecomp( Graph.G , Tree.tree , Cotree.cotree , app );
    else
        plotVoltCurrTreeCotreeDecomp( Graph.G_V , Graph.G_I , Tree.tree_V , Cotree.cotree_V , Tree.tree_I , Cotree.cotree_I , app );
    end
end

function plotTreeCotreeDecomp( G , tree , cotree , app )
    app.VoltageGraphPlot.Visible = 'off';
    app.CurrentGraphPlot.Visible = 'off';
    app.GraphPlot.Visible = 'on';
    NL = { };
    EL = G.Edges.ID;
    E_T = find( ismember( G.Edges , tree.Edges ) );
    E_CT = find( ismember( G.Edges , cotree.Edges ) );
    cla( app.GraphPlot );
    p = plot( app.GraphPlot , G , 'EdgeLabel' , EL , 'Layout' , 'force' , 'NodeLabel' , NL , 'NodeColor' , 'k' , 'ArrowSize' , 10 , 'LineWidth' , 1.5 );
    highlight( p , 'Edges' , E_T , 'EdgeColor' , 'r' , 'LineStyle' , '-' );
    highlight( p , 'Edges' , E_CT , 'EdgeColor' , 'b' , 'LineStyle' , '--' );
    title( app.GraphPlot , 'Network Tree-Cotree Decomposition' , 'Fontsize' , 16 , 'interpreter' , 'latex' );
end

function plotVoltCurrTreeCotreeDecomp( G_V , G_I , tree_V , cotree_V , tree_I , cotree_I , app )
    app.GraphPlot.Visible = 'off';
    app.VoltageGraphPlot.Visible = 'on';
    app.CurrentGraphPlot.Visible = 'on';
    NL = { };
    EL_V = G_V.Edges.ID;
    EL_I = G_I.Edges.ID;
    E_TV = find( ismember( G_V.Edges , tree_V.Edges ) );
    E_CTV = find( ismember( G_V.Edges , cotree_V.Edges ) );
    E_TI = find( ismember( G_I.Edges , tree_I.Edges ) );
    E_CTI = find( ismember( G_I.Edges , cotree_I.Edges ) );
    cla( app.VoltageGraphPlot );
    p_V = plot( app.VoltageGraphPlot , G_V , 'EdgeLabel' , EL_V , 'Layout' , 'force' , 'NodeLabel' , NL , 'NodeColor' , 'k' , 'ArrowSize' , 10 , 'LineWidth' , 1.5 );
    highlight( p_V , 'Edges' , E_TV , 'EdgeColor' , 'r' , 'LineStyle' , '-' );
    highlight( p_V , 'Edges' , E_CTV , 'EdgeColor' , 'b' , 'LineStyle' , '--' );
    title( app.VoltageGraphPlot , 'V-Network Tree-Cotree Decomposition' , 'Fontsize' , 16 , 'interpreter' , 'latex' );
    cla( app.CurrentGraphPlot );
    p_I = plot( app.CurrentGraphPlot , G_I , 'EdgeLabel' , EL_I , 'Layout' , 'force' , 'NodeLabel' , NL , 'NodeColor' , 'k' , 'ArrowSize' , 10 , 'LineWidth' , 1.5 );
    highlight( p_I , 'Edges' , E_TI , 'EdgeColor' , 'r' , 'LineStyle' , '-' );
    highlight( p_I , 'Edges' , E_CTI , 'EdgeColor' , 'b' , 'LineStyle' , '--' );
    title( app.CurrentGraphPlot , 'I-Network Tree-Cotree Decomposition' , 'Fontsize' , 16 , 'interpreter' , 'latex' );
end