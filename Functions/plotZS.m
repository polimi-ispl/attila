function plotZS( order , Z , S , fontSz )
    f = figure;
    f.WindowState = 'maximized';
    set( gcf , 'Position' , [ get( 0 , 'ScreenSize' ) ] );
    set( gca, 'ydir', 'reverse' );
    n_rows = size( Z , 1 ) + 1;
    n_cols = size( Z , 2 ) + 1;
    w_col = 2;
    h_row = 1;
    x = [ 0 , 0 , w_col , w_col ];
    y = [ 0 , h_row , h_row , 0 ];
    txt_Z = [ "" , "Z" ; order.IDs , string( Z ) ];
    order.SubDiv = order.SubDiv + 1;
    for col = 1 : 2
        for row = 1 : n_rows
            if col ~= 1 || row ~= 1
                if col == 1 && row > 1 && row <= order.SubDiv( 1 )
                    patch( x , y , 'red' , 'FaceAlpha' , 0.2 );
                elseif col == 1 && row > order.SubDiv( 1 ) && row <= order.SubDiv( 2 )
                    patch( x , y , 'red' , 'FaceAlpha' , 0.5 );
                elseif col == 1 && row > order.SubDiv( 2 ) && row <= order.SubDiv( 3 )
                    patch( x , y , 'blue' , 'FaceAlpha' , 0.5 );
                elseif col == 1 && row > order.SubDiv( 3 ) && row <= order.SubDiv( 4 )
                    patch( x , y , 'blue' , 'FaceAlpha' , 0.2 );
                else
                    patch( x , y , 'white' );
                end
            end
            if col == 1 || row == 1
                if row > order.SubDiv( 1 ) && row <= order.SubDiv( 3 )
                    str = append( "$\underline{\mathbf{" , txt_Z( row , col ) , "}}$" );
                else
                    str = append( "$\mathbf{" , txt_Z( row , col ) , "}$" );
                end
                t = text( x( 1 ) + w_col / 2 , y( 1 ) + h_row / 2 , str );
                t.FontSize = 2 * fontSz * ( 34 / n_rows );
                t.Interpreter = 'latex';
            else
                formattedStr = sprintf( '%.2e' , str2double( txt_Z( row , col ) ) );
                t = text( x( 1 ) + w_col / 2 , y( 1 ) + h_row / 2 , formattedStr );
                t.FontSize = fontSz * ( 34 / n_rows );
            end
            t.HorizontalAlignment = 'center';
            t.VerticalAlignment = 'middle';
            y = y + h_row;
        end
        y = [ 0 , h_row , h_row , 0 ];
        x = x + w_col;
        hold on;
    end
    x = x + w_col;
    txt_S = [ "S" , string( 1 : n_rows - 1 ) ; string( ( 1 : n_rows - 1 )' ) , string( S ) ];
    for col = 1 : n_rows
        for row = 1 : n_rows
            patch( x , y , 'white' );
            if col == 1 || row == 1
                str = append( "$\mathbf{" , txt_S( row , col ) , "}$" );
                t = text( x( 1 ) + w_col / 2 , y( 1 ) + h_row / 2 , str );
                t.FontSize = 2 * fontSz * ( 34 / n_rows );
                t.Interpreter = 'latex';
            else
                formattedStr = sprintf( '%.2e' , str2double( txt_S( row , col ) ) );
                t = text( x( 1 ) + w_col / 2 , y( 1 ) + h_row / 2 , formattedStr );
                t.FontSize = fontSz * ( 34 / n_rows );
            end
            t.HorizontalAlignment = 'center';
            t.VerticalAlignment = 'middle';
            y = y + h_row;
        end
        y = [ 0 , h_row , h_row , 0 ];
        x = x + w_col;
        hold on;
    end
    xlim( [ 0 , ( n_cols + n_rows + 2 ) * w_col - 1 ] );
    ylim( [ - 0.25 , n_rows * h_row ] );
    axis off;
    hold off;
    title( 'Free Parameters Vector and Scattering Matrix' , 'Interpreter' , 'latex' , 'Fontsize' , 18 );
end 