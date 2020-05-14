%{
    Part of the Automated Double Pulse Test Project
    Copyright (C) 2017  Kyle Goodrick

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Kyle Goodrick: Kyle.Goodrick@Colorado.edu
%}


function setVoltageToLoadForSynchronousDPT(myScope, myBusSupply, busVoltage, settings)
    curVoltage = myBusSupply.outVoltage;
    
    myScope.channelsOn(settings.Vcomplementary_Channel);
    myScope.minMaxRescaleChannel(settings.Vcomplementary_Channel, 0,...
        max(busVoltage, curVoltage),...
        settings.numVerticalDivisions, settings.percentBuffer);
    % Get Current acqStop Settings
    prevStopAfter = myScope.acqStopAfter;
    prevRecordLength = myScope.recordLength;
    
    myScope.acqStopAfter = 'RUNSTop';
    myScope.acqState = 'ON';
    myScope.recordLength = 1000;
    
    % Either ask user to do it or do it automatically per settings
    if settings.autoBusControl
        % Setup Measurement on oscilloscope
        myScope.setImmediateMeasurementSource(settings.channel.Vcomplementary);
        myScope.setImmediateMeasurementType('MEAN');
        myScope.setChProbeControl(settings.channel.Vcomplementary, 'MANual');
        myScope.setChProbeForcedRange(settings.channel.Vcomplementary, 750);
        
        
        pause(3);
        % Separate voltage change into 10 sections        
        steps = linspace(curVoltage, busVoltage, 10);
        
        % Skip first element as it is the current voltage
        for step = steps(2:end)
            % Set voltage with slew to each section
            myBusSupply.setSlewedVoltage(step, settings.busSlewRate);
            
            % Check that drain voltage is actually the bus voltage
            Vcomplementary = myScope.getImmediateMeasurementValue;
            % ceil and +1 give a little more buffer at low voltages,
            % without making it too large at high voltages. 
            if abs(step - Vcomplementary) > ceil(.05 * step) + 1
                error('V_complementary not within ~5% of Bus Supply');
            end
        end
    else
        disp(['Set voltage to ' num2str(busVoltage) 'V and press any key...'])
        pause;
    end
    
    % Reset Scope to previous ACQ Settings
    myScope.acqStopAfter = prevStopAfter;
    myScope.recordLength = prevRecordLength;
end