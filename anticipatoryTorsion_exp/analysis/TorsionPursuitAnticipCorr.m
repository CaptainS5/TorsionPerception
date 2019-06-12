%% Get mean torsional velocity across trials and blocks and plot
% Austin Rothwell - November 20 2016



subjectlist = { '04' '05' '06' '07' '08' '09'};
rotDirList  = [   0    0    1    1    1    0 ];

totVals = [];
for subj = 1:length(subjectlist)
    
    % Enter subject details
    subject = subjectlist{subj};
    NaturalFirst = rotDirList(subj);
    blocklist = {'02' '04' '06' '08' '10' '12'};


    % Loop through all blocks and all trials for both eyes - choosing the data
    % from the eye with the most valid trials
    vals = [];
    Tvals = [];
    Xvals = [];

    for block = 1:6

        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_L.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);


        % get mean velocities for LEFT eye
        LTvels = [];
        LXvels = [];
        errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_L_errorFile.mat']);
        for n = 1:10
            for i = n*10-9:n*10
                if errors.errorStatus(i) == 0
                    LTvels = [LTvels mean(abs(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109)))];
                    LXvels = [LXvels mean(abs(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+109)))];
                end
            end
        end

        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        
        % get mean velocities for RIGHT eye
        RTvels = [];
        RXvels = [];
        errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        for n = 1:10
            for i = n*10-9:n*10
                if errors.errorStatus(i) == 0
                    RTvels = [RTvels mean(abs(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109)))];
                    RXvels = [RXvels mean(abs(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+109)))];
                end
            end
        end


        % Choose velocities from eye with most valid trials
        if length(LTvels) > length(RTvels)
%             disp(['Left eye torsion by smooth pursuit correlation: Block ' blocklist{block}])
            Tvals = [Tvals, LTvels];
            Xvals = [Xvals, LXvels];
    %         [R,p] = corrcoef(LTvels, LXvels);
    %         vals = [vals; (block*2),0,R(2),p(2)];
    %         f = figure();
    %         scatter(LTvels, LXvels);
        else
%             disp(['Right eye torsion by smooth pursuit correlation: Block ' blocklist{block}]) 
            Tvals = [Tvals, RTvels];
            Xvals = [Xvals, RXvels];

    %         [R,p] = corrcoef(RTvels, RXvels);
    %         vals = [vals; (block*2),1,R(2),p(2)];
    %         f = figure();
    %         scatter(RTvels, RXvels);
        end
    %         set(gcf,'color','w');
    %         title(['Correlation between torsion and smooth pursit anticipation: Block ' blocklist{block}], 'FontSize', 11)
    %         xlabel('Torsional Velocity (degs/sec)', 'fontsize', 10)
    %         ylabel('Horizontal Velocity (degs/sec)', 'fontsize', 10)
    %         saveas(f, ['subj' subject 'PursTorsionCorrBlock' blocklist{block} '.png'])
        if mod(block,2) == 0
            [R,p] = corrcoef(Tvals, Xvals);
            vals = [vals; (subj+3),length(Tvals),R(2),p(2)];
            Tvals = [];
            Xvals = [];
        end



    end

    if NaturalFirst
        vals;
    else
        vals = [vals(2,:);vals(1,:);vals(3,:)];
    end
    
    totVals = [totVals; vals];
  
end  

totVals
    