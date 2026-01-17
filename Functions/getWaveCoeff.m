function [ rho ] = getWaveCoeff( waveType )
    switch waveType
        case 'Voltage'
            rho = 1;
        case 'Current'
            rho = 0;
        case 'Power-Normalized'
            rho = 0.5;
        otherwise
            error( 'Selected wave type does not exist' );
    end
end
