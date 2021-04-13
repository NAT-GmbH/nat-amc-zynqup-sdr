%******************************************************************************
%******************************************************************************
%                                                                             *
%     NNNNNN         N                A             TTTTTTT TTTTTTTTTT        *
%     N NNNNN        N               AAA                  T TTTTT             *
%     NN NNNNN       N              AAAAA                 T TTTTT             *
%     N N NNNNN      N             A AAAAA                T TTTTT             *
%     N  N NNNNN     N            A A AAAAA               T TTTTT             *
%     N   N NNNNN    N           A   A AAAAA              T TTTTT             *
%     N    N NNNNN   N          A     A AAAAA             T TTTTT             *
%     N     N NNNNN  N         AAAAAAAAA AAAAA            T TTTTT             *
%     N      N NNNNN N        A         A AAAAA           T TTTTT             *
%     N       N NNNNNN       A           A AAAAA          T TTTTT             *
%     N        N NNNNN  OO  A             A AAAAA  OO     T TTTTT     OO      *
%                       OO                         OO                 OO      *
%                                                                             *
%     Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H       *
%        Konrad-Zuse-Platz 9, D-53227 Bonn, Tel.:+49 228/965 864-0            *
%                            www.nateurope.com                                *
%                                                                             *
%******************************************************************************
%******************************************************************************
%
% Module      : Base.m
%
% Description : Base Class for the NAT-AMC-ZYNQUP-SDR8
%
% Author      : Analog Devices, Inc. / Thomas Florkowski
%
%*****************************************************************************
%*****************************************************************************
%
%Copyrigth 2021(c) Gesellschaft fuer Netzwerk- und Automatisierungstechnologie m.b.H (NAT GmbH)
%Copyright 2019(c) Analog Devices, Inc.
%All rights reserved.
%
%*****************************************************************************
%*****************************************************************************

classdef (Abstract, Hidden = true) Base < ...
        adi.common.RxTx & ...
        nat.common.Attribute & ...
        adi.common.DebugAttribute & ...
        matlabshared.libiio.base & matlab.system.mixin.CustomIcon
    %adi.ADRV9009.Base Class
    %   This class contains shared parameters and methods between TX and RX
    %   classes
    properties (Nontunable)
        %SamplesPerFrame Samples Per Frame
        %   Number of samples per frame, specified as an even positive
        %   integer from 2 to 16,777,216. Using values less than 3660 can
        %   yield poor performance.
        SamplesPerFrame = 2^15;
    end

    properties (Hidden, Constant)
        %SamplingRate Sampling Rate
        %   Baseband sampling rate in Hz, specified as a scalar
        %   in samples per second.
        SamplingRate = 245.76e6;
    end

    properties
        %CenterFrequency Center Frequency
        %   RF center frequency, specified in Hz as a scalar. The
        %   default is 2.4e9.  This property is tunable.
        CenterFrequencyPhy = 2.4e9;
        CenterFrequencyPhyB = 2.4e9;
        CenterFrequencyPhyC = 2.4e9;
        CenterFrequencyPhyD = 2.4e9;
    end

    properties(Nontunable, Hidden)
        Timeout = Inf;
        kernelBuffersCount = 2;
        dataTypeStr = 'int16';
        phyDevName = 'adrv9009-phy';
        iioDevPHY
    end

    properties (Hidden, Constant)
        ComplexData = true;
    end


    methods
        %% Constructor
        function obj = Base(varargin)
            coder.allowpcode('plain');
            obj = obj@matlabshared.libiio.base(varargin{:});
        end
        % Check SamplesPerFrame
        function set.SamplesPerFrame(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'positive','scalar', 'finite', 'nonnan', 'nonempty','integer','>',0,'<=',2^20}, ...
                '', 'SamplesPerFrame');
            obj.SamplesPerFrame = value;
        end
        % Check CenterFrequency
        function set.CenterFrequencyPhy(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'positive','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',70e6,'<=',6e9}, ...
                '', 'CenterFrequency');
            obj.CenterFrequencyPhy = value;
            if obj.ConnectedToDevice
                id = 'altvoltage0';
                obj.setAttributeLongLong(id,'frequency',value,true,'adrv9009-phy');
            end
        end
        function set.CenterFrequencyPhyB(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'positive','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',70e6,'<=',6e9}, ...
                '', 'CenterFrequency');
            obj.CenterFrequencyPhyB = value;
            if obj.ConnectedToDevice
                id = 'altvoltage0';
                obj.setAttributeLongLong(id,'frequency',value,true,'adrv9009-phy-b');
            end
        end
        function set.CenterFrequencyPhyC(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'positive','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',70e6,'<=',6e9}, ...
                '', 'CenterFrequency');
            obj.CenterFrequencyPhyC = value;
            if obj.ConnectedToDevice
                id = 'altvoltage0';
                obj.setAttributeLongLong(id,'frequency',value,true,'adrv9009-phy-c');
            end
        end
        function set.CenterFrequencyPhyD(obj, value)
            validateattributes( value, { 'double','single' }, ...
                { 'real', 'positive','scalar', 'finite', 'nonnan', 'nonempty','integer','>=',70e6,'<=',6e9}, ...
                '', 'CenterFrequency');
            obj.CenterFrequencyPhyD = value;
            if obj.ConnectedToDevice
                id = 'altvoltage0';
                obj.setAttributeLongLong(id,'frequency',value,true,'adrv9009-phy-d');
            end
        end
        function calibratePhy(obj)
            if obj.ConnectedToDevice
            	obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy');
            end
        end
        function calibratePhyB(obj)
            if obj.ConnectedToDevice
            	obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy-b');
            end
        end
        function calibratePhyC(obj)
            if obj.ConnectedToDevice
            	obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy-c');
            end
        end
        function calibratePhyD(obj)
            if obj.ConnectedToDevice
            	obj.setDeviceAttributeRAW('calibrate',num2str(true),'adrv9009-phy-d');
            end
        end
    end

    %% API Functions
    methods (Hidden, Access = protected)

        function icon = getIconImpl(obj)
            icon = sprintf(['ADRV9009 ',obj.Type]);
        end
    end

    %% External Dependency Methods
    methods (Hidden, Static)

        function tf = isSupportedContext(bldCfg)
            tf = matlabshared.libiio.ExternalDependency.isSupportedContext(bldCfg);
        end

        function updateBuildInfo(buildInfo, bldCfg)
            % Call the matlabshared.libiio.method first
            matlabshared.libiio.ExternalDependency.updateBuildInfo(buildInfo, bldCfg);
        end

        function bName = getDescriptiveName(~)
            bName = 'ADRV9009';
        end

    end
end
