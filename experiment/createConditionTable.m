function [ conditionTable ] = createConditionTable(conditions)
% TODO: Clean
alength = length(conditions);
conditions(alength + 1) = 1;
alength = length(conditions);

conditionTable = ones(prod(conditions), alength);
conditionTable(:,1) = 0:prod(conditions)-1;

for i = 2:alength
    j = i-1;
    conditionTable(:,i) = floor(mod(conditionTable(:,1),prod(conditions(j:alength)))/prod(conditions(i:alength)));
end
conditionTable = conditionTable + 1;
end