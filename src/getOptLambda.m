function optLambda = getOptLambda(X, y, setPara)
% Get the optimal lamda
%
% INPUTS:
%   X(MxN) : trData(i,j) is the i-th feature from the j-th trial
%   Y(Nx1): trData(j) is the label of the j-th trial (1 or -1)
%   setPara : Initialized parameters
%            setPara.t      
%            setPara.beta   
%            setPara.Tmax   
%            setPara.tol    
%            setPara.W      
%            setPara.C      
%
% OUTPUTS:
%   optiLamda: Optimal lamda value 
%
% @ 2011 Kiho Kwak -- kkwak@andrew.cmu.edu
tic;
t=setPara.t;
T_max=setPara.T_max;
beta = setPara.beta;
tol = setPara.tol;
W = setPara.W;
C = setPara.C;

X_Aug = [X;y];
%begin cross validation

%splitting X_Aug into 6 blocks
no_cols_pr_block = repmat(size(X,2)/6,1,6);
no_rows_pr_block = size(X_Aug,1);
blocks = mat2cell(X_Aug,no_rows_pr_block,no_cols_pr_block);
lambda = [0.01,1,100,1000,10000];

Acc_lev1=[];lambda_lev1=[];Z11=[];
for i = 1:size(blocks,2)
    blocks2 = blocks;
    test_set = blocks{i};
    blocks2{i}=[];
    training_set = cell2mat(blocks2);
    
    %second level cross validation
    blocks_lev2 = mat2cell(training_set,size(training_set,1),repmat(size(training_set,2)/5,1,5));
    Accuracy_lambda=[];
    for k = 1:length(lambda)
        Acc_lev2=[];
        for j = 1:size(blocks_lev2,2)
            blocks_lev2_2 = blocks_lev2;
            test_set_lev2 = blocks_lev2{j};
            blocks_lev2_2{j}=[];
            training_set_lev2 = cell2mat(blocks_lev2_2);
            X = training_set_lev2(1:204,:);
            y = training_set_lev2(205,:);
            E = max((ones(size(X,2),1) - y' .* ((W'*X)' + C)),0)+0.001;
            init_Z = [W; C; E];
            t1=t;
            while(t1<T_max)
                [optSolution, err] = solveOptProb_NM(init_Z,tol,t1,lambda(k),X,y);
                init_Z = optSolution;
                t1=beta*t1;
            end
            
            w =optSolution(1:204);
            X_test = test_set_lev2(1:204,:);
            y_test = test_set_lev2(205,:);
            label_gen = (w'*X_test)'+ optSolution(205);
            [pos_1]=find(label_gen>=0);
            [pos_2]=find(label_gen<0);
            label_gen(pos_1)=1;
            label_gen(pos_2)=-1;
            cor_guess = find(label_gen==y_test');
            no_cor=numel(cor_guess);
            acc = no_cor/size(y_test,2);
            Acc_lev2 = [Acc_lev2 acc];
        end
        Accuracy_lambda = [Accuracy_lambda mean(Acc_lev2)];
    end
    [~,pos]=max(Accuracy_lambda);
    opt_lambda_lev2 = lambda(pos);
    %computing the accuracy on the test set of level 1
    X = training_set(1:204,:);
    y = training_set(205,:);
    E = max((ones(size(X,2),1) - y' .* ((W'*X)' + C)),0)+0.001;
    init_Z = [W; C; E];
    t2=t;
         while(t2<T_max)
             [optSolution, err] = solveOptProb_NM(init_Z,tol,t2,opt_lambda_lev2,X,y);
             init_Z = optSolution;
             t2=beta*t2;
         end
    Z11 = [Z11 optSolution]
    w =optSolution(1:204);
    c=optSolution(205);
    X_test = test_set(1:204,:);
    y_test = test_set(205,:);
    label_gen = (w'*X_test)'+ c ;
    [pos_1]=find(label_gen>=0);
    [pos_2]=find(label_gen<0);
    label_gen(pos_1)=1;
    label_gen(pos_2)=-1;
    cor_guess = find(label_gen==y_test');
    no_cor = numel(cor_guess);
    acc = no_cor/size(y_test,2);
    Acc_lev1 = [Acc_lev1 acc];
    lambda_lev1 = [lambda_lev1 opt_lambda_lev2];
%     if i==1
% %         save('W and C for first fold 2 cd1','w','c');
%     end
end

[~,pos_lev1] = max(Acc_lev1)
optLambda = lambda_lev1(pos_lev1)
mean_Acc_lev1=mean(Acc_lev1)
std_Acc_lev1 = std(Acc_lev1)
Acc_lev1
lambda_lev1
optLambda
mean_Acc_lev1
std_Acc_lev1
% save('Values2_cd1.mat','Acc_lev1','lambda_lev1','optLambda','mean_Acc_lev1','std_Acc_lev1')
toc;
end
