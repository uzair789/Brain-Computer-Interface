function [X,y]=createData1(name)
%This function creates X and y by randomly shuffling the columns in the
%dataset.
a = load(name);
X_unshuffled = [a.class{1} a.class{2}];% b.class{1} b.class{2}];
y_unshuffled = [ones(1,120) -1*ones(1,120)];% ones(1,120) -1*ones(1,120)];
rand_pos = randperm(size(X_unshuffled,2),size(X_unshuffled,2));%randperm(240,240)

%shuffling the data
X = X_unshuffled(:,rand_pos);
y = y_unshuffled(:,rand_pos);
end