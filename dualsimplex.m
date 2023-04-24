clc;

variables={'x1','x2','x3','s1','s2','sol'};
cost = [-2 0 -1 0 0 0];
info = [-1 -1 1;-1 2 -4];
b = [-5;-8];
s = eye(size(info,1));
A = [info s b];

BV =[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i) == s(:,j)
            BV = [BV i];
        end
    end
end
B = A(:,BV);
A = inv(B)*A;
zjcj = cost(BV)*A - cost;
zcj = [zjcj;A];
simpTable = array2table(zcj);
simpTable.Properties.VariableNames(1:size(zcj,2)) = variables;
run = true;
while run 
    sol = A(:,end);
    if any(sol<0)
        fprintf('The current BFS is not feasible \n');
    
        [Leavin, pvtrow] = min(sol);
        fprintf('Leaving Row = %d \n',pvtrow);
    
        row = A(pvtrow,1:end-1);
        zj = zjcj(:,1:end-1);
    for i=1:size(row,2)
        if row(i)<0
            ratio(i) = abs(zj(i)./row(i));
        else
            ratio(i) = inf;
        end
    end
    [minVal, pvtcol] = min(ratio);
    fprintf('Entering variable = %d \n',pvtcol);
    
    BV(pvtrow) = pvtcol;
    fprintf('Basic Variables =');
    disp(variables(BV));
    pvtkey = A(pvtrow,pvtcol);
    A(pvtrow,:) = A(pvtrow,:)./pvtkey;
    for i=1:size(A,1)
        if i~=pvtrow
            A(i,:) = A(i,:) - A(i,pvtcol).*A(pvtrow,:);
        end
    end
    zjcj = cost(BV)*A - cost;
    zcj = [zjcj;A];
    simpTable = array2table(zcj);
    simpTable.Properties.VariableNames(1:size(zcj,2)) = variables;
    else
        run = false;
        fprintf('The feasible solution is \n');
        disp(simpTable);
    end
end