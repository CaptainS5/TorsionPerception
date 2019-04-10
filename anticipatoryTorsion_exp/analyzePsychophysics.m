%% analyzePsychophysics
% Version June 28, 2013 (MS)

clear all; close all;

% read logfile (make sure it's the edited version with no text)
allData = load('111_SG_2013_June_28_edited.txt');

%% replaced: toRight = 1; toLeft = 2; CW = 1; CCW = 2; slower = 1; faster =
%% 2;

% rename variables
rotationaldir = allData(:,4);
rotationalspeed = allData(:,5);
judgment = allData(:,6);

% identify slower judgments
% all
all_1 = length(find(rotationalspeed==92&judgment==2));
all_2 = length(find(rotationalspeed==94&judgment==2));
all_3 = length(find(rotationalspeed==96&judgment==2));
all_4 = length(find(rotationalspeed==98&judgment==2));
all_5 = length(find(rotationalspeed==100&judgment==2));
all_6 = length(find(rotationalspeed==102&judgment==2));
all_7 = length(find(rotationalspeed==104&judgment==2));
all_8 = length(find(rotationalspeed==106&judgment==2));
all_9 = length(find(rotationalspeed==108&judgment==2));

% CW
CW_1 = length(find(rotationaldir==1&rotationalspeed==92&judgment==2));
CW_2 = length(find(rotationaldir==1&rotationalspeed==94&judgment==2));
CW_3 = length(find(rotationaldir==1&rotationalspeed==96&judgment==2));
CW_4 = length(find(rotationaldir==1&rotationalspeed==98&judgment==2));
CW_5 = length(find(rotationaldir==1&rotationalspeed==100&judgment==2));
CW_6 = length(find(rotationaldir==1&rotationalspeed==102&judgment==2));
CW_7 = length(find(rotationaldir==1&rotationalspeed==104&judgment==2));
CW_8 = length(find(rotationaldir==1&rotationalspeed==106&judgment==2));
CW_9 = length(find(rotationaldir==1&rotationalspeed==108&judgment==2));

% CCW
CCW_1 = length(find(rotationaldir==2&rotationalspeed==92&judgment==2));
CCW_2 = length(find(rotationaldir==2&rotationalspeed==94&judgment==2));
CCW_3 = length(find(rotationaldir==2&rotationalspeed==96&judgment==2));
CCW_4 = length(find(rotationaldir==2&rotationalspeed==98&judgment==2));
CCW_5 = length(find(rotationaldir==2&rotationalspeed==100&judgment==2));
CCW_6 = length(find(rotationaldir==2&rotationalspeed==102&judgment==2));
CCW_7 = length(find(rotationaldir==2&rotationalspeed==104&judgment==2));
CCW_8 = length(find(rotationaldir==2&rotationalspeed==106&judgment==2));
CCW_9 = length(find(rotationaldir==2&rotationalspeed==108&judgment==2));

% calculate proportion judgments "faster"
all_trials = 8;
CW_trials = 4;
CCW_trials = 4;

all_pfaster = [all_1/all_trials; all_2/all_trials; all_3/all_trials; all_4/all_trials; all_5/all_trials; all_6/all_trials; all_7/all_trials; all_8/all_trials; all_9/all_trials; all_10/all_trials; all_11/all_trials;]
CW_pfaster = [CW_1/CW_trials; CW_2/CW_trials; CW_3/CW_trials; CW_4/CW_trials; CW_5/CW_trials; CW_6/CW_trials; CW_7/CW_trials; CW_8/CW_trials; CW_9/CW_trials; CW_10/CW_trials; CW_11/CW_trials;]
CCW_pfaster = [CCW_1/CCW_trials; CCW_2/CCW_trials; CCW_3/CCW_trials; CCW_4/CCW_trials; CCW_5/CCW_trials; CCW_6/CCW_trials; CCW_7/CCW_trials; CCW_8/CCW_trials; CCW_9/CCW_trials; CCW_10/CCW_trials; CCW_11/CCW_trials;]

% plot results
plot(all_pfaster,'-*k'); hold on;
plot(CW_pfaster,'-*g');
plot(CCW_pfaster,'-*r');
%axis([0.9 5.1 0 1]);
legend('all','CW','CCW');
