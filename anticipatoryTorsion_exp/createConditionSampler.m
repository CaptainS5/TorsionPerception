
function [conditionSampler] = createConditionSampler(possibleConditions, trialsPerCondition)


%% setup
numberOfCombinations = prod(possibleConditions);
randomConditionSampler = randperm(numberOfCombinations*trialsPerCondition);
randomConditionSampler = mod(randomConditionSampler,numberOfCombinations)+1;

%% special case if there are only two conditions
if numberOfCombinations == 2
    
    
    start = randi(2);
    conditionSampler = (1:numberOfCombinations*trialsPerCondition);
    conditionSampler = conditionSampler + start;
    conditionSampler = mod(conditionSampler,2)+1;
    
    
else
    %% for more than 2 possible conditions
    
    %1) eliminate similar neighbors
    odd = [true diff(randomConditionSampler) ~= 0];
    conditionSampler = randomConditionSampler(odd);   
    randomConditionSampler = randomConditionSampler(~odd);
    
    %2) insert the eliminated neighbors at random positions
    while ~isempty(randomConditionSampler)
        
        random = randi([2 length(conditionSampler)-1]);
        if conditionSampler(random) ~= randomConditionSampler(1) && conditionSampler(random+1) ~= randomConditionSampler(1);
            conditionSampler = [conditionSampler(1:random) randomConditionSampler(1) conditionSampler(random+1:length(conditionSampler))];
            randomConditionSampler = randomConditionSampler(2:length(randomConditionSampler));
        end
        
        
    end
    
end

end