function [ Graph , outNode ] = getGraph( netData , types , outNode )
    if any( types == 'Plin' | types == 'Plog' | types == 'Pilog' )
        [ netData , types ] = handlePots( netData , types );
    end
    if ~any( types == 'OA' )
        [ G , outNode ] = getUsualGraph( netData , outNode );
        Graph = struct( 'G' , G );
    else
        [ G_V , G_I , outNode ] = getVoltCurrGraphs( netData , types , outNode );
        Graph = struct( 'G_V' , G_V , 'G_I' , G_I );
    end
end

function [ G , outNode ] = getUsualGraph( netData , outNode )
    ids = netData( : , 1 );
    types = string( regexp( ids , '[A-Za-z]+' , 'match' ) );
    nodes = str2double( string( regexp( netData( : , 2 : 3 ) , '[0-9]+' , 'match' ) ) );
    if ~isa( outNode , 'double' )
        outNode = str2double( string( regexp( outNode , '[0-9]+' , 'match' ) ) );
    end
    params = extractParams( netData , types );
    table_G = table( nodes + 1 , types , ids , params , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    G = digraph( table_G );
    save( 'Output\parsingResults.mat' , 'G' );
end

function [ G_V , G_I , outNode ] = getVoltCurrGraphs( netData , types , outNode )
    [ netData_V , netData_I , outNode ] = handleOpamps( netData , types , outNode );
    ids = netData_V( : , 1 );
    types = string( regexp( ids , '[A-Za-z]+' , 'match' ) );
    nodes_V = str2double( string( regexp( netData_V( : , 2 : 3 ) , '[0-9]+' , 'match' ) ) );
    nodes_I = str2double( string( regexp( netData_I( : , 2 : 3 ) , '[0-9]+' , 'match' ) ) );
    if min( nodes_V , [ ] , 'all' ) ~= 0
        deltaN = min( nodes_V , [ ] , 'all' );
        nodes_V = nodes_V - deltaN;
        outNode = outNode - deltaN;
    end
    if min( nodes_I , [ ] , 'all' ) ~= 0
        deltaN = min( nodes_I , [ ] , 'all' );
        nodes_I = nodes_I - deltaN;
    end
    params = extractParams( netData_V , types );
    table_G_V = table( nodes_V + 1 , types , ids , params , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    table_G_I = table( nodes_I + 1 , types , ids , params , 'VariableNames' , { 'EndNodes' , 'Type' , 'ID' , 'Parameters' } );
    G_V = digraph( table_G_V );
    G_I = digraph( table_G_I );
    save( 'Output\parsingResults.mat' , 'G_V' , 'G_I' );
end

function [ netData , types ] = handlePots( netData , types )
    ids = netData( : , 1 );
    netData( ids == "Ra" | ids == "Rb" , : ) = [ ];
    resistorsID = netData( types == "R" , 1 );
    resistorNums = str2double( string( regexp( resistorsID , '[0-9]+' , 'match' ) ) );
    resistorsCounter = max( resistorNums ) + 1;
    firstLetter = string( regexp( types , '[A-Z]+' , 'match' ) );
    netDataPots = netData( firstLetter == 'P' , : );
    newData = strings( 0 , size( netData , 2 ) );
    empty = strings( 1 , size( netData , 2 ) - 4 );
    for ii = 1 : size( netDataPots , 1 )
        id = netDataPots( ii , 1 ); 
        potType = string( regexp( id , '[a-z]+' , 'match' ) );
        nodes = netDataPots( ii , 2 : 4 );
        Rp = convertStringsToChars( netDataPots( ii , 7 ) );
        Rp = eng2num( Rp( 4 : end ) );
        x = convertStringsToChars( netDataPots( ii , 8 ) ); 
        x = eng2num( x( 3 : end ) );
        switch potType
            case 'lin'
                Ra = Rp * x + 10 ^ ( -6 );
                Rb = Rp * ( 1 - x ) + 10 ^ ( -6 );
            case 'log'
                Ra = 0.0125 * Rp * ( 81 ^ x - 1 ) + 10 ^ ( -6 );
                Rb = 1.0125 * Rp * ( 1 - 81 ^ ( x - 1 ) ) + 10 ^ ( -6 );
            case 'ilog'
                Ra = Rp * ( 1 + 0.0125 * ( 1 - 81 ^ ( 1 - x ) ) ) + 10 ^ ( -6 );
                Rb = 0.0125 * Rp * ( 81 ^ ( 1 - x ) - 1 ) + 10 ^ ( -6 );
            otherwise
                error( 'Invalid potentiometer type' );
        end
        if nodes( 1 ) == nodes( 2 )
            R_23_id = strcat( "R" , num2str( resistorsCounter ) );
            R_23_row = [ R_23_id , nodes( 2 ) , nodes( 3 ) , num2str( Rb ) , empty ];
            newData = [ newData ; R_23_row ];
        elseif nodes( 2 ) == nodes( 3 )
            R_12_id = strcat( "R" , num2str( resistorsCounter ) );
            R_12_row = [ R_12_id , nodes( 1 ) , nodes( 2 ) , num2str( Ra ) , empty ];
            newData = [ newData ; R_12_row ];
        else
            R_12_id = strcat( "R" , num2str( resistorsCounter ) );
            R_12_row = [ R_12_id , nodes( 1 ) , nodes( 2 ) , num2str( Ra ) , empty ];
            resistorsCounter = resistorsCounter + 1;
            R_23_id = strcat( "R" , num2str( resistorsCounter ) );
            R_23_row = [ R_23_id , nodes( 2 ) , nodes( 3 ) , num2str( Rb ) , empty ];
            newData = [ newData ; R_12_row ; R_23_row ];
        end
            resistorsCounter = resistorsCounter + 1;
            netData( netData( : , 1 ) == id , : ) = [ ];
    end
    netData = [ netData ; newData ];
    types = string( regexp( netData( : , 1 ) , '[A-Za-z]+' , 'match' ) );
end

function [ netData_V , netData_I , outNode ] = handleOpamps( netData , types , outNode )
    negPins = netData( types == 'OA' , 2 );
    posPins = netData( types == 'OA' , 3 );
    outPins = netData( types == 'OA' , 4 );
    netData_V = netData( types ~= 'OA' , : );
    netData_I = netData( types ~= 'OA' , : );
    for ii = 1 : length( negPins )
        netData_V( netData_V == negPins( ii ) ) = posPins( ii );
        netData_I( netData_I == outPins( ii ) ) = 0;
        if outNode == negPins( ii )
            outNode = posPins( ii );
        end
    end
    negPins = str2double( string( regexp( negPins , '[0-9]+' , 'match' ) ) );
    posPins = str2double( string( regexp( posPins , '[0-9]+' , 'match' ) ) );
    outPins = str2double( string( regexp( outPins , '[0-9]+' , 'match' ) ) );
    outNode = str2double( string( regexp( outNode , '[0-9]+' , 'match' ) ) );
    nodes_V = str2double( string( regexp( netData_V( : , 2 : 3 ) , '[0-9]+' , 'match' ) ) );
    nodes_I = str2double( string( regexp( netData_I( : , 2 : 3 ) , '[0-9]+' , 'match' ) ) );
    for ii = 1 : length( negPins )
        if negPins( ii ) > posPins( ii )
            nodes_V( nodes_V > negPins( ii ) ) = nodes_V( nodes_V > negPins( ii ) ) - 1;
            negPins( negPins > negPins( ii ) ) = negPins( negPins > negPins( ii ) ) - 1;
            posPins( posPins > negPins( ii ) ) = posPins( posPins > negPins( ii ) ) - 1;
            outNode( outNode > negPins( ii ) ) = outNode( outNode > negPins( ii ) ) - 1;
        elseif negPins( ii ) < posPins( ii )
            nodes_V( nodes_V < negPins( ii ) ) = nodes_V( nodes_V < negPins( ii ) ) + 1;
            negPins( negPins < negPins( ii ) ) = negPins( negPins < negPins( ii ) ) + 1;
            posPins( posPins < negPins( ii ) ) = posPins( posPins < negPins( ii ) ) + 1;
            outNode( outNode < negPins( ii ) ) = outNode( outNode < negPins( ii ) ) + 1;
        end
        if outPins( ii ) > 0
            nodes_I( nodes_I > outPins( ii ) ) = nodes_I( nodes_I > outPins( ii ) ) - 1;
            outPins( outPins > outPins( ii ) ) = outPins( outPins > outPins( ii ) ) - 1;
        end
    end
    netData_V( : , 2 : 3 ) = nodes_V;
    netData_I( : , 2 : 3 ) = nodes_I;
end

function [ params ] = extractParams( netData , types )
    nEl = length( types );
    params = zeros( nEl , 5 );
    for ii = 1 : nEl
        params( ii , : ) = extractElValues( types( ii ) , netData( ii , : ) );
    end
end

function [ values ] = extractElValues( type , elData )
    values = zeros( 1 , 5 );
    switch type
        case 'Vin'
            values( 1 ) = 10 ^ ( -9 );
        case 'V'
            values( 1 ) = eng2num( elData( 4 ) );
            values( 2 ) = 10 ^ ( -9 );
        case 'Iin'
            values( 1 ) = 10 ^ 9;
        case 'I'
            values( 1 ) = eng2num( elData( 4 ) );
            values( 2 ) = 10 ^ 9;
        case 'R'
            values( 1 ) = eng2num( elData( 4 ) );
        case 'C'
            values( 1 ) = eng2num( elData( 4 ) );
        case 'L'
            values( 1 ) = eng2num( elData( 4 ) );
        case 'D'
            I_s = convertStringsToChars( elData( 6 ) );
            I_s = eng2num( I_s( 4 : end ) );
            eta = convertStringsToChars( elData( 7 ) );
            eta = eng2num( eta( 5 : end ) );
            V_th = convertStringsToChars( elData( 8 ) );
            V_th = eng2num( V_th( 5 : end ) );
            R_s = convertStringsToChars( elData( 9 ) );
            R_s = eng2num( R_s( 4 : end) );
            R_p = convertStringsToChars( elData( 10 ) );
            R_p = eng2num( R_p( 4 : end ) );
            values = [ I_s , eta , V_th , R_s , R_p ];
        otherwise
            error( 'Invalid element type' );
    end
end

function number = eng2num( stringValue )
    stringValue = convertStringsToChars( stringValue );
    i = length( stringValue );
    while i > 0 && isnan( str2double( stringValue( 1 : i ) ) )
        i = i - 1;
    end
    firstNumber = stringValue( 1 : i );
    stringValue = stringValue( i + 1 : end );
    j = 0;
    while j < length( stringValue ) && isstrprop( stringValue( j + 1 ), 'alpha' )
        j = j + 1;
    end
    firstLetters = stringValue( 1 : j );
    stringValue = stringValue( j + 1 : end );
    k = 0;
    while k < length( stringValue ) && ~isnan( str2double( stringValue( 1 : k + 1 ) ) )
        k = k + 1;
    end
    secondNumber = stringValue( 1 : k );
    remainder = stringValue( k + 1 : end );
    if isempty( firstNumber )
        number = NaN;
    else
        number = str2double( firstNumber );
    end
    if ~isempty( secondNumber )
        if contains( firstNumber , '.' ) || contains( secondNumber , '.' )
            number = NaN;
            return;
        end
        if number >= 0
            sign = 1;
        else
            sign = - 1;
        end
        number = number + sign * 10 ^ ( - length( secondNumber ) * str2double( secondNumber ) );
    end
    factor = 1;
    if length( firstLetters ) >= 1
        if length( firstLetters ) >= 3
            switch lower( firstLetters( 1 : 3 ) )
                case 'meg'
                    factor = 10 ^ 6;
                case 'mil'
                    factor = 25.4 * 10 ^ ( - 6 );
            end
            unitInFirstLetters = factor ~= 1 && length( firstLetters ) > 3;
        end
        if factor == 1
            switch lower( firstLetters( 1 ) )
                case 't'
                    factor = 10 ^ 12;
                case 'g'
                    factor = 10 ^ 9;
                case 'k'
                    factor = 10 ^ 3;
                case 'm'
                    factor = 10 ^ ( - 3 );
                case 'u'
                    factor = 10 ^ ( - 6 );
                case 'µ'
                    factor = 10 ^ ( - 6 );
                case 'n'
                    factor = 10 ^ ( - 9 );
                case 'p'
                    factor = 10 ^ ( - 12 );
                case 'f'
                    factor = 10 ^ ( - 15 );
            end
            unitInFirstLetters = length( firstLetters ) > 1;
        end
    else
        unitInFirstLetters = false;
    end
    if ~isempty( remainder ) && ( any( isstrprop( remainder , 'digit' ) ) || unitInFirstLetters )
        number = NaN;
        return;
    else
        number = number * factor;
    end
end
