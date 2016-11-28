function [X,y] = createData2(name)
%This function creates X and y by alternating between 20 columns of each
%class.
a = load(name);
A1 = [a.class{1};ones(1,120)];
B1 = [a.class{2};-1*ones(1,120)];
blocks_A = mat2cell(A1,205, [20 20 20 20 20 20]);
blocks_B = mat2cell(B1,205,[20 20 20 20 20 20]);
merge=[];
for i = 1:6
    merge = [ merge blocks_A{i} blocks_B{i}];
end

X = merge(1:204,:);
y = merge(205,:);