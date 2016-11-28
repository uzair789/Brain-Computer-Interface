function [correct_guesses,wrong_guesses,Acc]=testingAccuracy(test_set,weights,c)
[X,y]=createData2(test_set);

gTruths = y';
op_labels = (weights'*X)' + c;
op=zeros(size(op_labels,1),1);
correct_guesses = 0;
wrong_guesses = 0;
correct_guesses_positions = [];
wrong_guesses_positions = [];

for j = 1:size(op_labels,1)
    if op_labels(j)>=0
        op(j)=1;
    else
        op(j)=-1;
    end
    
    if op(j)==gTruths(j)
        correct_guesses = correct_guesses+1;
        correct_guesses_positions = [correct_guesses_positions;j];
    else
        wrong_guesses = wrong_guesses + 1;
        wrong_guesses_positions = [wrong_guesses_positions;j];
    
    end
end
Acc = correct_guesses / (correct_guesses + wrong_guesses);
end

