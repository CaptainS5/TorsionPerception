close all;
quickphases = results.saccades;
onsets = quickphases(1:2:length(quickphases),:);
offsets = quickphases(2:2:length(quickphases),:);
plot(quickphases(:,4),quickphases(:,12),'g*')
plot(onsets(:,4),onsets(:,11),'b*')
hold on
plot(offsets(:,4),offsets(:,11),'r*')
plot(quickphases(:,4),quickphases(:,12),'g*')

for i = 1:length(quickphases)
    
    x=[quickphases(i,4),quickphases(i,4)]
    y=[quickphases(i,11),quickphases(i,12)]
    plot(x,y,'k:');
    
end