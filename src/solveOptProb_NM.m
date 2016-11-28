% function [optSolution, err] = solveOptProb_NM(costFcn,init_Z,tol)
function [optSolution, err] = solveOptProb_NM(init_Z,tol,t,lambda,X,y)
% Compute the optimal solution using Newton method
%
% INPUTS:
%   costFcn: Function handle of F(Z)
%   init_Z: Initial value of Z
%   tol: Tolerance
%
% OUTPUTS:
%   optSolution: Optimal soultion
%   err: Errorr
%
% @ 2011 Kiho Kwak -- kkwak@andrew.cmu.edu

Z = init_Z;
err = 1;

while (err/2) > tol

[F, G, H] = costFcn(Z,t,lambda,X,y);

del_Z = - inv(H)*G;
err = G' * inv(H) * G;

s=1;
  
while(1)
        
   Z2 = Z + s .* del_Z;
   W = Z2(1:204);
   C = Z2(205);
   E = Z2(206:end);
   vec=(W'*X)'.* y' + C.*y' + E - 1;
   negetives=find(vec<0);
   negetives2 = find(E<0);
   n1=size(negetives,1);
   n2=size(negetives2,1);
   if(n1 ==0 && n2==0)
     break;
   else
     s=0.5*s;
   end
end
s;
Z = Z + s.*del_Z;
    
end
optSolution = Z;
end



