function [F, G, H] = costFcn(Z,t,lambda,X,y)
% Compute the cost function F(Z)
%
% INPUTS: 
%   Z: Parameter values
% OUTPUTS
%   F: Function value
%   G: Gradient value
%   H: Hessian value
%
% @ 2011 Kiho Kwak -- kkwak@andrew.cmu.edu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To improve the excution speed, please program your code with matrix
% format. It is 30 times faster than the code using the for-loop.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

W = Z(1:204);%1x204
C = Z(205);%1x1
E = Z(206:end);%240x1

%Computing F
sum_1 = sum(log(  (W'*X)'.* y' + C .* y' + E - ones(size(X,2),1)));
sum_2 = sum(log(E));

F = sum(E) + lambda * W' * W - (1/t)*sum_1 - (1/t)*sum_2;

%Computing the Gradient
S = ( W'*X .* y + C .* y + E'- ones(1,size(X,2)) ).^(-1);
U = S .* (1/t);
V = U .* y;

df_by_dW = (2*lambda .* W) - (V*X')'; 
df_by_dC = (-1) .* V * ones(size(X,2),1);
df_by_dE = ones(size(X,2),1) - U' - (1/t).* (E.^(-1));

G = [df_by_dW;df_by_dC;df_by_dE];

%Computing the Hessian

V2 = (V.^(2) .*t);

d2f_by_dC2 = V2 * ones(size(X,2),1);
V3 = V.*S;
d2f_by_dCdE = (V3)';

R = S'.^(2);

d2f_by_dE2 = diag((1/t) .* R + (1/t) .* (E.^(-1)).^2);

%Computing d2f_by_dW2

for k = 1:204
    Xp = repmat(X(k,:)' , [1 204]);
    XpXT = Xp .* X';
    W_hess(k,:) = V2 * XpXT;
    
end

e=repmat(2*lambda,[204 1]);
W_hess = W_hess + diag(e); 
d2f_by_dW2 = W_hess;

d2f_by_dWdC = (V2*X')';
d2f_by_dWdE = repmat(V3,[204 1]) .* X;

H = [d2f_by_dW2 d2f_by_dWdC d2f_by_dWdE;
    d2f_by_dWdC' d2f_by_dC2 d2f_by_dCdE';
    d2f_by_dWdE' d2f_by_dCdE d2f_by_dE2];
% toc;
end