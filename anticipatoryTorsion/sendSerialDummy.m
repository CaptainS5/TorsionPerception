classdef sendSerialDummy < handle
	%SENDSERIAL Connects and manages Serial port communication
	%   Connects and manages Serial port communication
	properties
		name='pci-serial0'
		baudRate=115200
		silentMode=0 %this allows us to be called even if no serial port is attached
		verbosity=1
		openNow=1 %allows the constructor to run the open method immediately
	end
	properties (SetAccess = private, GetAccess = public)
		portHandle
		deviceID
		toggleRTS=0 %keep the state here to toggle on succesive calls
		toggleDTR=0
	end
	properties (SetAccess = private, GetAccess = private)
		%defaultName='usbserial-A600drIC';
		defaultName = 'pci-serial0';
		allowedPropertiesBase='^(name|baudRate|silentMode|verbosity|openNow)$'
	end
	methods%------------------PUBLIC METHODS--------------%

		%==============CONSTRUCTOR============%
		function obj = sendSerial(args)
            disp(args.name);
            disp(args.openNow);
			obj.name = 'testname';
            obj.a = 3;
		end

		%===============OPEN PORT================%
		function open(obj)
		sprintf('test');
            
		end

		%===============FIND PORT================%
		function find(obj,name)
			if exist('name','var')
				if ischar(name)
					obj.name=name;
				end
			end
			obj.deviceID=FindSerialPort(obj.name,1,1);
			if isempty(obj.deviceID)
				obj.salutation('','Couldn''t find Serial Port, try the find method with another name');
				obj.silentMode=1;
			else
				obj.silentMode=0;
			end
		end

		%===============CLOSE PORT================%
		function close(obj)
			if ~isempty(obj.portHandle)
				IOPort('Verbosity', 4); %reset to default
				IOPort('Close', obj.portHandle);
				obj.portHandle=[];
			end
		end

		%===============SET RTS Line================%
		function setRTS(obj,value)
            if obj.silentMode==0
				if value==0 || value==1
					IOPort('ConfigureSerialPort', obj.portHandle, sprintf('RTS=%i', value));
				end
            end
        end
        
        function startRecording(obj)
            
        end
        
         function stopRecording(obj)
            
        end

		%===============TOGGLE RTS Line================%
		function toggleRTSLine(obj)
			if obj.silentMode==0
				IOPort('ConfigureSerialPort', obj.portHandle, sprintf('RTS=%i', obj.toggleRTS));
				obj.toggleRTS=~obj.toggleRTS;	
			end
		end

		%===============SET DTR Line================%
		function setDTR(obj,value)
			if obj.silentMode==0
				if value==0 || value==1
					IOPort('ConfigureSerialPort', obj.portHandle, sprintf('DTR=%i', value));
				end
			end
		end

		%===============TOGGLE DTR Line================%
		function toggleDTRLine(obj)
			if obj.silentMode==0
				IOPort('ConfigureSerialPort', obj.portHandle, sprintf('DTR=%i', obj.toggleDTR));
				obj.toggleDTR=~obj.toggleDTR;	
			end
		end
	end


	methods ( Access = private ) %----------PRIVATE METHODS---------%
		%===========Delete Method==========%
		function delete(obj)
			fprintf('sendSerial Delete method will automagically close connection if open...\n');
			obj.close;
		end

		%===========Salutation==========%
		function salutation(obj,in,message)
			if obj.verbosity > 0
				if ~exist('in','var')
					in = 'random user';
				end
				if exist('message','var')
					fprintf([message ' | ' in '\n']);
				else
					fprintf(['\nHello from ' obj.name ' | sendSerial\n\n']);
				end
			end
		end
	end
end