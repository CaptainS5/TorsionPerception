function [] = checkValues(editField, minimum, maximum, defaultValue, precision)

%if non-numeric input is given: set default value
if(isnan(str2double(get(editField, 'String'))))
    set(editField, 'String', num2str(defaultValue));
end
%if input is greater than maximum: set to maximum
if(str2double(get(editField, 'String'))>maximum)
    set(editField, 'String', num2str(maximum));
end
%if input is smaller than minimum: set to minimum
if(str2double(get(editField, 'String'))<minimum)
    set(editField, 'String', num2str(minimum));
end
%round
currentValue = str2double(get(editField, 'String'));
roundingFactor = 10^precision;
currentValue = round(currentValue*roundingFactor)/roundingFactor;
set(editField, 'String',num2str(currentValue));
end