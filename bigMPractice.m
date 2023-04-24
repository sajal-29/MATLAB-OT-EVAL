clc;
variables={'x1','x2','s1','s2','s3','a1','sol'};
M = 100;
cost = [-1 3 0 0 0 -M 0];
A = [1 2 -1 0 0 1 2;3 1 0 1 0 0 3; 1 0 0 0 1 0 4];
s = eye(size(A,1));
BV=[];
for i=1:size(s,2)
    for j=1:size(A,2)
        if A(:,j) == s(:,i)
            BV = [BV j];
        end
    end
end
zjcj = cost(BV)*A - cost;
zcj = [zjcj;A];
table = array2table(zcj);
table.Properties.VariableNames(1:size(zcj,2)) = variables;
run = true;
while run 
    zc = zjcj(:,1:end-1);
    if any(zc<0)
        fprintf('The current BFS is not optimal \n');
    
        [Entval,pvtcol] = min(zc);
        fprintf('The Entering column = %d \n',pvtcol);
    
        sol=A(:,end);
        column = A(:,pvtcol);
    
        if all(column<=0)
            fprintf('The solution is unbounded');
        else
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i) = sol(i)./column(i);
                else
                    ratio(i) = inf;
                end
            end
        end
        [minratio, pvtrow] = min(ratio);
        fprintf('The Leaving row = %d \n',pvtrow);
        BV(pvtrow) = pvtcol;
        pvtkey = A(pvtrow,pvtcol);
        A(pvtrow,:) = A(pvtrow,:)./pvtkey;
        for i=1:size(A,1)
            if i~=pvtrow
                A(i,:) = A(i,:) - A(i,pvtcol).*A(pvtrow,:);
            end
        end
        zjcj = cost(BV)*A-cost;
        zcj = [zjcj;A];
        simptable = array2table(zcj);
        simptable.Properties.VariableNames(1:size(simptable,2)) = variables;
    else
        run = false;
        fprintf('******Final Optimal table is******\n');
        disp(simptable);
    end
end


