clear all;
tic;
training_set = 'feaSubEOvert.mat';
% training_set = 'feaSubEImg.mat';

[X,y] = createData2(training_set);

t=1000;
beta = 15;
T_max = 1000000;
tol = 0.000001;

%Finding the initial value
W = ones(204,1)*10;
C=100;
E = max((ones(size(X,2),1) - y' .* ((W'*X)' + C)),0)+0.001;

%creating the struct
setPara = struct('t',t,'beta',beta,'T_max',T_max,'tol',tol,'W',W,'C',C);

init_Z = [W;C;E];

%Cross-validation
[lambda]=getOptLambda(X,y,setPara)
error = [];
while(t<T_max)
    
    [optSolution, err] = solveOptProb_NM(init_Z,tol,t,lambda,X,y);
    error = [error; err];
    init_Z = optSolution;
    t=beta*t;
end
weights_opt =optSolution(1:204)
c_opt = optSolution(205)

show_chanWeights(abs(weights_opt))

%%Testing the Accuracy on teh second data set 
% test_set='feaSubEOvert.mat';
test_set = 'feaSubEImg.mat'

[correct_guesses,wrong_guesses,Acc]=testingAccuracy(test_set,weights_opt,c_opt)

fprintf('Training set used is %s\n',training_set);
fprintf('Test set used is %s\n',test_set);
fprintf('Correct Guesses = %d\n',correct_guesses);
fprintf('Wrong Guesses = %d\n',wrong_guesses);
fprintf('Testing Accuracy of the system : %f\n',Acc)
toc;




