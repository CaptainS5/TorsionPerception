function [data] = socscalexy(data)
% SOCSCALEXY recomputes position from pixel to degrees of visual angle, and
% flips traces, if applicable; filtering is also done here

% file checked and corrected on 05/31/11

%% set up filter
sample_freq = 200;
filt_freq = sample_freq/2;
filt_order = 2;
filt_cutoff_pos = 15;
filt_cutoff_vel = 30;

[a,b] = butter(filt_order,filt_cutoff_pos/filt_freq);
[c,d] = butter(filt_order,filt_cutoff_vel/filt_freq);

%% position
data.X_filt = filtfilt(a,b,data.X);
data.Y_filt = filtfilt(a,b,data.Y);
data.T_filt = filtfilt(a,b,data.T);

%% velocity
data.DX = diff(data.X)*sample_freq;
data.DY = diff(data.Y)*sample_freq;
data.DT = diff(data.T)*sample_freq;

DX_tmp = diff(data.X_filt)*sample_freq;
data.DX_filt = filtfilt(c,d,DX_tmp);

DY_tmp = diff(data.Y_filt)*sample_freq;
data.DY_filt = filtfilt(c,d,DY_tmp);

DT_tmp = diff(data.T_filt)*sample_freq;
data.DT_filt = filtfilt(c,d,DT_tmp);

%% acceleration
%DDX = diff(data.DX); % hier nicht nochmal *sample_freq (7.9.07)
%DDY = diff(DY);

DDX_tmp = diff(data.DX_filt)*sample_freq;
data.DDX_filt = filtfilt(c,d,DDX_tmp);

DDY_tmp = diff(data.DY_filt)*sample_freq;
data.DDY_filt = filtfilt(c,d,DDY_tmp);

DDT_tmp = diff(data.DT_filt)*sample_freq;
data.DDT_filt = filtfilt(c,d,DDT_tmp);

%% jerk for detecting saccades and quick phases
data.DDDX = diff(data.DDX_filt)*sample_freq;
data.DDDY = diff(data.DDY_filt)*sample_freq;
data.DDDT = diff(data.DDT_filt)*sample_freq;

%% make sure all data series have the same length
data.DX = [data.DX; NaN];
data.DY = [data.DY; NaN];
data.DT = [data.DT; NaN];
data.DX_filt = [data.DX_filt; NaN];
data.DY_filt = [data.DY_filt; NaN];
data.DT_filt = [data.DT_filt; NaN];

data.DDX_filt = [data.DDX_filt; NaN; NaN];
data.DDY_filt = [data.DDY_filt; NaN; NaN];
data.DDT_filt = [data.DDT_filt; NaN; NaN];

data.DDDX = [data.DDDX; NaN; NaN; NaN];
data.DDDY = [data.DDDY; NaN; NaN; NaN];
data.DDDT = [data.DDDT; NaN; NaN; NaN];

end
