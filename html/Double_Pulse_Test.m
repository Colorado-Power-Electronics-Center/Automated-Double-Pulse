%% Automated Double Pulse Test
% The Automated Double Pulse Test toolbox allows users to run the double
% pulse test (DPT) completely automated. The toolbox can control all
% aspects of the double pulse test including oscilloscope setup, data
% capture, and full control of all other lab equipment. The toolbox is
% highly configurable and will allow the user to control as much or as
% little of its operation as desirable.

%% Requirements
% There are a number of requirements that must be taken care of before the
% toolbox can be used. These are seperated into software and hardware
% requirements

%%
% <html>
% <h3>Software Requirements</h3>
% </html>
%
%%
% <html>
% <h4>MATLAB 2016a</h4>
% </html>
% 
% * Only MATLAB version 2016a or greater will be supported
%
%%
% <html>
% <h4>Keysight IO Libraries Suite</h4>
% </html>
% 
% * Can currently be found 
% <http://www.keysight.com/find/iosuitedownload here>.
% * Should be installed first and used for any devices that are not made by
%   tektronix.
%
%%
% <html>
% <h4>TekVisa</h4>
% </html>
% 
% * Can be found 
% <http://www.tek.com/search/apachesolr_search/tekvisa?filters=type%3Asoftware%20tid%3A1031
% here>.
% * Once installed use the Keysight IO Libraries Suite to set the default
% VISA to tekVISA.

%%
% <html>
% <h3>Hardware Requirements</h3>
% </html>
%
% All instruments that will be controlled by the toolbox must be able to
% connect to the computer running MATLAB. The most common way is USB;
% however, ethernet, serial, and all other interfaces supported by VISA are
% also possible. Furthermore the instrument must be able to communicate
% with the Keysight, Tektronix, or National Instruments VISA library as
% these are the only choices in MATLAB. An instrument does not nessecarily
% need to be manufactured by one of these vendors to be compatible with
% their implementation of VISA as it is intended to be a universal
% standard. 
%
% Additioanlly all instruments should be updated to their most recent
% firmware version. The toolbox has been known to fail when used with
% instruments running old firmware. 

%% Setup
% Once the software is installed and the hardware is connected to the
% computer, there is still some additional setup required before the
% program can be run. This setup is done by creating a settings object
% using the DPTSettings class. 
% 
% The simplest version of the settings object can be created using the
% following code contained in the SimpleSettings.m file:
%
% <include>../SimpleSettings.m</include>
%
% Each setting is explained in detail in the DPTSettings documentation
% {LINK TO DOCUMENTATION}, but the short version is below:
%
% * busVoltages - A Vector of the desired test Bus Voltages
% * loadCurrents - A Vector of the desired test Load Currents (Each current
%  will be tested at all bus voltages)
% * currentResistor - The value of the current sensing resisitor used to
% measure the drain current. ($\Omega$)
% * loadInductor - The value of the load inductor. ($H$)
% * maxGateVoltage - The expected maximum value of the gate voltage. ($V$)
% * gateLogicVoltage - The logic voltage to be sent to the gate driver. ($V$)
% * scopeVisaAddress - The VISA address of the Oscilloscope.
% * FGenVisaAddress - The VISA address of the Function Generator. 
% * channel.VDS - The oscilloscope channel measuring $V_{DS}$.
% * channel.VGS - The oscilloscope channel measuring $V_{GS}$.
% * channel.ID - The oscilloscope channel measuring $I_{D}$.
% * channel.IL - The oscilloscope channel measuring $I_{L}$. Remove or
% comment out this line if not measuring load current.
%
% There are also many more settings that can be adjusted and they are also
% documented in the DPTSettings documentation {LINK TO DOCUMENTATION}.

%% This is section one
% lots of info here 


%% This is section two
% lots more info here

% Maybe some test code
foo = 34;

bar = foo * 3;

%% Ok last section
% 
% $$e^{\pi i} + 1 = 0$$
% 
%% Or not
% 
%   for x = 1:10
%       disp(x)
%   
%       disp('tesr')
%   end
%
%% Bulleted List
% 
% * ITEM1
% * ITEM2
% 
%%
% <html>
% <script src='https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'></script>
% <style type="text/css">
% .tg  {border-collapse:collapse;border-spacing:0;border-color:#ccc;}
% .tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#ccc;color:#333;background-color:#fff;border-top-width:1px;border-bottom-width:1px;}
% .tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-color:#ccc;color:#333;background-color:#f0f0f0;border-top-width:1px;border-bottom-width:1px;}
% .tg .tg-yw4l{vertical-align:top}
% .tg .tg-4eph{background-color:#f9f9f9}
% .tg .tg-b7b8{background-color:#f9f9f9;vertical-align:top}
% </style>
% <table class="tg" style="undefined;table-layout: fixed; width: 406px">
% <colgroup>
% <col style="width: 140px">
% <col style="width: 266px">
% </colgroup>
%   <tr>
%     <th class="tg-yw4l">Setting</th>
%     <th class="tg-yw4l">Description</th>
%   </tr>
%   <tr>
%     <td class="tg-4eph">busVoltages</td>
%     <td class="tg-4eph">A Vector of the desired test Bus Voltages \(\left(V\right)\)</td>
%   </tr>
%   <tr>
%     <td class="tg-031e">loadCurrents</td>
%     <td class="tg-031e">A Vector of the desired test Load Currents \(\left(A\right)\) (Each current will be tested at all bus voltages)</td>
%   </tr>
%   <tr>
%     <td class="tg-4eph">currentResistor</td>
%     <td class="tg-4eph">The value of the current sensing resisitor used to measure the drain current. \(\left(\Omega\right)\)</td>
%   </tr>
%   <tr>
%     <td class="tg-yw4l">loadInductor</td>
%     <td class="tg-yw4l">The value of the load inductor. \(\left(H\right)\)</td>
%   </tr>
%   <tr>
%     <td class="tg-b7b8">maxGateVoltage</td>
%     <td class="tg-b7b8">The expected maximum value of the gate voltage. \(\left(V\right)\)</td>
%   </tr>
%   <tr>
%     <td class="tg-yw4l">gateLogicVoltage</td>
%     <td class="tg-yw4l">The logic voltage to be sent to the gate driver. \(\left(V\right)\)</td>
%   </tr>
%   <tr>
%     <td class="tg-b7b8">scopeVisaAddress</td>
%     <td class="tg-b7b8">The VISA address of the Oscilloscope.</td>
%   </tr>
%   <tr>
%     <td class="tg-yw4l">FGenVisaAddress</td>
%     <td class="tg-yw4l">The VISA address of the Function Generator.</td>
%   </tr>
%   <tr>
%     <td class="tg-b7b8">channel.VDS</td>
%     <td class="tg-b7b8">The oscilloscope channel measuring \(V_{DS}\).</td>
%   </tr>
%   <tr>
%     <td class="tg-yw4l">channel.VGS</td>
%     <td class="tg-yw4l">The oscilloscope channel measuring \(V_{GS}\).</td>
%   </tr>
%   <tr>
%     <td class="tg-b7b8">channel.ID</td>
%     <td class="tg-b7b8">The oscilloscope channel measuring \(I_{D}\).</td>
%   </tr>
%   <tr>
%     <td class="tg-yw4l">channel.IL</td>
%     <td class="tg-yw4l">The oscilloscope channel measuring \(I_{L}\). Remove or comment out this line if not measuring load current.</td>
%   </tr>
% </table>
% </html>

