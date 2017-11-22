function comb = genCombinations(A, B)
% generate a matrix which gives all combinations of rows in A and rows
% in B

% 10/13/2017, Xiuyun Wu

idx = 1;
for ii = 1:size(A, 1)
    for jj = 1:size(B, 1)
        comb(idx, :) = [A(ii, :) B(jj, :)];
        idx = idx+1;
    end
end

end